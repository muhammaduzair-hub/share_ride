import 'package:RideShare/ui/view/vehical_setup.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import '../base/base_widget.dart';
import '../custom_widget/custom_text_field.dart';
import '../custom_widget/primary_button.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';

class DriverProfile extends StatelessWidget {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController cnicController = TextEditingController();
   DriverProfile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      onModelReady: (p0) {
        nameController.text = LoginViewModel.signedINUser.name??"";
        emailController.text = LoginViewModel.signedINUser.email??"";
        numberController.text = LoginViewModel.signedINUser.phoneno??"";
        ageController.text = LoginViewModel.signedINUser.age.toString().compareTo("-1")==0?"":LoginViewModel.signedINUser.age.toString();
        cnicController.text = LoginViewModel.signedINUser.cnic.toString().compareTo("-1")==0?"":LoginViewModel.signedINUser.cnic.toString();
        addressController.text = LoginViewModel.signedINUser.address?.compareTo("Address NotFound")==0?"":LoginViewModel.signedINUser.address??"";
      },
      model: LoginViewModel(authRepository: Provider.of(context)),
      builder: (context, model, child) {
        //this is for creation
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Driver Profile"),
            actions: [
              if(LoginViewModel.signedINUser.isDriver!)PopupMenuButton<String>(
                onSelected: (_){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => VehicalSetup(),));
                },
                itemBuilder: (BuildContext context) {
                  String text = LoginViewModel.signedINUser.isVehicalAdded ??false ?"Setup vehicle":"Vehicle detail" ;
                  return {text}.map((String choice) {
                    return PopupMenuItem<String>(
                      value: choice,
                      child: Text(choice),
                    );
                  }).toList();
                },
              ),
            ],
          ),
          body: ListView(
            shrinkWrap: true,
            padding: UIHelper.pagePaddingSmall,
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
              const Text(LabelName,style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(controller: nameController, keyboardType: TextInputType.name,readOnly: true),
              if(model.nameState==false)Text(labelNameError, style: const TextStyle(color: errorMessage),),

              UIHelper.verticalSpaceMedium,
              Text(LabelEmail,style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(controller: emailController, keyboardType: TextInputType.emailAddress,readOnly:  true),
              if(model.duplicateEmail)Text("Email already exists!", style: TextStyle(color: errorMessage),)
              else if(model.emailState==false)Text(labelEmailError, style: TextStyle(color: errorMessage),),

              UIHelper.verticalSpaceMedium,
              Text(LabelMobile,style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(controller: numberController, keyboardType: TextInputType.number, readOnly: true,),
              if(model.duplicatePhone)const Text("Phone Number Already exists!", style: TextStyle(color: errorMessage))
              else if(model.phoneState==false)Text(labelPhoneNoError, style: const TextStyle(color: errorMessage),),

              UIHelper.verticalSpaceMedium,
              Text("CNIC",style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(controller: cnicController,keyboardType: TextInputType.number, readOnly: cnicController.text.isNotEmpty),

              UIHelper.verticalSpaceMedium,
              Text("Age",style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(controller: ageController,keyboardType: TextInputType.phone),

              UIHelper.verticalSpaceMedium,
              Text("Address",style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(controller: addressController,),

              UIHelper.verticalSpaceMedium,
              Container(
                width: double.infinity,
                height: 50,
                child:
                model.busy?
                Center(child: CircularProgressIndicator(),) :
                PrimaryButton(
                  text: const Text("Save",style: buttonTextStyle,),
                  ontap:() async {
                      model.setupDriverProfile(ageController, cnicController, addressController);
                      model.setBusy(false);
                  },
                ),
              ),
            ]
          ),
        );
      },
    );
  }
}
