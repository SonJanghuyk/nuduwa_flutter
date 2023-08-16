import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/repository/map_meeting_repository.dart';
import 'package:nuduwa_flutter/screens/map/bloc/map_meeting_bloc.dart';
import 'package:nuduwa_flutter/screens/nuduwa_app/bloc/user_meeting_bloc.dart';
import 'package:nuduwa_flutter/screens/nuduwa_app/cubit/location_permission_cubit.dart';
import 'package:nuduwa_flutter/components/nuduwa_colors.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool isCreate = false;

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => MapMeetingRepository(),
      child: BlocProvider(
        create: (context) => MapMeetingBloc(
            mapMeetingRepository: context.read<MapMeetingRepository>()),
        child: Scaffold(
          body: Stack(
            children: [
              // 위치 권한 블록
              BlocBuilder<LocationPermissionCubit, LocationPermissionState>(
                  builder: (_, locationState) {
                switch (locationState.status) {
                  case LocationPermissionStatus.initial:
                    return const Center(child: CircularProgressIndicator());

                  case LocationPermissionStatus.enabled:
                    return BlocListener<UserMeetingBloc, UserMeetingState>(
                      listener: (context, userMeetingState) {
                        if (userMeetingState.status ==
                            UserMeetingStatus.pause) {
                          context
                              .read<UserMeetingBloc>()
                              .add(UserMeetingResumed());
                        } else if (userMeetingState.status ==
                            UserMeetingStatus.loaded) {
                          context.read<MapMeetingBloc>().add(
                              MapMeetingUpdated(userMeetingState.userMeetings));
                        }
                      },
                      child: BlocBuilder<MapMeetingBloc, MapMeetingState>(
                        builder: (_, mapState) => GoogleMap(
                          onMapCreated: _onMapCreated,
                          initialCameraPosition: CameraPosition(
                            // 초기 지도 위치
                            target: locationState.currentLatLng!,
                            zoom: 15.0,
                          ),
                          compassEnabled: false,    // 나침판표시 비활성화
                          mapToolbarEnabled: false, // 클릭시 경로버튼 비활성화
                          myLocationEnabled: true,  // 내 위치 활성화
                          myLocationButtonEnabled:
                              false, // 내 위치 버튼 비활성화(따로 구현함)
                          zoomControlsEnabled: false, // 확대축소 버튼 비활성화
                          markers: mapState.meetingMarkers, // 지도 마커
                        ),
                      ),
                    );

                  case LocationPermissionStatus.denied ||
                        LocationPermissionStatus.error:
                    return Center(
                      child: Text(
                          '오류 위치 정보를 불러올 수 없습니다. ${locationState.errorMessage}'),
                    );
                }
              }),
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
        ),
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
        onPressed: () {
          context.read<UserMeetingBloc>().add(UserMeetingPaused());
        },
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
          onPressed: () {
            context.read<UserMeetingBloc>().add(UserMeetingResumed());
          },
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
