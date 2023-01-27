import 'package:easy_splash_screen/easy_splash_screen.dart';
import 'package:flutter/material.dart';

import 'auth_view.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasySplashScreen(
      logo: Image.asset("asset/images/logo.jpeg"),
      // title: Text("Personal Cab", ),
      backgroundColor: Colors.green,
      loaderColor: Colors.white,
      showLoader: true,
      futureNavigator: Future.value(AuthView()),
      durationInSeconds: 5,
    );
  }
}
