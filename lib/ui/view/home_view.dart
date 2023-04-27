import 'package:RideShare/ui/view/find_driver.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../../viewmodels/views/home_view_model.dart';
import '../base/base_widget.dart';
import '../custom_widget/home_drawer.dart';
import '../shared/app_colors.dart';
import '../shared/ui_helpers.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<HomeViewModel>(
      model: HomeViewModel(
          repo: Provider.of(
              context)), //Provider.of<HomeViewModel>(context, listen: false),
      builder: (context, model, child) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text("Booking"),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          ),
          drawer: HomeDrawer(model, context),
          body: Stack(
            children: [
              GoogleMap(
                onMapCreated: model.onMapCreated,
                markers: Set.of(model.markers),
                zoomControlsEnabled: false,
                initialCameraPosition: CameraPosition(
                    target: LatLng(
                      33.738045,
                      73.084488,
                    ),
                    zoom: 15),
                mapType: MapType.terrain,
                onTap: (latlng) {
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
                      Spacer(
                        flex: 3,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                              onTap: () async =>
                                  await model.getCurrentLocation(),
                              child: Image.asset("asset/images/btn_loc.png")),
                        ],
                      ),
                      Spacer(
                        flex: 1,
                      )
                    ],
                  ),
                ),
              ),
              DraggableScrollableSheet(
                key: Key("Sheet"),
                initialChildSize:
                    0.25, //model.localAdressTitles.length!=0?0.4:0.2,
                minChildSize: 0.25,
                maxChildSize: 0.4,
                builder: (context, scrollController) => ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                  child: Container(
                      color: onSecondaryColor,
                      padding:
                          UIHelper.pagePaddingSmall.copyWith(top: 0, bottom: 0),
                      child: ListView(
                        controller: scrollController,
                        children: [
                          UIHelper.verticalSpaceSmall,
                          Center(
                              child: Image(
                            image: AssetImage('asset/icons/ic_gesture.png'),
                          )),
                          // UIHelper.verticalSpaceMedium,
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FindDriver(),
                                  ));
                            },
                            child: Container(
                                margin: UIHelper.pagePaddingSmall
                                    .copyWith(bottom: 0),
                                padding: UIHelper.pagePaddingSmall
                                    .copyWith(bottom: 0, top: 0),
                                height: 40,
                                decoration: BoxDecoration(
                                  color: onSecondaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 3,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.search,
                                      color: secondaryColor,
                                    ),
                                    UIHelper.horizontalSpaceSmall,
                                    Text(
                                      "Search Address",
                                      style: TextStyle(color: Colors.grey),
                                    )
                                  ],
                                )),
                          ),
                        ],
                      )),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
