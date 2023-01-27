import 'package:flutter/material.dart';

class BaseModel extends ChangeNotifier {
  bool _busy = false;
  bool get busy => _busy;


  BaseModel(this._busy);
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void setBusy(bool value) {
    _busy = value;
    notifyListeners();
  }
}
