import 'package:RideShare/data/model/user_model.dart';
import 'package:RideShare/viewmodels/views/login_viewmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../model/adress_model.dart';

class HomeApi {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  late var firestoreAdresses = firestore.collection("addresses");
  late var firestoreDriver = firestore.collection("drivers");
  late var firestoreRide = firestore.collection("ride");

  Future getAddress(String Adress) async {
    var stream = await firestoreAdresses.get();
    List<AdressModel> model =
        stream.docs.map((e) => AdressModel.fromJson(e.data())).toList();
    return model;
  }

  Future saveAddress(AdressModel address) async {
    await firestoreAdresses
        .add({
          "label": address.adressTitle,
          "latitude": address.lat,
          "longitude": address.long
        })
        .then((value) => print(value.id))
        .catchError((e) => print(e));
  }

  Future getAllDrivers(DateTime time) async {
    var stream = await firestoreDriver.get();

    List<DriverModel> model =
        stream.docs.map((e) => DriverModel.fromJson(e.data())).toList();

    model.removeWhere((element) => element.startTime.isAfter(time));

    model.removeWhere(
        (element) => time.difference(element.startTime) > Duration(hours: 5));

    for (int i = 0; i < model.length; i++) {
      DocumentSnapshot userDetail = await FirebaseFirestore.instance
          .collection("users")
          .doc(model[i].id)
          .get();
      var r = userDetail.data()! as Map<String, dynamic>;
      model[i].user = UserModel.fromJson(r);
    }
    model.removeWhere(
        (element) => element.user?.email == LoginViewModel.signedINUser.email);
    return model;
  }

  Future createARide(
      String driverEmail,
      DateTime startTime,
      LatLng pickUpLocation,
      LatLng dropOfLocation,
      int estimatedTime,
      double fare,
      int expectedFare) async {
    await firestoreRide.add({
      "driverEmail": driverEmail,
      "passengerEmail": LoginViewModel.signedINUser.email,
      "startTime": startTime,
      "estimatedTimeInMinute": estimatedTime,
      "emtimatedFare": fare,
      "ExpectedFare": expectedFare,
      "pickUpLocationLat": pickUpLocation.latitude,
      "pickUpLocationLong": pickUpLocation.longitude,
      "dropOfLocationLat": dropOfLocation.latitude,
      "dropOfLocationLong": dropOfLocation.longitude,
      "RideIsActive": false,
      "createdAt": DateTime.now()
    });
  }
}
