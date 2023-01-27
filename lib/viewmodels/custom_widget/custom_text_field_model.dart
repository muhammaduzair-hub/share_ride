

import '../base/base_model.dart';

class CustomTextFieldViewModel extends BaseModel {
  late bool obscureText = true;

  CustomTextFieldViewModel() : super(false);

  switchState(){
    setBusy(true);
    obscureText=!obscureText;
    setBusy(false);
  }


}
