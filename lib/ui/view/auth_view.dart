import 'dart:convert';

import 'package:RideShare/data/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/strings.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import '../base/base_widget.dart';
import '../custom_widget/custom_text_field.dart';
import '../custom_widget/primary_button.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';
import 'Verify_code_view.dart';

class AuthView extends StatelessWidget {
  AuthView({Key? key}) : super(key: key);

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController snumberController = TextEditingController();
  TextEditingController spasswordController = TextEditingController();

  final PageController _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return PageView(
      controller: _pageController,
      children: [
        signIn(context, size),
        signUp(context, size),
      ],
    );
  }

  Widget signUp(BuildContext context, Size size) {
    return BaseWidget<LoginViewModel>(
      model: LoginViewModel(authRepository: Provider.of(context)),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(LabelSignup,
                style: boldHeading1.copyWith(color: onPrimaryColor)),
            centerTitle: true,
          ),
          body: Form(
            child: SingleChildScrollView(
                child: SizedBox(
              height: size.height - 120,
              width: double.infinity,
              child: Padding(
                padding: UIHelper.pagePaddingSmall.copyWith(bottom: 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Spacer(),

                    Center(
                        child: Image(
                      image: AssetImage("asset/images/logo.jpeg"),
                      width: double.infinity,
                      height: 100,
                    )),
                    UIHelper.verticalSpaceMedium,

                    Text(LabelName, style: boldHeading3),
                    UIHelper.verticalSpaceSmall,
                    CustomTextField(
                        controller: nameController,
                        keyboardType: TextInputType.name),
                    if (model.nameState == false)
                      Text(
                        labelNameError,
                        style: TextStyle(color: errorMessage),
                      ),

                    UIHelper.verticalSpaceMedium,
                    Text(LabelEmail, style: boldHeading3),
                    UIHelper.verticalSpaceSmall,
                    CustomTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    if (model.duplicateEmail)
                      Text(
                        "Email already exists!",
                        style: TextStyle(color: errorMessage),
                      )
                    else if (model.emailState == false)
                      Text(
                        labelEmailError,
                        style: TextStyle(color: errorMessage),
                      ),

                    UIHelper.verticalSpaceMedium,
                    Text(LabelMobile, style: boldHeading3),
                    UIHelper.verticalSpaceSmall,
                    CustomTextField(
                      controller: numberController,
                      keyboardType: TextInputType.number,
                    ),
                    if (model.duplicatePhone)
                      Text("Phone Number Already exists!",
                          style: TextStyle(color: errorMessage))
                    else if (model.phoneState == false)
                      Text(
                        labelPhoneNoError,
                        style: TextStyle(color: errorMessage),
                      ),

                    UIHelper.verticalSpaceMedium,
                    Text(LabelPassword, style: boldHeading3),
                    UIHelper.verticalSpaceSmall,
                    CustomTextField(
                      controller: passwordController,
                      showPassword: true,
                    ),
                    if (model.passState == false)
                      Text(
                        labelPasswordError,
                        style: TextStyle(color: errorMessage),
                      ),

                    UIHelper.verticalSpaceMedium,
                    Container(
                      width: double.infinity,
                      height: 50,
                      child: model.busy
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : PrimaryButton(
                              text: const Text(
                                LabelSignup,
                                style: buttonTextStyle,
                              ),
                              ontap: () async {
                                if (!model.signupTap) {
                                  model.setBusy(true);
                                  model.signupTap = true;
                                  model.duplicateEmail = false;
                                  model.duplicatePhone = false;
                                  // model.validateName(nameController.text);
                                  // await model.validateEmail(emailController.text,numberController.text);
                                  // model.validateMobileNumber(numberController.text);
                                  // model.validatePassword(passwordController.text);

                                  if (model.validateName(nameController.text) &&
                                      await model.validateEmail(
                                          emailController.text,
                                          numberController.text) &&
                                      model.validateMobileNumber(
                                          numberController.text) &&
                                      model.validatePassword(
                                          passwordController.text)) {
                                    //Send Data to a method inside Model Class to access Database
                                    await model.signUp(
                                        nameController,
                                        emailController,
                                        numberController,
                                        passwordController);

                                    //Route to VerifyCode View

                                    // await model.signin( numberController, passwordController);
                                    // if(LoginViewModel.signedINUser.id==''){
                                    //   model.error=true;
                                    //   print("cannot Signin with those credentials");
                                    // }
                                    // else {
                                    //   Navigator.push(context, new MaterialPageRoute(
                                    //       builder: (context) => new VerifyCodeView())
                                    //   );
                                    // }

                                    nameController.text = "";
                                    emailController.text = "";
                                    numberController.text = "";
                                    passwordController.text = "";
                                    _pageController.previousPage(
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.ease);
                                  }

                                  model.signupTap = false;
                                  model.setBusy(false);
                                }
                              },
                            ),
                    ),

                    //SizedBox(height: 200,),
                    Spacer(
                      flex: 2,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(LabelAlreadyHaveAccount,
                            style: heading3.copyWith(color: onPrimaryColor2)),
                        InkWell(
                          onTap: () {
                            nameController.text = "";
                            emailController.text = "";
                            numberController.text = "";
                            passwordController.text = "";
                            model.setBusy(false);
                            _pageController.previousPage(
                                duration: Duration(milliseconds: 700),
                                curve: Curves.ease);
                          },
                          child: Text(
                            LabelSignIn,
                            style: heading2.copyWith(color: secondaryColor),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
          ),
        ),
      ),
    );
  }

  Widget signIn(BuildContext context, Size size) {
    List<UserModel> users = [];
    final GlobalKey _textFieldKey = GlobalKey();

    return BaseWidget<LoginViewModel>(
      onModelReady: (_) async {
        final prefs = await SharedPreferences.getInstance();
        final user = await prefs.getStringList("allUsers") ?? [];
        if (user.isNotEmpty) {
          users = user
              .map((userJson) => UserModel.fromJson(jsonDecode(userJson)))
              .toList();
        }
      },
      //we use signup model for both
      model:
          LoginViewModel(authRepository: Provider.of(context, listen: false)),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            title: Text(LabelSignIn,
                style: boldHeading1.copyWith(color: onPrimaryColor)),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
              child: SizedBox(
            height: size.height - 120,
            width: double.infinity,
            child: Padding(
              padding: UIHelper.pagePaddingSmall.copyWith(bottom: 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Spacer(
                    flex: 1,
                  ),
                  const Center(
                      child: Image(
                    image: AssetImage("asset/images/logo.jpeg"),
                    width: double.infinity,
                    height: 100,
                  )),
                  UIHelper.verticalSpaceMedium,
                  const Text(LabelEmail, style: boldHeading3),
                  UIHelper.verticalSpaceSmall,
                  TextField(
                    // key: _textFieldKey,
                    onTap: () {
                      if (users.isNotEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                  content: ListView.separated(
                                shrinkWrap: true,
                                itemCount: users.length,
                                itemBuilder: (context, index) => ListTile(
                                  title: Text(users[index].email ?? ""),
                                  subtitle: Text(users[index]
                                          .password
                                          ?.replaceAll(RegExp(r"."), "*") ??
                                      ""),
                                  onTap: () {
                                    snumberController.text =
                                        users[index].email!;
                                    spasswordController.text =
                                        users[index].password!;
                                    model.setBusy(false);
                                    Navigator.pop(context);
                                  },
                                ),
                                separatorBuilder: (context, index) => Divider(
                                  height: 2,
                                ),
                              ));
                            });
                      }
                      // showMenu(
                      //   context: context,
                      //   position: RelativeRect.fromLTRB(0, 0, 0, 0),
                      //   items: users.map((UserModel item) {
                      //     return PopupMenuItem<UserModel>(
                      //       value: item,
                      //       child:
                      //     );
                      //   }).toList(),
                      // );
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(
                        left: 10,
                        bottom: 0.5,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffD5DDE0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: Color(0xffD5DDE0)),
                      ),
                      fillColor: Colors.grey
                          .shade100, //Color(0xffF7F8F9),//Colors.grey.shade200,
                      filled: true,
                    ),
                    controller: snumberController,
                  ),
                  if (model.phoneState == false)
                    Text(
                      labelPhoneE,
                      style: TextStyle(color: errorMessage),
                    ),
                  UIHelper.verticalSpaceMedium,
                  Text(LabelPassword, style: boldHeading3),
                  UIHelper.verticalSpaceSmall,
                  CustomTextField(
                    controller: spasswordController,
                    showPassword: true,
                  ),
                  if (model.passState == false)
                    Text(
                      labelPasswordE,
                      style: TextStyle(color: errorMessage),
                    ),
                  UIHelper.verticalSpaceLarge,
                  Container(
                    width: double.infinity,
                    height: 50,
                    child: model.busy
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : PrimaryButton(
                            text: Text(
                              LabelSignIn,
                              style: buttonTextStyle,
                            ),
                            ontap: () async {
                              bool passAns = model
                                  .validatePassword(spasswordController.text);
                              bool emailAns = model
                                  .onlyValidateEmail(snumberController.text);
                              if (passAns && emailAns) {
                                //Send Data to a method inside Model Class to access Database
                                await model.signin(
                                    snumberController, spasswordController);
                                if (model.signedIdnUser.id == '') {
                                  LoginViewModel.showToast(
                                      "Invalid Username or Password");
                                } else {
                                  Navigator.push(
                                      context,
                                      new MaterialPageRoute(
                                          builder: (context) =>
                                              new VerifyCodeView()));
                                }
                              }
                            },
                          ),
                  ),
                  UIHelper.verticalSpaceMedium,
                  Spacer(
                    flex: 2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(LabelDontHaveAccount,
                          style: heading2.copyWith(color: onPrimaryColor2)),
                      InkWell(
                        onTap: () {
                          _pageController.nextPage(
                              duration: Duration(milliseconds: 700),
                              curve: Curves.ease);
                        },
                        child: Text(
                          LabelSignup,
                          style: heading2.copyWith(color: secondaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
        ),
      ),
    );
  }
}
