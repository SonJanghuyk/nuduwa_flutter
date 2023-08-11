import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          // 초기 지도 위치
          target: _center,
          zoom: 15.0,
        ),
      ),
      floatingActionButton: Stack(
        children: [
          // 필터 버튼
          filterButton(),

          // 모임만들기 버튼
          createMeetingButton(),

          // 현재위치로 이동 버튼
          moveCurrentLocationButton(),

          // 모임 생성 버튼
          if (true) seletedLocationButton()
        ],
      ),
    );
  }

  Align filterButton() {
    return Align();
  }

  Align createMeetingButton() {
    return Align();
  }

  Align moveCurrentLocationButton() {
    return Align(
      alignment: Alignment(Alignment.bottomRight.x, Alignment.bottomRight.y),
      child: FloatingActionButton(
        heroTag: 'btnCurrentLocation',
        backgroundColor: Colors.blue,
        onPressed: () {},
        child: const Icon(
          Icons.navigation,
          size: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Align seletedLocationButton() {
    return Align();
  }
}
