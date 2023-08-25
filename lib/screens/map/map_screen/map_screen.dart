import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/components/utils/map_helper.dart';
import 'package:nuduwa_flutter/models/meeting.dart';
import 'package:nuduwa_flutter/repository/meeting_repository.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/bloc/map_bloc.dart';
import 'package:nuduwa_flutter/screens/map/map_screen/bloc/meeting_of_map_bloc.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/create_meeting_sheet.dart';
import 'package:nuduwa_flutter/screens/map/meeting_create_sheet/cubit/create_meeting_cubit.dart';
import 'package:nuduwa_flutter/screens/main_app/bloc/user_meeting_bloc.dart';
import 'package:nuduwa_flutter/screens/main_app/cubit/location_permission_cubit.dart';
import 'package:nuduwa_flutter/components/nuduwa_colors.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => MeetingOfMapBloc(
            meetingRepository: context.read<MeetingRepository>(),
          ),
        ),
        BlocProvider(
          create: (context) => MapBloc(
            mapHelper: MapHelper(
              drawIconOfMeeting: DrawIconOfMeeting(
                imageSize: !kIsWeb ? 80.0 : 26.666,
                borderWidth: !kIsWeb ? 10.0 : 3.333,
                triangleSize: !kIsWeb ? 30.0 : 10.0,
              ),
            ),
          ),
        ),
      ],
      child: Stack(
        children: [
          // 위치 권한 체크
          BlocBuilder<LocationPermissionCubit, LocationPermissionState>(
            builder: (context, locationState) {
              switch (locationState.status) {
                case LocationPermissionStatus.initial:
                  return const Center(child: CircularProgressIndicator());

                case LocationPermissionStatus.denied:
                case LocationPermissionStatus.error:
                  return Center(
                    child: Text(
                        '오류 위치 정보를 불러올 수 없습니다. ${locationState.errorMessage}'),
                  );

                case LocationPermissionStatus.enabled:
                  context.read<MapBloc>().add(MapInitiatedCenter(
                      context, locationState.currentLatLng!));
                  return BlocListener<UserMeetingBloc, UserMeetingState>(
                    listener: (context, userMeetingState) {
                      if (userMeetingState.status != UserMeetingStatus.stream) {
                        context
                            .read<UserMeetingBloc>()
                            .add(UserMeetingResumed());
                        context.read<MapBloc>().add(
                            MapMarkerUpdated(userMeetingState.userMeetings));
                      }
                    },
                    child: BlocListener<MeetingOfMapBloc, MeetingOfMapState>(
                      listener: (context, state) {
                        context
                            .read<MapBloc>()
                            .add(MapMarkerListened(state.meetings));
                      },
                      child: BlocBuilder<MapBloc, MapState>(
                          builder: (context, mapState) {
                        if (mapState.status == MapStatus.loading) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }

                        return GoogleMap(
                          onMapCreated: (controller) => context
                              .read<MapBloc>()
                              .add(MapCreated(controller)),
                          initialCameraPosition: CameraPosition(
                            // 초기 지도 위치
                            target: locationState.currentLatLng!,
                            zoom: 15.0,
                          ),
                          compassEnabled: false, // 나침판표시 비활성화
                          mapToolbarEnabled: false, // 클릭시 경로버튼 비활성화
                          myLocationEnabled: true, // 내 위치 활성화
                          myLocationButtonEnabled:
                              false, // 내 위치 버튼 비활성화(따로 구현함)
                          zoomControlsEnabled: false, // 확대축소 버튼 비활성화
                          markers: mapState.markers.values
                              .map((e) => e.marker)
                              .toSet(), // 지도 마커
                          onCameraMove: (position) => context
                              .read<MapBloc>()
                              .add(MapMovedCenter(position)),
                        );
                      }),
                    ),
                  );
              }
            },
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: BlocSelector<
                      MapBloc,
                      MapState,
                      ({
                        bool isSelect,
                        LatLng? center,
                        MeetingCategory category
                      })>(
                  selector: (state) => (
                        isSelect: state.status == MapStatus.selected,
                        center: state.center,
                        category: state.category,
                      ),
                  builder: (context, state) {
                    final isSelect = state.isSelect;
                    final center = state.center;
                    final category = state.category;
                    return Stack(
                      children: [
                        // 필터 버튼
                        filterButton(context, category),

                        // 모임만들기 버튼
                        createMeetingButton(
                            onPressed: () => !isSelect
                                ? context
                                    .read<MapBloc>()
                                    .add(MapMarkerAddedCenter())
                                : context
                                    .read<MapBloc>()
                                    .add(MapMarkerRemovedCenter()),
                            isSelect: isSelect),

                        // 현재위치로 이동 버튼
                        moveCurrentLocationButton(
                            onPressed: () => context
                                .read<MapBloc>()
                                .add(MapMovedCurrentLatLng())),

                        // 모임 생성 버튼
                        if (isSelect)
                          seletedLocationButton(onPressed: () {
                            context
                                .read<MapBloc>()
                                .add(MapMarkerRemovedCenter());
                            createMeetingBottomSheet(context, center!);
                          })
                      ],
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }

  Align filterButton(BuildContext context, MeetingCategory category) {
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
              for (final category in MeetingCategory.values)
                filterMenuItem(context, category),
            ],
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  category.displayName == '전체' ? '필터' : category.displayName,
                  style: buttonTextStyle,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Align createMeetingButton(
      {required VoidCallback onPressed, required bool isSelect}) {
    return Align(
      alignment: Alignment(Alignment.topRight.x, Alignment.topRight.y),
      child: SizedBox(
        width: !isSelect ? 150 : 80,
        height: 50,
        child: FloatingActionButton(
          heroTag: 'btnCreateMeeting',
          backgroundColor:
              !isSelect ? NuduwaColors.floatingBackground : Colors.red,
          onPressed: onPressed,
          child: Text(!isSelect ? '모임만들기' : '취소', style: buttonTextStyle),
        ),
      ),
    );
  }

  Align moveCurrentLocationButton({required VoidCallback onPressed}) {
    return Align(
      alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y),
      child: FloatingActionButton(
        heroTag: 'btnCurrentLocation',
        backgroundColor: NuduwaColors.floatingBackground,
        onPressed: onPressed,
        child: const Icon(
          Icons.navigation,
          size: 40,
          color: NuduwaColors.floatingIcon,
        ),
      ),
    );
  }

  Align seletedLocationButton({required VoidCallback onPressed}) {
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
          onPressed: onPressed,
          child: Text(
            '생성하기!',
            style: buttonTextStyle,
          ),
        ),
      ),
    );
  }

  Future<void> createMeetingBottomSheet(
          BuildContext context, LatLng location) =>
      showModalBottomSheet(
        context: context,
        constraints: const BoxConstraints(maxWidth: 800),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(20.0),
          ),
        ),
        barrierColor: Colors.white.withOpacity(0),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        useSafeArea: true,
        builder: (context) => BlocProvider(
          create: (context) => CreateMeetingCubit(
            meetingRepository: MeetingRepository(),
            location: location,
          ),
          child: const CreateMeetingSheet(),
        ),
      );

  PopupMenuItem<String> filterMenuItem(
      BuildContext context, MeetingCategory category) {
    return PopupMenuItem<String>(
      onTap: () => context.read<MapBloc>().add(MapFilteredMeeting(category)),
      child: Center(
        child: Text(
          category.displayName,
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
