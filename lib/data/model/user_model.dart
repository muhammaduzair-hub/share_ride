import 'package:google_maps_flutter/google_maps_flutter.dart';

class DriverModel {
  late String id;
  late LatLng startPoint;
  late int rating;
  late DateTime startTime;
  late UserModel? user;

  DriverModel(
      {required this.id,
      required this.rating,
      required this.startPoint,
      required this.startTime,
      this.user});

  DriverModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startTime = json['startTime'].toDate();
    rating = json["rating"];
    startPoint = LatLng(json["latitude"], json["longitude"]);
    user = UserModel.initial();
  }
}

class UserModel {
  late String id;
  String? name;
  String? email;
  String? phoneno;
  String? address;
  String? type;
  String? password;
  String? imgUrl;
  bool? isDriver;
  int? age;
  String? cnic;
  bool? isVehicalAdded;
  String? vehicalName;
  String? vehicalModel;
  String? vehicalNo;
  List<String>? vehicalImgUrl;
  bool? isDriverVerify;

  UserModel(
      {required this.id,
      this.name,
      this.email,
      this.phoneno,
      this.address,
      this.type,
      this.password,
      this.imgUrl,
      this.isDriver,
      this.age,
      this.cnic,
      this.isVehicalAdded,
      this.vehicalModel,
      this.vehicalName,
      this.vehicalNo,
      this.isDriverVerify = false,
      this.vehicalImgUrl});

  UserModel.initial()
      : id = '0',
        name = '',
        email = '',
        phoneno = '123456',
        address = '',
        type = '',
        password = '',
        imgUrl = '',
        isVehicalAdded = false,
        vehicalName = '',
        vehicalModel = '',
        vehicalNo = '',
        isDriver = false,
        vehicalImgUrl = [],
        isDriverVerify = false;

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'] ?? "";
    name = json['name'];
    email = json['email'];
    phoneno = json['phoneno'];
    address = json['address'];
    type = json['type'];
    password = json['password'];
    imgUrl = json['imgUrl'];
    isDriver = json["isDriver"];
    cnic = json["cnic"];
    age = json["age"];
    isVehicalAdded = json['isVehicalAdded'];
    vehicalNo = json["vehicalNo"];
    vehicalName = json["vehicalName"];
    vehicalModel = json["vehicalModel"];
    isDriverVerify = json["isDriverVerify"];
    try {
      vehicalImgUrl = List<String>.from(json["vehicalImgUrl"]);
    } on Exception {
      vehicalImgUrl = [json["vehicalImgUrl"]];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phoneno'] = this.phoneno;
    data['address'] = this.address;
    data['type'] = this.type;
    data['password'] = this.password;
    data['imgUrl'] = imgUrl;
    data["isDriver"] = isDriver;
    data["cnic"] = cnic;
    data["age"] = age;
    data['isVehicalAdded'] = isVehicalAdded;
    data["vehicalNo"] = vehicalNo;
    data["vehicalName"] = vehicalName;
    data["vehicalModel"] = vehicalModel;
    data["vehicalImgUrl"] = vehicalImgUrl;
    data["isDriverVerify"] = isDriverVerify;
    return data;
  }

  String get getId => id.toString();
}
