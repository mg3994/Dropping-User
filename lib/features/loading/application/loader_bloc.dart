import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:restart_tagxi/core/utils/custom_snack_bar.dart';
import '../../../common/common.dart';
import '../../../di/locator.dart';
import 'usecase/loader_usecases.dart';

part 'loader_event.dart';
part 'loader_state.dart';

class LoaderBloc extends Bloc<LoaderEvent, LoaderState> {
  LoaderBloc() : super(LoaderInitialState()) {
    on<CheckPermissionEvent>(checkPermission);
    on<LoaderGetLocalDataEvent>(loadData);
    on<UpdateUserLocationEvent>(updateUserLocation);
  }

  bool? locationApproved;
   recheckLocationPerm() {
    add(LoaderGetLocalDataEvent());
  }

  Future<void> checkPermission(
      CheckPermissionEvent event, Emitter<LoaderState> emit) async {
    PermissionStatus permission;
    permission = await Permission.location.status;
    if (permission == PermissionStatus.denied ||
        permission == PermissionStatus.permanentlyDenied) {
      locationApproved = false;
      emit(LoaderUpdateState());
    } else {
      final loginStatus = await AppSharedPreference.getLoginStatus();
      if (loginStatus) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.low);
        double lat = position.latitude;
        double long = position.longitude;
        await serviceLocator<LoaderUsecase>()
            .updateUserLocation(currentLocation: LatLng(lat, long));
      }
      locationApproved = true;
      emit(LoaderLocationSuccessState());
    }
  }



  Future<void> loadData(
      LoaderGetLocalDataEvent event, Emitter<LoaderState> emit) async {
    final landingStatus = await AppSharedPreference.getLandingStatus();
    final loginStatus = await AppSharedPreference.getLoginStatus();
    final selectedLanguage =
        await AppSharedPreference.getSelectedLanguageCode();
    emit(LoaderSuccessState(
        loginStatus: loginStatus,
        landingStatus: landingStatus,
        selectedLanguage: selectedLanguage));
  }

  //  Locations
  Future<void> updateUserLocation(
      UpdateUserLocationEvent event, Emitter<LoaderState> emit) async {
    LocationPermission permission;
    permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double lat = position.latitude;
      double long = position.longitude;
      final data = await serviceLocator<LoaderUsecase>()
          .updateUserLocation(currentLocation: LatLng(lat, long));
      data.fold((error) {
        debugPrint(error.toString());
      }, (success) {
        debugPrint('location updated');
      });
    } else {
      await Permission.location.request();
      showToast(
          message: 'allow location permission to get your current location');
    }
  }


  
}
