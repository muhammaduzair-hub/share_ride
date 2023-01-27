
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../../viewmodels/views/login_viewmodel.dart';
import '../model/user_model.dart';

class AuthApi{

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late var _fireStoreUsers = _firestore.collection("users");

  final _firebaseStorage = FirebaseStorage.instance;

  //signup
  Future<dynamic> signUpWithEmailPassword(String nameController, String emailController,String phoneNoController, String passwordController) async {
    await FirebaseFirestore.instance.collection("users").add({
      "name" : nameController,
      "email" : emailController,
      "phoneNo" : phoneNoController,
      "password" : passwordController,
      "address" : "Address NotFound",
      "type" : "Type NotFound",
      "imgUrl": "",
      "isDriver": false,
      "age":-1,
      "cnic":-1,
      "isVehicalAdded":false,
      "vehicalName":"",
      "vehicalModel":"",
      "vehicalNo":"",
      "vehicalImgUrl":"",
      "timestamp" : new DateTime.now()
    }).then((response) {
      print(response.id);
      LoginViewModel.showToast("Signup Succesfully");
      return response.id;

    }
    ).catchError((error) => print(error),
    );
  }

  //validations for signup
  validateEmail({required String email}) async {
    if(_fireStoreUsers.doc().snapshots().length==0)
      return true;
    else {
      bool _final = true;
      var stream = await _fireStoreUsers
          .where('email', isEqualTo: email)
          .get();
      print(stream.size);
      if (stream.size == 0) {
        _final = true;
      }
      else {
        _final = false;
      }
      return _final;
    }
  }

  validatePhone(String phoneNo) async {
    if(_fireStoreUsers.doc().snapshots().length==0)
      return true;
    else {
      bool _final = true;
      var stream = await _fireStoreUsers
          .where('phoneNo', isEqualTo: phoneNo)
          .get();
      if (stream.size == 0) {
        _final = true;
      }
      else {
        _final = false;
      }
      return _final;
    }
  }

  validateVehicalNo(String vehicalNo) async {
      if(_fireStoreUsers.doc().snapshots().length==0)
        return true;
      else {
        bool _final = true;
        var stream = await _fireStoreUsers
            .where('vehicalNo', isEqualTo: vehicalNo)
            .get();
        if (stream.size == 0) {
          _final = true;
        }
        else {
          _final = false;
        }
        return _final;
      }
    }

  Future getUsersStream() async {
    return await FirebaseFirestore.instance.collection("users").get();
  }

  Future<UserModel> signInWithEmailPassword(String phoneNo, String password) async{
    bool exist = false;
    UserModel user = UserModel(id: '');
    exist=await getUsersStream().
    then((val){
      if(val.docs.length > 0){
        int index=val.docs.length;
        for(var i=0; i<index;i++){
          if(phoneNo == val.docs[i].data()['email']){
            if(password == val.docs[i].data()['password']){
              //Return Bool True(Credentials are Okay) To View class so it can proceed
              user.phoneno = val.docs[i].data()['phoneNo'];
              user.id = val.docs[i].id;
              user.name=val.docs[i].data()['name'];
              user.address = val.docs[i].data()['address'];
              user.email = val.docs[i].data()['email'];
              user.type = val.docs[i].data()['type'];
              user.password = val.docs[i].data()['password'];
              user.imgUrl = val.docs[i].data()['imgUrl'];
              user.isDriver = val.docs[i].data()['isDriver'];
              user.age = val.docs[i].data()['age'];
              user.cnic = val.docs[i].data()['cnic'];
              user.isVehicalAdded = val.docs[i].data()["isVehicalAdded"];
              user.vehicalName = val.docs[i].data()['vehicalName'];
              user.vehicalModel = val.docs[i].data()['vehicalModel'];
              user.vehicalNo = val.docs[i].data()['vehicalNo'];
              user.vehicalImgUrl = val.docs[i].data()['vehicalImgUrl'];
              exist = true;
              LoginViewModel.signedINUser = user;
              break;
            }
            else{
              exist = false;
              break;
            }
          }
        }
        return exist;
      }
      else{
        //No Document Exists
        return false;
      }
    })
        .catchError((error) {return false;});
    return user;
  }

  Future<String> uploadImage(String name, File file) async {
    final ref = _firebaseStorage.ref().child(name);
    UploadTask? upload = ref.putFile(file);
    final snapshot = await upload.whenComplete((){});
     String img = await snapshot.ref.getDownloadURL();
    print("imageUrl : ${img}");
    return img;
  }

  Future userUploadImage(String name, File file)async{

    String img = await uploadImage(name, file);
    print("signin image : ${img}");
    await _firestore.collection("users")
        .doc(LoginViewModel.signedINUser.getId)
        .update({'imgUrl': img}).whenComplete(() => LoginViewModel.signedINUser.imgUrl = img);
    
    print("signin image : ${LoginViewModel.signedINUser.imgUrl}");
  }

  Future updateProfile(String? name, String? mobile, String? password) async{
    if(name!=null){
      _firestore.collection("users")
          .doc(LoginViewModel.signedINUser.getId)
          .update({'name': name});
      LoginViewModel.signedINUser.name = name;
    }
    if(mobile!=null){
      _firestore.collection("users")
          .doc(LoginViewModel.signedINUser.getId)
          .update({'phoneNo': mobile});
      LoginViewModel.signedINUser.phoneno = mobile;
    }
    if(password!=null){
      _firestore.collection("users")
          .doc(LoginViewModel.signedINUser.getId)
          .update({'password': password});

      LoginViewModel.signedINUser.password = password;
    }
    if(name!=null || mobile!=null || password!=null)LoginViewModel.showToast("Successfully Update");
  }

  Future createDriverProfile(int age, int cnic,String address ) async{
    final user = _firestore.collection("users").doc(LoginViewModel.signedINUser.getId);

    await user.update({"age":age}).whenComplete(() => LoginViewModel.signedINUser.age = age);
    await user.update({"cnic":cnic}).whenComplete(() => LoginViewModel.signedINUser.cnic = cnic);
    await user.update({"address":address}).whenComplete(() => LoginViewModel.signedINUser.address = address);
    await user.update({"isDriver":true}).whenComplete(() => LoginViewModel.signedINUser.isDriver = true);

  }

  Future addVehicalImage( String imgName, File imgFile) async{

    final user = await _firestore.collection("users").doc(LoginViewModel.signedINUser.getId);

    final img = await uploadImage(imgName, imgFile);
    await user.update({"vehicalImgUrl": img}).whenComplete(() =>LoginViewModel.signedINUser.vehicalImgUrl =  img);
  }

  Future FutureAddVehical(String vehicalName, String vehicalModel, String vehicalNo) async{
    final user = await _firestore.collection("users").doc(LoginViewModel.signedINUser.getId);

    await user.update({"vehicalName":vehicalName}).whenComplete(() => LoginViewModel.signedINUser.vehicalName = vehicalName);
    await user.update({"vehicalModel":vehicalModel}).whenComplete(() => LoginViewModel.signedINUser.vehicalModel = vehicalModel);
    await user.update({"vehicalNo":vehicalNo}).whenComplete(() => LoginViewModel.signedINUser.vehicalNo = vehicalNo);

    await user.update({"isVehicalAdded": true}).whenComplete(() => LoginViewModel.signedINUser.isVehicalAdded = true);
  }

}