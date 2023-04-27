import 'dart:convert' as con;

import 'package:RideShare/data/model/user_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

import '../model/adress_model.dart';
import '../remote/home_api.dart';

class HomeRepository {
  final HomeApi _homeApi;

  HomeRepository({required HomeApi api}) : _homeApi = api;

  Future getAdressRemote({required String adress}) async {
    late List<AdressModel> result;
    result = await _homeApi.getAddress(adress.toLowerCase());
    result = result
        .where((element) =>
            element.adressTitle.toLowerCase().contains(adress.toLowerCase()))
        .toList();
    if (result.isNotEmpty) {
      return result;
    } else {
      String url =
          'http://api.positionstack.com/v1/forward?access_key=dc8c742118b1c0d9b3d0933ec2949da2&query=$adress';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        UrlDataModel model =
            UrlDataModel.fromJson(con.jsonDecode(response.body));

        model.address.removeWhere((element) => element.country != 'Pakistan');
        model.address.forEach((element) async {
          await _homeApi.saveAddress(element);
        });

        var res = await _homeApi.firestoreAdresses.get();
        result =
            await res.docs.map((e) => AdressModel.fromJson(e.data())).toList();
        result = result
            .where((element) => element.adressTitle.contains(adress))
            .toList();
        return result;
      } else {
        print(response.body);
      }
      return;
    }
  }

  Future addAdressLocally({required String adress}) async {
    late List<AdressModel> result;
    result = await _homeApi.getAddress(adress);
    result = result
        .where((element) => element.adressTitle.contains(adress))
        .toList();
    if (result.isNotEmpty) {
      return [];
    }
    return;
  }

  Future getDrivers(DateTime time, LatLng startLocation) async {
    List<DriverModel> drivers = await _homeApi.getAllDrivers(time);

    drivers.removeWhere((element) =>
        Geolocator.distanceBetween(
            startLocation.latitude,
            startLocation.longitude,
            element.startPoint.latitude,
            element.startPoint.longitude) <=
        10);

    // drivers.forEach((element) async {
    //   double distance =  Geolocator.distanceBetween(
    //       startLocation.latitude,
    //       startLocation.longitude,
    //       element.startPoint.latitude,
    //       element.startPoint.longitude);
    // });
    return drivers;
  }

  Future createARide(
      String driverEmail,
      DateTime startTime,
      LatLng pickUpLocation,
      LatLng dropOfLocation,
      int estimatedTime,
      double fare,
      int expectedFare) async {
    await _homeApi.createARide(driverEmail, startTime, pickUpLocation,
        dropOfLocation, estimatedTime, fare, expectedFare);
  }
}
