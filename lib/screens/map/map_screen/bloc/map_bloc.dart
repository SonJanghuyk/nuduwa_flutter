import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:nuduwa_flutter/components/assets.dart';

part 'map_event.dart';
part 'map_state.dart';

class MapBloc extends Bloc<MapEvent, MapState> {
  MapBloc() : super(const MapState.initial()) {    
    on<MapInitiatedCenter>(_onInitiated);
    on<MapCreated>(_onMapCreated);
    on<MapSelectedNewMeetingLocation>(_onSelected);
    on<MapCanceledNewMeetingLocation>(_onCanceled);
    on<MapCreatedNewMeeting>(_onCreatedMeeting);
    on<MapMovedCenter>(_onMovedCenter);
    on<MapMovedCurrentLatLng>(_onMovedCurrentLatLng);
  }

  void _onMapCreated(MapCreated event, Emitter<MapState> emit) async {
    emit(state.copyWith(status: MapStatus.loading));
    final mapStyle = await rootBundle.loadString(Assets.txtGoogleMapStyle);
    final controller = event.controller;
    controller.setMapStyle(mapStyle);
    emit(state.copyWith(status: MapStatus.loaded, mapController: controller));
  }

  void _onInitiated(MapInitiatedCenter event, Emitter<MapState> emit) async {
    final center = event.center;
    emit(state.copyWith(center: center));
  }

  void _onSelected(MapSelectedNewMeetingLocation event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.selected));
  }

  void _onCanceled(MapCanceledNewMeetingLocation event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.loaded));
  }
  
  void _onCreatedMeeting(MapCreatedNewMeeting event, Emitter<MapState> emit) {
    emit(state.copyWith(status: MapStatus.loaded));
  }

  void _onMovedCenter(MapMovedCenter event, Emitter<MapState> emit) {
    final LatLng center = event.position.target;
    emit(state.copyWith(center: center));
  }

   void _onMovedCurrentLatLng(MapMovedCurrentLatLng event, Emitter<MapState> emit) async {
    final currentPosition = await Geolocator.getCurrentPosition();
    final controller = state.mapController;
    controller?.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(currentPosition.latitude, currentPosition.longitude),
        zoom: 15.0,
      ),
    ));
    emit(state.copyWith(mapController: controller));
  }

}
