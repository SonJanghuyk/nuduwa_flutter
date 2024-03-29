import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:http/http.dart' as http;

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/components/assets.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/bloc/map_bloc.dart';

class MapHelper {
  MapHelper({required DrawIconOfMeeting drawIconOfMeeting}) : _drawIconOfMeeting = drawIconOfMeeting;

  final DrawIconOfMeeting _drawIconOfMeeting;
  late Map<IconColors, ui.Image> _iconFrames;
  late Map<IconColors, BitmapDescriptor> _loadingIcons;
  final Completer<Map<IconColors, BitmapDescriptor>> completer = Completer();
  bool isInit = false;

  Future<void> initializeVariables() async {
    if (isInit) return;
    
    // 지도에서 쓸 아이콘 생성
    _iconFrames = await _drawIconFrames();
    _loadingIcons = await _drawLoadingIcons(_iconFrames);
    isInit = true;    
  }

  /// 지도에 보여줄 아이콘 이미지 미리 만들어놓기
  Future<Map<IconColors, ui.Image>>
      _drawIconFrames() async {
    final futureIconFrames = {
      for (final color in IconColors.values)
        color : _drawIconOfMeeting.drawIconFrame(color.color)
    };
    final iconFrames = Map.fromIterables(
        futureIconFrames.keys, await Future.wait(futureIconFrames.values));

    return iconFrames;
  }
  Future<Map<IconColors, BitmapDescriptor>>
      _drawLoadingIcons(Map<IconColors, ui.Image> iconFrames) async {
    // 웹 이미지 가져오는동안 보여줄 아이콘
    final loadingIcons = await _drawIconOfMeeting.drawLoadingIcons(iconFrames);

    return loadingIcons;
  }

  Marker creatLoadingMarker({
    required Meeting meeting,
    required IconColors iconColor,
    required VoidCallback onTap,
  }) {
    final loadingIcon = _loadingIcons[iconColor]!;

    // 우선 로딩아이콘으로 마커표시
    final markerForLoading = Marker(
      markerId: MarkerId(meeting.id!),
      position: meeting.location,
      icon: loadingIcon,
      onTap: onTap,
    );

    return markerForLoading;
  }

  BitmapDescriptor loadingIcon(
    IconColors iconColor,
  ) {
    final loadingIcon = _loadingIcons[iconColor]!;

    return loadingIcon;
  }

  Future<Marker> fetchMeetingMarker({
    required MarkerState markerState,
  }) async {
    try {
      // Marker 이미지를 가져온 HostImage로 교체
      final icon = await _drawIconOfMeeting.drawMeetingIcon(
          markerState.hostImageUrl, _iconFrames[markerState.iconColor]!);

      // Web이미지로 마커 새로 그리기
      final newMarker = markerState.marker.copyWith(
        iconParam: icon,
      );

      return newMarker;
    } catch (e) {
      debugPrint('에러!fetchHostData: ${e.toString()}');
      rethrow;
    }
  }
}

enum IconColors {
  host(Colors.red),
  join(Colors.green),
  defalt(Colors.blue);

  final Color color;
  const IconColors(this.color);
}

class DrawIconOfMeeting {
  double imageSize; // 이미지 크기
  double borderWidth; // 테두리 두께
  double triangleSize; // 하단 꼭지점 크기

  DrawIconOfMeeting({
    required this.imageSize,
    required this.borderWidth,
    required this.triangleSize,
  });

  /// 로딩중 지도에 표시할 아이콘 만들기
  Future<Map<IconColors, BitmapDescriptor>> drawLoadingIcons(
      Map<IconColors, ui.Image> iconImages) async {
    // 웹 이미지 가져오는동안 보여줄 이미지
    final image = await _loadingImage();

    // image와 iconImages를 합쳐서 Marker 아이콘 만들기
    final loadingIconImages = await Future.wait([
      for (var iconImage in iconImages.values) _drawIcon(image, iconImage),
    ]);

    // loadingIconImages로 만들걸 쓰기 쉽게 Map으로 변환
    final loadingIcons = {
      for (var index = 0; index < loadingIconImages.length; index++)
        iconImages.keys.toList()[index]: loadingIconImages[index],
    };

    return loadingIcons;
  }

  /// 지도에 표시할 아이콘 만들기
  Future<BitmapDescriptor> drawMeetingIcon(
      String? imageUrl, ui.Image iconImage) async {
    final imageData = await downloadImage(imageUrl);
    return await _drawIcon(imageData, iconImage);
  }

  /// 웹에서 이미지 다운로드 없으면 NoImage 이미지 넣기
  static Future<Uint8List> downloadImage(String? imageUrl) async {
    if (imageUrl == null) {
      final ByteData assetData = await rootBundle.load(Assets.imageNoImage);
      return assetData.buffer.asUint8List();
    } else {
      final imageData = await http.get(Uri.parse(imageUrl));
      return imageData.bodyBytes;
    }
  }

  /// imageData와 iconImages를 합쳐서 Marker 아이콘 만들기
  Future<BitmapDescriptor> _drawIcon(
      Uint8List imageData, ui.Image iconImage) async {
    final codec = await ui.instantiateImageCodec(imageData);
    final frameInfo = await codec.getNextFrame();
    // imageData 원모양으로 그리기
    final meetingImage = await _drawCircleImage(frameInfo, imageSize);
    final ui.Image markerImage = await _overlayImages(meetingImage, iconImage);

    // BitmapDescriptor 생성
    final ByteData? byteData =
        await markerImage.toByteData(format: ui.ImageByteFormat.png);
    final Uint8List resizedImageData = byteData!.buffer.asUint8List();
    final BitmapDescriptor bitmapDescriptor =
        BitmapDescriptor.fromBytes(resizedImageData);
    return bitmapDescriptor;
  }

  /// 웹이미지 가져오는 동안 표시될 이미지
  Future<Uint8List> _loadingImage() async {
    final ByteData assetData = await rootBundle.load(Assets.imageLoading);
    return assetData.buffer.asUint8List();
  }

  /// 이미지 원 모양으로 만들기
  Future<ui.Image> _drawCircleImage(
      ui.FrameInfo frameInfo, double imageSize) async {
    final ui.Image image = frameInfo.image;
    final int imageLength = image.width > image.height
        ? image.height
        : image.width; // 이미지 가로세로 중 짧은 길이

    final double scale = imageSize / imageLength;

    // 이미지 중심좌표
    final ui.Rect srcRect = ui.Rect.fromLTRB(
        (image.width.toDouble() - imageLength) / 2,
        (image.height.toDouble() - imageLength) / 2,
        imageLength.toDouble(),
        imageLength.toDouble());
    // 이미지 크기
    final ui.Rect destRect =
        ui.Rect.fromLTWH(0.0, 0.0, imageLength * scale, imageLength * scale);
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvasImage = Canvas(pictureRecorder);
    final Paint paint = Paint()..isAntiAlias = true;

    final double center = imageSize / 2;

    // 원그리기
    canvasImage.drawCircle(Offset(center, center), center, paint);
    // 이미지 그리기
    paint.blendMode = BlendMode.srcIn;
    canvasImage.drawImageRect(image, srcRect, destRect, paint);

    final ui.Image webImage = await pictureRecorder
        .endRecording()
        .toImage(imageSize.toInt(), imageSize.toInt());

    return webImage;
  }

  /// 이미지 2개 겹치는 함수
  Future<ui.Image> _overlayImages(
      ui.Image foreground, ui.Image background) async {
    final double backgroundWidth = background.width.toDouble();
    final double backgroundHeight = background.height.toDouble();
    final double foregroundWidth = foreground.width.toDouble();
    final double foregroundHeight = foreground.height.toDouble();

    final double backgroundSize =
        backgroundWidth > backgroundHeight ? backgroundHeight : backgroundWidth;

    final double offsetX = (backgroundSize - foregroundWidth) / 2;
    final double offsetY = (backgroundSize - foregroundHeight) / 2;

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);

    // 큰 이미지 그리기
    canvas.drawImage(background, Offset.zero, Paint());

    // 작은 이미지 그리기
    canvas.drawImage(foreground, Offset(offsetX, offsetY), Paint());

    final ui.Picture picture = pictureRecorder.endRecording();

    final ui.Image overlayedImage = await picture.toImage(
        backgroundWidth.toInt(), backgroundHeight.toInt());

    return overlayedImage;
  }

  /// 아이콘이미지 만드는 함수
  Future<ui.Image> drawIconFrame(Color color) async {
    final double iconSize = imageSize + (borderWidth * 2); // 아이콘 크기

    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvasIcon = Canvas(pictureRecorder);
    final Paint redCirclePaint = Paint()..color = color;

    final double iconCenter = imageSize / 2 + borderWidth;
    // 세모 그리기
    final ui.Path trianglePath = ui.Path()
      ..moveTo(iconCenter, iconCenter * 2 + triangleSize) // 세모의 하단 꼭지점 시작점
      ..lineTo(iconCenter / 2, iconCenter + iconCenter * 2 / 3) // 좌측 꼭지점
      ..lineTo(iconCenter + iconCenter / 2,
          iconCenter + iconCenter * 2 / 3) // 우측 꼭지점
      ..close(); // 세모 완성

    canvasIcon.drawCircle(
        Offset(iconCenter, iconCenter), iconCenter, redCirclePaint);
    canvasIcon.drawPath(trianglePath, redCirclePaint);

    final ui.Image iconImage = await pictureRecorder
        .endRecording()
        .toImage(iconSize.toInt(), iconSize.toInt() + triangleSize.toInt());

    return iconImage;
  }
}
