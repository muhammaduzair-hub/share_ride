import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/views/home_view_model.dart';
import '../base/base_widget.dart';
import '../custom_widget/custom_text_field.dart';
import '../custom_widget/driver_drawer.dart';
import '../custom_widget/primary_button.dart';
import '../shared/ui_helpers.dart';


class DriverHomeView extends StatelessWidget {
  const DriverHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      model: HomeViewModel(repo: Provider.of(context)),//Provider.of<HomeViewModel>(context, listen: false),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Driver Home"),
            actions: [
              IconButton(onPressed: (){}, icon: Icon(Icons.search))
            ],
          ),
          drawer: DriverDrawer(model, context),
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: model.onMapCreated,
                markers: Set.of(model.markers),
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(target: LatLng(	33.738045,73.084488,),zoom: 15),
                mapType: MapType.terrain,
                onTap: (latlng){
                  print("${latlng.latitude}     ${latlng.longitude}");
                },
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: UIHelper.pagePaddingSmall,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: ()async=>await model.getCurrentLocation(),
                              child: Image.asset("asset/images/btn_loc.png")
                          ),
                        ],
                      ),
                      Text("New ride"),
                      CustomTextField(controller: TextEditingController(text: "BaniGala"), readOnly: true),
                      Row(
                        children: [
                          Spacer(flex: 3,),
                          PrimaryButton(text: Text("Accept"), ontap: (){}),
                          Spacer(),
                          PrimaryButton(text: Text("Reject"), ontap: (){})
                        ],
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
