
import 'package:RideShare/ui/view/auth_view.dart';
import 'package:flutter/material.dart';

import '../../viewmodels/views/home_view_model.dart';
import '../../viewmodels/views/login_viewmodel.dart';
import '../shared/text_styles.dart';
import '../view/driver_home.dart';
import '../view/profile_setting.dart';

Widget HomeDrawer(HomeViewModel model, BuildContext context){
  return  Drawer(
    child: Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 150,
                color: Colors.lightGreenAccent,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: EdgeInsets.only(top: 20, left: 20),
                        child: CircleAvatar(
                          radius: 40,
                          foregroundImage: LoginViewModel.signedINUser.imgUrl!=""?NetworkImage(LoginViewModel.signedINUser.imgUrl!):null,
                          backgroundColor: Colors.black54,
                          child: LoginViewModel.signedINUser.imgUrl ==""? Icon(Icons.person, size: 50):null
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomLeft,
                      child: Padding(
                        padding:  EdgeInsets.only(bottom: 25, left: 20),
                        child: Text(LoginViewModel.signedINUser.name??""),
                      ),
                    )
                  ],
                ),
              ),
              ListView(
                shrinkWrap: true,
                children: [
                  ListTile(
                    title: Text("Profile", style: heading3),
                    leading: Icon(Icons.person, color: Colors.green,),
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileSettingView(),));
                    },
                  ),
                  Divider(height: 2,),
                  ListTile(
                    title: Text("History", style: heading3),
                    leading: Icon(Icons.history, color: Colors.green),
                    onTap: (){},
                  ),
                  Divider(height: 2,),
                  ListTile(
                    title: Text("Help desk", style: heading3),
                    leading: Icon(Icons.help, color: Colors.green),
                    onTap: (){},
                  ),
                  Divider(height: 2,),
                  ListTile(
                    title: Text("Logout", style: heading3),
                    leading: Icon(Icons.logout, color: Colors.green),
                    onTap: (){
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) =>  AuthView(),), (route) => false);
                    },
                  ),
                  Divider(height: 2,),
                ],
              )
            ],
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text("Driver Mode"),
                Switch(
                  onChanged: (v){
                    model.switchDriverMode(v);
                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => DriverHomeView(),), (route) => false);
                  },
                  value: HomeViewModel.driverMode
                ),
              ],
            ),
          )
        )
      ],
    ),
  );
}