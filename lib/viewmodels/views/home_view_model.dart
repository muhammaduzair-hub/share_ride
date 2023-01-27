
import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../data/repository/home_repository.dart';
import '../base/base_model.dart';

class HomeViewModel extends BaseModel{
  final HomeRepository _homeRepository;

  HomeViewModel({required HomeRepository repo}):_homeRepository = repo, super(false);

  // late Position currentLocation;
  late Completer<GoogleMapController> mapController = Completer();
  late List<Marker> markers = [];
  late Position currentLocation;

  static bool driverMode = false;
  
  void switchDriverMode(bool newVal)async{
    driverMode = newVal;
    setBusy(false);
  }
  
  @override
  void dispose(){}

  onMapCreated(GoogleMapController controller) async{
    mapController.complete(controller);
  }

  Future<void> goToPositone() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(
        CameraUpdate.newCameraPosition(
            CameraPosition(
                target: LatLng(currentLocation.latitude,currentLocation.longitude),
                zoom: 12,
                tilt: 59.440
            )
        )
    );
  }

  Future getCurrentLocation() async{
    currentLocation = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    goToPositone();
    markers.add(
      Marker(
          markerId: MarkerId("c"),
          icon: BitmapDescriptor.defaultMarker,
        position: LatLng(currentLocation.latitude, currentLocation.longitude),
        visible: true,
      )
    );
    setBusy(false);
  }


}