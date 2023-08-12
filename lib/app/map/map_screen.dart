import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/components/nuduwa_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool isCreate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              // 초기 지도 위치
              target: _center,
              zoom: 15.0,
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Stack(
                children: [
                  // 필터 버튼
                  filterButton(),

                  // 모임만들기 버튼
                  createMeetingButton(),

                  // 현재위치로 이동 버튼
                  moveCurrentLocationButton(),

                  // 모임 생성 버튼
                  if (isCreate) seletedLocationButton()
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Align filterButton() {
    return Align(
      alignment: Alignment(Alignment.topLeft.x, Alignment.topLeft.y),
      child: IntrinsicWidth(
        child: Container(
          height: 50,
          decoration: BoxDecoration(
            color: NuduwaColors.fliter,
            borderRadius: BorderRadius.circular(100),
          ),
          child: PopupMenuButton<String>(
            padding: EdgeInsets.zero,
            color: NuduwaColors.fliter,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            itemBuilder: (BuildContext context) => [
              filterMenuItem(context),
              filterMenuItem(context),
            ],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  '아무나',
                  style: buttonTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  Align createMeetingButton() {
    return Align(
      alignment: Alignment(Alignment.topRight.x, Alignment.topRight.y),
      child: SizedBox(
        width: !isCreate ? 150 : 80,
        height: 50,
        child: FloatingActionButton(
          heroTag: 'btnCreateMeeting',
          backgroundColor:
              !isCreate ? NuduwaColors.floatingBackground : Colors.red,
          onPressed: () => setState(() => isCreate = isCreate ? false : true),
          child: Text(!isCreate ? '모임만들기' : '취소', style: buttonTextStyle),
        ),
      ),
    );
  }

  Align moveCurrentLocationButton() {
    return Align(
      alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y),
      child: FloatingActionButton(
        heroTag: 'btnCurrentLocation',
        backgroundColor: NuduwaColors.floatingBackground,
        onPressed: () {},
        child: const Icon(
          Icons.navigation,
          size: 40,
          color: NuduwaColors.floatingIcon,
        ),
      ),
    );
  }

  Align seletedLocationButton() {
    return Align(
      alignment: Alignment(Alignment.bottomCenter.x, Alignment.bottomCenter.y),
      child: SizedBox(
        width: 150,
        height: 40,
        child: FloatingActionButton(
          heroTag: 'btnSeletedLocation',
          backgroundColor: NuduwaColors.floatingBackground,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5.0),
          ),
          onPressed: () {},
          child: Text(
            '생성하기!',
            style: buttonTextStyle,
          ),
        ),
      ),
    );
  }

  PopupMenuItem<String> filterMenuItem(BuildContext context) {
    return PopupMenuItem<String>(
      onTap: () {},
      child: Center(
        child: Text(
          '전체',
          style: buttonTextStyle,
        ),
      ),
    );
  }

  TextStyle get buttonTextStyle => const TextStyle(
        fontSize: 30,
        color: NuduwaColors.floatingIcon,
      );
}
