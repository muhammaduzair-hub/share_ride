import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../constants/strings.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import '../base/base_widget.dart';
import '../custom_widget/custom_text_field.dart';
import '../custom_widget/primary_button.dart';
import '../shared/text_styles.dart';
import '../shared/ui_helpers.dart';

class VehicalSetup extends StatelessWidget {
  TextEditingController vehicleName = TextEditingController();
  TextEditingController vehicleModel = TextEditingController();
  TextEditingController vehicleNo = TextEditingController();
  late XFile? file;

  VehicalSetup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<LoginViewModel>(
      onModelReady: (p0) {
        vehicleName.text = LoginViewModel.signedINUser.vehicalName ?? "";
        vehicleModel.text = LoginViewModel.signedINUser.vehicalModel ?? "";
        vehicleNo.text = LoginViewModel.signedINUser.vehicalNo ?? "";
      },
      model: LoginViewModel(authRepository: Provider.of(context)),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("Vehicle setup"),
          ),
          body: ListView(
            padding: UIHelper.pagePaddingSmall,
            children: [
              Center(
                child: model.imageUploading
                    ? CircularProgressIndicator()
                    : Container(
                        height: 100,
                        width: double.infinity,
                        child: FittedBox(
                            child: LoginViewModel
                                        .signedINUser.vehicalImgUrl?.isEmpty ??
                                    true
                                ? Icon(Icons.car_crash_outlined)
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      for (int i = 0;
                                          i <
                                              LoginViewModel.signedINUser
                                                  .vehicalImgUrl!.length;
                                          i++)
                                        Container(
                                          margin: EdgeInsets.only(right: 10),
                                          child: Image.network(
                                            LoginViewModel
                                                .signedINUser.vehicalImgUrl![i],
                                            width: 50,
                                            height: 50,
                                            fit: BoxFit.cover,
                                            errorBuilder: (context, error,
                                                    stackTrace) =>
                                                Icon(Icons.access_time_sharp),
                                          ),
                                        ),
                                      if (LoginViewModel.signedINUser
                                              .vehicalImgUrl!.length <
                                          4)
                                        IconButton(
                                          onPressed: () async {
                                            file = await model.picker.pickImage(
                                                source: ImageSource.gallery);
                                            await model
                                                .uploadVehiclephoto(file);
                                            file = null;
                                          },
                                          icon: Icon(Icons.add),
                                        ),
                                    ],
                                  ))),
              ),
              LoginViewModel.signedINUser.vehicalImgUrl?.isEmpty ?? true
                  ? Center(
                      child: TextButton(
                        child: const Text("Edit"),
                        onPressed: () async {
                          file = await model.picker
                              .pickImage(source: ImageSource.gallery);
                          await model.uploadVehiclephoto(file);
                        },
                      ),
                    )
                  : UIHelper.verticalSpaceSmall,
              // Spacer(),
              Text(LabelName, style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(
                  controller: vehicleName, keyboardType: TextInputType.name),

              UIHelper.verticalSpaceMedium,
              const Text("Model", style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(
                  controller: vehicleModel, keyboardType: TextInputType.name),

              UIHelper.verticalSpaceMedium,
              const Text("Car-no", style: boldHeading3),
              UIHelper.verticalSpaceSmall,
              CustomTextField(
                  controller: vehicleNo, keyboardType: TextInputType.name),

              UIHelper.verticalSpaceMedium,
              Container(
                width: double.infinity,
                height: 50,
                child: model.busy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : PrimaryButton(
                        text: Text(
                          LoginViewModel.signedINUser.isVehicalAdded ?? false
                              ? "Update"
                              : "Save",
                          style: buttonTextStyle,
                        ),
                        ontap: () async {
                          await model.setupVehicle(
                              vehicleName, vehicleModel, vehicleNo);
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}
