import 'dart:async';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../data/model/user_model.dart';
import '../../data/repository/auth_repository.dart';
import '../base/base_model.dart';

class LoginViewModel extends BaseModel {
  final AuthRepository _authRepository;
  late UserModel signedIdnUser;
  static late UserModel signedINUser;

  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;

  bool nameState = true;
  bool passState = true;
  bool emailState = true;
  bool phoneState = true;
  bool addressState = true;
  bool ageState = true;
  bool cnicState = true;
  bool error = false;
  bool duplicateEmail = false;
  bool duplicatePhone = false;
  bool duplicateVehicalNumber = false;

  //handle button taps
  bool signupTap = false;

  //upload picture
  final ImagePicker picker = ImagePicker();
  bool imageUploading = false;

  final formKey = GlobalKey<FormState>();

  LoginViewModel({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(false);

  @override
  void dispose() {}

  //validations for signup
  Future<bool> validateMobileForUpdate(String value) async {
    bool ans;
    if (value == LoginViewModel.signedINUser.phoneno)
      return true;
    else
      return await validateMobileNumber(value);
  }

  bool validateMobileNumber(String value) {
    bool ans;
    String pattern = r"^(?:(\+92\d{10})|(\d{11}))$";
    RegExp regExp = RegExp(pattern);
    if (value.length == 0) {
      ans = false;
      phoneState = false;
    } else if (!regExp.hasMatch(value)) {
      ans = false;
      phoneState = false;
    } else {
      ans = true;
      phoneState = true;
    }
    setBusy(false);
    return ans;
  }

  bool onlyValidateEmail(String value) {
    return EmailValidator.validate(value);
  }

  validateEmail(String value, String phoneNo) async {
    //method to check if this email is already existing
    bool ans = EmailValidator.validate(value);
    emailState = ans;
    if (ans) {
      var anss = await _authRepository.validateEmail(value);
      if (anss == false) {
        {
          ans = anss;
          duplicateEmail = true;
        }
      } else {
        ans = anss;
        emailState = ans;
        if (ans && phoneState) {
          var ano = await _authRepository.validatePhone(phoneNo);
          if (ano) {
            ans = ano;
            phoneState = ano;
            duplicatePhone = false;
          } else {
            ans = ano; //ano is false
            phoneState = ano;
            duplicatePhone = true;
          }
        }
      }
    }
    setBusy(false);
    return ans;
  }

  bool validateName(String value) {
    bool ans;
    String pattern = r'^[a-zA-Z][a-zA-Z\s]+[a-zA-Z]$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      ans = false;
      nameState = false;
    } else if (!regExp.hasMatch(value)) {
      nameState = false;
      ans = false;
    } else {
      nameState = true;
      ans = true;
    }

    setBusy(false);
    return ans;
  }

  bool validatePassword(String value) {
    bool ans;
    String pattern = r'^(?=.*[A-Za-z])(?=.*\d)\S{8,}$';
    RegExp regExp = new RegExp(pattern);
    if (value.length == 0) {
      passState = false;
      ans = false;
    } else if (!regExp.hasMatch(value)) {
      ans = false;
      passState = false;
    } else {
      ans = true;
      passState = true;
    }
    setBusy(false);
    return ans;
  }

  Future<dynamic> signUp(
      TextEditingController nameController,
      TextEditingController emailController,
      TextEditingController phoneNoController,
      TextEditingController passwordController) async {
    setBusy(true);
    dynamic result = await _authRepository.signUpWithEmailAndPassword(
        nameController.text,
        emailController.text,
        phoneNoController.text,
        passwordController.text);
    if (result == null) {
      setBusy(false);
      print("Not SignedUp");
    }
    return result;
  }

  Future signin(TextEditingController phoneNoController,
      TextEditingController passwordController) async {
    setBusy(true);
    signedIdnUser = await _authRepository.signInWithEmailAndPassword(
        phoneNoController.text, passwordController.text);
    signedINUser = signedIdnUser; //this is static variable
    print(signedIdnUser.id);
    setBusy(false);
  } //End Signin Function

  Future uploadphoto(XFile? image) async {
    if (image != null) {
      imageUploading = true;
      setBusy(false);

      final path = 'images/${image.name}';
      final file = File(image.path);
      await _authRepository.uploadImage(path, file);

      imageUploading = false;
      setBusy(false);
    }
  }

  Future uploadVehiclephoto(XFile? image) async {
    if (image != null) {
      imageUploading = true;
      setBusy(false);

      final path = 'images/${image.name}';
      final file = File(image.path);
      await _authRepository.addVehicalImage(path, file);

      imageUploading = false;

      setBusy(false);
    }
  }

  Future updateProfile(TextEditingController name, TextEditingController phone,
      TextEditingController password) async {
    await _authRepository.updateProfile(
        name.text != LoginViewModel.signedINUser.name ? name.text : null,
        phone.text != LoginViewModel.signedINUser.phoneno ? phone.text : null,
        password.text != LoginViewModel.signedINUser.password
            ? password.text
            : null);
  }

  Future setupDriverProfile(TextEditingController age,
      TextEditingController cnic, TextEditingController address) async {
    setBusy(true);
    String pattern = r'^\d{5}-\d{7}-\d{1}$';
    if (cnic.text.isEmpty)
      LoginViewModel.showToast("CNIC must not empty");
    else if (!RegExp(pattern).hasMatch(cnic.text))
      LoginViewModel.showToast("CNIC must have 1 numeric characters");
    else if (age.text.isEmpty)
      LoginViewModel.showToast("Age must not empty");
    else if (int.parse(age.text) > 100)
      LoginViewModel.showToast("Age must not be greater than 100");
    else if (address.text.isEmpty)
      LoginViewModel.showToast("Address must not empty");
    else if (age.text == LoginViewModel.signedINUser.age.toString() &&
        cnic.text == LoginViewModel.signedINUser.cnic.toString() &&
        address.text == LoginViewModel.signedINUser.address) {
      LoginViewModel.showToast("Everything is up to date");
    } else {
      await _authRepository.driverSetup(age.text, cnic.text, address.text);
      LoginViewModel.showToast("Driver setup successfully");
    }
  }

  Future setupVehicle(TextEditingController name, TextEditingController model,
      TextEditingController carno) async {
    setBusy(true);

    if (name.text == "")
      LoginViewModel.showToast("Name must not empty");
    else if (model.text == "")
      LoginViewModel.showToast("Vehicle model must not empty");
    else if (carno.text == "")
      LoginViewModel.showToast("Vehical number must not be empty");
    else if (carno.text == LoginViewModel.signedINUser.vehicalNo &&
        model.text == LoginViewModel.signedINUser.vehicalModel &&
        carno.text == LoginViewModel.signedINUser.vehicalNo) {
      LoginViewModel.showToast("Everything is up to date");
    } else {
      await _authRepository.FutureAddVehical(name.text, model.text, carno.text);
      LoginViewModel.showToast("Completed Successfully");
    }

    setBusy(false);
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0);
  }
}
