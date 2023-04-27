import 'package:RideShare/viewmodels/views/home_view_model.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import '../base/base_widget.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';
import 'home_view.dart';

class VerifyCodeView extends StatelessWidget {
  TextEditingController textEditingController = TextEditingController();
  VerifyCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      model: Provider.of<LoginViewModel>(context, listen: false),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: onSecondaryColor,
            elevation: 0.0,
            centerTitle: true,
            title: Text(
              VerifyCode,
              style: boldHeading1.copyWith(color: onPrimaryColor),
            ),
            leading: CircleAvatar(
              radius: 20.0,
              backgroundColor: Colors.transparent,
              child: RawMaterialButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                elevation: 4.0,
                fillColor: Colors.white,
                child: Icon(
                  Icons.arrow_back_ios_outlined,
                  color: onPrimaryColor,
                  size: 17.0,
                ),
                padding: EdgeInsets.all(15.0),
                shape: CircleBorder(),
              ),
            ),
          ),
          backgroundColor: onSecondaryColor,
          body: Column(children: <Widget>[
            UIHelper.verticalSpaceLarge,
            Text(
              verifycodeString1,
              style: heading2.copyWith(
                  fontWeight: FontWeight.w400, color: onPrimaryColor2),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "+92300-1234567",
                  style: heading2.copyWith(
                      fontWeight: FontWeight.w400, color: onPrimaryColor2),
                ),
                Text(
                  verifycodeString2,
                  style: heading2.copyWith(
                      fontWeight: FontWeight.w400, color: onPrimaryColor2),
                ),
              ],
            ),
            UIHelper.verticalSpaceMedium,
            Form(
              key: model.formKey,
              child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 50),
                  child: PinCodeTextField(
                    autoFocus: true,
                    appContext: context,
                    pastedTextStyle: TextStyle(
                      color: Colors.green.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                    length: 4,
                    animationType: AnimationType.fade,
                    pinTheme: PinTheme(
                      shape: PinCodeFieldShape.underline,
                    ),
                    cursorColor: Colors.black,
                    animationDuration: Duration(milliseconds: 300),
                    errorAnimationController: model.errorController,
                    controller: textEditingController,
                    keyboardType: TextInputType.number,
                    onCompleted: (v) {
                      if (textEditingController.text == "9999") {
                        model.hasError = false;
                        HomeViewModel.driverMode = false;

                        model.setBusy(false);
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeView(),
                            ),
                            (route) => false);
                        // Navigator.pop(context);
                        // Navigator.pop(context);
                        // Navigator.push(context, MaterialPageRoute(builder: (context) => BookingView(),));
                      } else {
                        model.errorController?.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        model.hasError = true;
                        textEditingController.text = "";
                        model.setBusy(false);
                      }
                    },
                    onChanged: (value) {
                      print(value);
                      // model.currentText = value;
                      model.setBusy(false);
                    },
                    beforeTextPaste: (text) {
                      print("Allowing to paste $text");
                      //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                      //but you can show anything you want here, like your pop up saying wrong paste format or etc
                      return true;
                    },
                  )),
            ),
            Spacer(),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20.0),
              width: double.infinity,
              color: secondaryColor,
              child: Text(
                verify_press_call,
                textAlign: TextAlign.center,
                style: buttonTextStyle.copyWith(
                    fontWeight: FontWeight.w800, color: onSecondaryColor),
              ),
            )
          ]),
        );
      },
    );
  }
}
