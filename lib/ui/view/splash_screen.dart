import 'dart:async';
import 'dart:convert';

import 'package:RideShare/ui/view/home_view.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../data/model/user_model.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import 'auth_view.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  bool isLogin = false;
  var myFuture;

  @override
  void initState() {
    // TODO: implement initState
    checkLogin();
  }

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset("asset/images/logo.jpeg"),
      // title: Text("Personal Cab", ),
      backgroundColor: Colors.green,
      loaderColor: Colors.white,
      showLoader: true,

    );
  }

  void checkLogin() async{
    final prefs = await SharedPreferences.getInstance();
    final user = await prefs.getString("user")??"";
    if(user.isNotEmpty){
      LoginViewModel.signedINUser = await UserModel.fromJson(json.decode(user));
      if(LoginViewModel.signedINUser.getId.isNotEmpty) isLogin = true;
    }
    else isLogin = false;
    await Timer.periodic(Duration(seconds: 10), (timer) { });
    isLogin?
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => HomeView(),), (route) => false)
    :
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => AuthView(),), (route) => false);

    // myFuture =isLogin? Future.value(HomeView()): Future.value(AuthView());
  }
}
