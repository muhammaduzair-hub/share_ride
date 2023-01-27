import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../viewmodels/views/home_view_model.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import '../base/base_widget.dart';
import '../custom_widget/custom_text_field.dart';
import '../custom_widget/primary_button.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';
import 'driver_profile.dart';

class ProfileSettingView extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController numberController = TextEditingController();

  ProfileSettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return BaseWidget<LoginViewModel>(
      onModelReady: (p0) {
        nameController.text = LoginViewModel.signedINUser.name??"";
        emailController.text = LoginViewModel.signedINUser.email??"";
        passwordController.text = LoginViewModel.signedINUser.password??"";
        numberController.text = LoginViewModel.signedINUser.phoneno??"";
      },
        model: LoginViewModel(authRepository: Provider.of(context)),
      builder: (context, model, child) {
          return Scaffold(
            appBar: AppBar(
              title: Text("Profile Setting"),
            ),
            body: Form(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                  child: SizedBox(
                    height: size.height,
                    width: double.infinity,
                    child: Padding(
                      padding: UIHelper.pagePaddingSmall.copyWith(bottom: 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: model.imageUploading?
                              CircularProgressIndicator()
                                :Container(
                              height: 100,
                              width: double.infinity,
                              child:
                                FittedBox(
                                  child:LoginViewModel.signedINUser.imgUrl == ""
                                      ? Icon(Icons.person)
                                      : Image.network(LoginViewModel.signedINUser.imgUrl!,
                                        fit: BoxFit.fill,
                                  ),
                                )
                            ),
                          ),
                          Center(
                            child: TextButton(
                              child: Text("Edit"),
                              onPressed: ()async{
                                final XFile? image = await model.picker.pickImage(source: ImageSource.gallery);
                                await model.uploadphoto(image);
                              },
                            ),
                          ),
                          // Spacer(),
                          Text(LabelName,style: boldHeading3),
                          UIHelper.verticalSpaceSmall,
                          CustomTextField(controller: nameController, keyboardType: TextInputType.name),
                          if(model.nameState==false)Text(labelNameError, style: TextStyle(color: errorMessage),),

                          UIHelper.verticalSpaceMedium,
                          Text(LabelEmail,style: boldHeading3),
                          UIHelper.verticalSpaceSmall,
                          CustomTextField(controller: emailController, keyboardType: TextInputType.emailAddress,readOnly:  true),
                          if(model.duplicateEmail)Text("Email already exists!", style: TextStyle(color: errorMessage),)
                          else if(model.emailState==false)Text(labelEmailError, style: TextStyle(color: errorMessage),),

                          UIHelper.verticalSpaceMedium,
                          Text(LabelMobile,style: boldHeading3),
                          UIHelper.verticalSpaceSmall,
                          CustomTextField(controller: numberController, keyboardType: TextInputType.number,),
                          if(model.duplicatePhone)Text("Phone Number Already exists!", style: TextStyle(color: errorMessage))
                          else if(model.phoneState==false)Text(labelPhoneNoError, style: TextStyle(color: errorMessage),),

                          UIHelper.verticalSpaceMedium,
                          Text(LabelPassword,style: boldHeading3),
                          UIHelper.verticalSpaceSmall,
                          CustomTextField(controller: passwordController, showPassword: true,),
                          if(model.passState==false)Text(labelPasswordError, style: TextStyle(color: errorMessage),),

                          UIHelper.verticalSpaceMedium,
                          Container(
                            width: double.infinity,
                            height: 50,
                            child:
                            model.busy?
                            Center(child: CircularProgressIndicator(),) :
                            PrimaryButton(
                              text: const Text("Update",style: buttonTextStyle,),
                              ontap:() async {
                                model.duplicateEmail = false;
                                model.duplicatePhone = false;
                                if(model.validateName(nameController.text)
                                    && await model.validateMobileForUpdate(numberController.text)
                                    && model.validatePassword(passwordController.text)){

                                  //Send Data to a method inside Model Class to access Database
                                  await model.updateProfile(nameController, numberController, passwordController);
                                  model.setBusy(false);
                                  //_pageController.previousPage(duration: Duration(milliseconds: 500), curve: Curves.ease);
                                }
                              },
                            ),
                          ),
                          UIHelper.verticalSpaceMedium,
                          if(HomeViewModel.driverMode)Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: LoginViewModel.signedINUser.isDriver??false?
                                [
                                  Text("Want to go to drive profile?"),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (context) => DriverProfile(),));
                                    },
                                    child: Text("Click", style: TextStyle(color: Colors.green),),
                                  )
                                ]
                                :[
                              const Text("Don't have an driver account?"),
                              InkWell(
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => DriverProfile(),));
                                },
                                child: const Text("Signup", style: TextStyle(color: Colors.green),),
                              )
                            ]
                          )
                        ],
                      ),
                    ),
                  )
              ),
            ),
          );
      },
    );
  }
}
