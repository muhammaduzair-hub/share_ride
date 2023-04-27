import 'dart:async';

import 'package:RideShare/constants/strings.dart';
import 'package:RideShare/ui/shared/ui_helpers.dart';
import 'package:RideShare/viewmodels/views/login_viewmodel.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';

import '../../data/model/adress_model.dart';
import '../../data/model/user_model.dart';
import '../../data/model/vehical_model.dart';
import '../../data/repository/home_repository.dart';
import '../base/base_model.dart';

class HomeViewModel extends BaseModel {
  final HomeRepository _homeRepository;

  HomeViewModel({required HomeRepository repo})
      : _homeRepository = repo,
        super(false) {
    state = LabelSelectAdress;
    initializegroupList(localAdressTitles);
  }

  // late Position currentLocation;
  late Completer<GoogleMapController> mapController = Completer();
  late List<Marker> markers = [];
  late Position currentLocation;

  static bool driverMode = false;

  //varibles who are going to communicate with UI
  TextEditingController toController = TextEditingController();
  TextEditingController fromController =
      TextEditingController(text: "Humayun Tauqeer CUST, Islamabad, Pakistan");
  late String state;
  late String titleText;
  late List<AdressModel> adressList = [];
  late List<AdressModel> remoteAdressList = [];
  late List<String> localAdressTitles = [];
  late List<String> remoteAdressTitle = [];
  late List<VehicleModel> vehiclesList = [
    VehicleModel(
        vName: "Standard",
        vid: 1,
        vPic: 'asset/icons/standard.png',
        vRate: "\$5",
        vArrivingTime: "3 min"),
    VehicleModel(
        vName: "Van",
        vid: 2,
        vPic: 'asset/icons/van (1).png',
        vRate: "\$9",
        vArrivingTime: "5 min"),
    VehicleModel(
        vName: "Exec",
        vid: 3,
        vPic: 'asset/icons/exec.png',
        vRate: "\$7",
        vArrivingTime: "6 min"),
    VehicleModel(
        vName: "Electric ",
        vid: 4,
        vPic: 'asset/icons/electric.png',
        vRate: "\$5",
        vArrivingTime: "3 min"),
    VehicleModel(
        vName: "Eco",
        vid: 5,
        vPic: 'asset/icons/eco.png',
        vRate: "\$7",
        vArrivingTime: "7 min"),
    VehicleModel(
        vName: "Access",
        vid: 6,
        vPic: 'asset/icons/access.png',
        vRate: "\$5",
        vArrivingTime: "3 min"),
  ];
  late AdressModel from = AdressModel(
      adressTitle: "Humayun Tauqeer CUST, Islamabad, Pakistan",
      lat: 33.636683,
      long: 73.102777);
  late AdressModel to;
  late double distance;
  late double bill;
  late String generatedRide;
  late int addressSelection_FromSearchTextFieldInitialSize;
  late int addressSelection_ToSearchTextFieldInitialSize;
  final debouncer = Debouncer(milliseconds: 3000);
  late Map<String, List> groupList;
  DateTime selectedDateTime = DateTime.now();
  bool selectedfromTextField = true;
  bool checkToTextFieldval = false;
  late int selectedCardIndex = 0;
  int estimatedFare = 0;
  TextEditingController estimatedFareController = TextEditingController();
  List<String> selectedAddresses = [];
  List<DriverModel> drivers = [];
  int selectedDriverIndex = 0;
  final Key adressSelectionKey = Key("AdressSelection");
  final Key othersSheetKey = Key("Other");
  final Key cardSheet = Key("Card");

  //for disable button from list of vehicles in ride option state bottom sheet
  int vehicleSelectedIndex = 0;

  void switchDriverMode(bool newVal) async {
    driverMode = newVal;
    setBusy(false);
  }

  String dateFormatter() {
    var formatter = DateFormat('yyyy-MM-dd,hh:mm:ss a');
    String formattedDate = formatter.format(selectedDateTime);
    return formattedDate;
  }

  selectSearchItem(TextEditingController controller, String item) {
    controller.text = item;
    setBusy(false);
  }

  checkToTextField() {
    try {
      localAdressTitles.firstWhere((element) => element == toController.text);
      checkToTextFieldval = true;
    } catch (e) {
      try {
        remoteAdressTitle.firstWhere((element) => element == toController.text);
        checkToTextFieldval = true;
      } catch (e) {
        try {
          selectedAddresses
              .firstWhere((element) => element == toController.text);
          checkToTextFieldval = true;
        } catch (e) {
          checkToTextFieldval = false;
        }
      }
    }
    setBusy(false);
  }

  // checkFromTextField() {
  //   try {
  //     localAdressTitles.firstWhere((element) => element == fromController.text);
  //     selectedfromTextField = true;
  //   } catch (e) {
  //     try {
  //       remoteAdressTitle
  //           .firstWhere((element) => element == fromController.text);
  //       selectedfromTextField = true;
  //     } catch (e) {
  //       try {
  //         selectedAddresses
  //             .firstWhere((element) => element == fromController.text);
  //         selectedfromTextField = true;
  //       } catch (e) {
  //         selectedfromTextField = false;
  //       }
  //     }
  //   }
  //   setBusy(false);
  // }

  showonMap() async {
    // try {
    //   from = adressList
    //       .firstWhere((element) => element.adressTitle == fromController.text);
    // } catch (e) {
    //   from = remoteAdressList
    //       .firstWhere((element) => element.adressTitle == fromController.text);
    // }
    try {
      to = adressList
          .firstWhere((element) => element.adressTitle == toController.text);
    } catch (e) {
      to = remoteAdressList
          .firstWhere((element) => element.adressTitle == toController.text);
    }
    distance =
        await Geolocator.distanceBetween(to.lat, to.long, from.lat, from.long);
    distance = distance / 1000;
    bill = distance * 10;
    estimatedFare = bill.toInt();
    estimatedFareController.text = estimatedFare.toString();

    setBusy(false);
  }

  @override
  void dispose() {}

  onMapCreated(GoogleMapController controller) async {
    mapController.complete(controller);
  }

  Future<void> goToPositone() async {
    final GoogleMapController controller = await mapController.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 12,
        tilt: 59.440)));
  }

  Future getCurrentLocation() async {
    currentLocation = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    goToPositone();
    markers.add(Marker(
      markerId: MarkerId("c"),
      icon: BitmapDescriptor.defaultMarker,
      position: LatLng(currentLocation.latitude, currentLocation.longitude),
      visible: true,
    ));
    setBusy(false);
  }

  searchAdressOnTextField(String val) async {
    setBusy(true);
    try {
      adressList.firstWhere(
          (element) => element.adressTitle.toLowerCase() == val.toLowerCase());
      List<String> localTemp = [];
      localAdressTitles.forEach((element) {
        if (element.toLowerCase().contains(val.toLowerCase()))
          localTemp.add(element);
      });
      initializegroupList(localTemp);
      setBusy(false);
    } catch (e) {
      List<AdressModel> res =
          await _homeRepository.getAdressRemote(adress: val);

      remoteAdressList.addAll(res);
      remoteAdressTitle = [];
      res.forEach((element) {
        remoteAdressTitle.add(element.adressTitle);
      });
      List<String> localTemp = [];
      localAdressTitles.forEach((element) {
        if (element.toLowerCase().contains(element.toLowerCase()))
          localTemp.add(element);
      });
      if (remoteAdressTitle.isEmpty && localTemp.isEmpty)
        LoginViewModel.showToast("Enter Correct Address");
      initializegroupList(localTemp);
    }
    setBusy(false);
  }

  initializegroupList(List<String> local) {
    groupList = {
      if (remoteAdressTitle.isNotEmpty) 'Search Result': remoteAdressTitle,
      if (localAdressTitles.isNotEmpty) 'Recent': localAdressTitles,
    };
  }

  switchTextField() {
    selectedfromTextField = false;
    setBusy(false);
  }

  switchState(String newstate) {
    setBusy(true);
    state = newstate;
    print(state);
    setBusy(false);
  }

  switchRideOptionButtonIndex(int newIndex) {
    setBusy(true);
    vehicleSelectedIndex = newIndex;
    setBusy(false);
  }

  addAdress(String adress) async {
    setBusy(true);
    try {
      adressList.firstWhere((element) => element.adressTitle == adress);
    } catch (e) {
      adressList = await _homeRepository.addAdressLocally(adress: adress);
    }
    setBusy(false);
  }

  getDrivers() async {
    setBusy(true);
    // AdressModel from;
    // try {
    //   from = adressList
    //       .firstWhere((element) => element.adressTitle == fromController.text);
    // } catch (e) {
    //   from = remoteAdressList
    //       .firstWhere((element) => element.adressTitle == fromController.text);
    // }

    drivers = await _homeRepository.getDrivers(
        selectedDateTime, LatLng(from.lat, from.long));
    setBusy(false);
  }

  Future createRide(BuildContext context) async {
    showCupertinoDialog(
        context: context,
        builder: (BuildContext ctx) {
          return CupertinoAlertDialog(
            title: const Text('Please Confirm Information'),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("From: ${from.adressTitle}"),
                UIHelper.verticalSpaceSmall,
                Text("To: ${to.adressTitle}"),
                UIHelper.horizontalSpaceSmall,
                Text("Date: ${dateFormatter()}"),
                UIHelper.horizontalSpaceSmall,
                Text("Driver: ${drivers[selectedDriverIndex].user?.name}"),
                UIHelper.verticalSpaceSmall
              ],
            ),
            actions: [
              // The "Yes" button
              CupertinoDialogAction(
                onPressed: () async {
                  await _homeRepository.createARide(
                      drivers[selectedDriverIndex].user?.email ?? "",
                      selectedDateTime,
                      LatLng(from.lat, from.long),
                      LatLng(to.lat, to.long),
                      distance.toInt() * 3,
                      bill,
                      estimatedFare);
                  Navigator.pop(context);
                  switchState(LabelSelectAdress);
                  toController.text = "";
                  LoginViewModel.showToast("Ride Generated Successfully");
                  setBusy(false);
                },
                child: const Text('Yes'),
                isDefaultAction: true,
                isDestructiveAction: true,
              ),
              // The "No" button
              CupertinoDialogAction(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('No'),
              )
            ],
          );
        });
  }
}

class Debouncer {
  final int milliseconds;
  late VoidCallback action;
  Timer? _timer;

  Debouncer({required this.milliseconds});

  run(VoidCallback action) {
    if (null != _timer) {
      _timer!.cancel();
    }
    _timer = Timer(Duration(milliseconds: milliseconds), action);
  }
}
