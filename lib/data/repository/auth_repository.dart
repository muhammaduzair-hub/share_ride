import 'dart:convert';
import 'dart:io';

import 'package:RideShare/viewmodels/views/login_viewmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_model.dart';
import '../remote/auth_api.dart';

class AuthRepository {
  final AuthApi _api;

  AuthRepository({required AuthApi api}) : _api = api;

  // Signup Without Firebase Auth
  Future signUpWithEmailAndPassword(
      String name, String email, String phoneNo, password) async {
    dynamic result =
        await _api.signUpWithEmailPassword(name, email, phoneNo, password);
    if (result == null) {}
    return result;
  }

  //validation for signup

  validateEmail(
    String value,
  ) async {
    dynamic result = await _api.validateEmail(email: value);
    return result;
  }

  validatePhone(String phoneNo) async {
    dynamic result = await _api.validatePhone(phoneNo);
    return result;
  }

  Future signInWithEmailAndPassword(String phoneNo, String password) async {
    UserModel result = await _api.signInWithEmailPassword(phoneNo, password);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
        "user", jsonEncode(LoginViewModel.signedINUser.toJson()));
    print("user : ${await prefs.getString("user")}");

    List<UserModel> users = [];
    final user = await prefs.getStringList("allUsers") ?? [];
    if (user.isNotEmpty) {
      users = user
          .map((userJson) => UserModel.fromJson(jsonDecode(userJson)))
          .toList();
    }
    try {
      UserModel alreadyExist = users.firstWhere(
          (element) => element.email == LoginViewModel.signedINUser.email);
    } catch (e) {
      users.add(LoginViewModel.signedINUser);
    }

    List<String> updatedUsers = [];
    users.forEach((element) {
      updatedUsers.add(jsonEncode(element.toJson()));
    });
    await prefs.setStringList("allUsers", updatedUsers);
    return result;
  }

  Future uploadImage(String name, File file) async {
    await _api.userUploadImage(name, file);
  }

  Future addVehicalImage(String imgName, File imgFile) async {
    await _api.addVehicalImage(imgName, imgFile);
  }

  Future FutureAddVehical(
      String vehicalName, String vehicalModel, String vehicalNo) async {
    await _api.FutureAddVehical(vehicalName, vehicalModel, vehicalNo);
  }

  Future updateProfile(String? name, String? mobile, String? password) async {
    await _api.updateProfile(name, mobile, password);
  }

  Future driverSetup(String age, String cnic, String address) async {
    await _api.createDriverProfile(int.parse(age), cnic, address);
  }
}
