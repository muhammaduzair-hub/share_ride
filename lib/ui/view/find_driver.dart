import 'package:RideShare/ui/base/base_widget.dart';
import 'package:RideShare/ui/custom_widget/custom_text_field.dart';
import 'package:RideShare/ui/shared/ui_helpers.dart';
import 'package:RideShare/viewmodels/views/home_view_model.dart';
import 'package:RideShare/viewmodels/views/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_stars/flutter_rating_stars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:provider/provider.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../constants/strings.dart';
import '../custom_widget/leading_back_button.dart';
import '../custom_widget/primary_button.dart';
import '../shared/app_colors.dart';
import '../shared/text_styles.dart';

class FindDriver extends StatelessWidget {
  FindDriver({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(
      builder: (context, orintation, screenType) {
        return BaseWidget<HomeViewModel>(
          model: HomeViewModel(repo: Provider.of(context)),
          builder: (context, model, child) => WillPopScope(
            onWillPop: () async {
              if (model.state == LabelSelectAdress) {
                return true;
              } else if (model.state == LabelRideOption) {
                model.switchState(LabelSelectAdress);
                return false;
              } else {
                model.switchState(LabelRideOption);
                return false;
              }
            },
            child: SafeArea(
              child: Scaffold(
                  body: Stack(
                children: [
                  GoogleMap(
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

                  //Navigator Button
                  // if(model.busy)CircularProgressIndicator()
                  // else
                  if (model.state == LabelSelectAdress)
                    LeadindBackButton(
                      ontap: () {
                        Navigator.pop(context);
                      },
                      icon: AssetImage('asset/icons/nav btn.png'),
                    )
                  else if (model.state == LabelRideOption)
                    LeadindBackButton(
                        icon: AssetImage('asset/icons/nav btn.png'),
                        ontap: () {
                          model.switchState(LabelSelectAdress);
                        })
                  else if (model.state == LabelPaymentOption)
                    LeadindBackButton(
                        icon: AssetImage('asset/icons/nav btn.png'),
                        ontap: () {
                          model.switchState(LabelRideOption);
                        }),

                  Padding(
                    padding: EdgeInsets.only(top: 2.h),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Text(
                        model.state == LabelRideOption
                            ? "Select Date Time"
                            : model.state == LabelPaymentOption
                                ? "Select Driver"
                                : model.state,
                        style: boldHeading1.copyWith(color: onPrimaryColor),
                      ),
                    ),
                  ),

                  if (model.state == LabelSelectAdress)
                    selectAdressBottomSheet(model)
                  else if (model.state == LabelRideOption)
                    DateAndFareBottomSheet(model, context) //select date time
                  else if (model.state == LabelPaymentOption)
                    driversBottomSheet(model, context), //select driver
                ],
              )),
            ),
          ),
        );
      },
    );
  }

  Widget selectAdressBottomSheet(HomeViewModel model) {
    return DraggableScrollableSheet(
      key: model.adressSelectionKey,
      initialChildSize: 0.8,
      minChildSize: 0.5,
      maxChildSize: 0.8,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        //height:80%
        child: Container(
            color: onSecondaryColor,
            //padding: UIHelper.pagePaddingSmall.copyWith(top: 0),
            padding: EdgeInsets.only(
              top: 1.h,
              left: 3.w,
              right: 3.w,
              // bottom: 2.h,
            ),
            child:
                //Height: 77%
                ListView(
              physics: NeverScrollableScrollPhysics(),
              controller: scrollController,
              children: [
                Center(
                    child: Image(
                  image: AssetImage('asset/icons/ic_gesture.png'),
                  height: 1.h,
                )),
                SizedBox(
                  height: 2.h,
                ),
                //Height:74%
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 1,
                          blurRadius: 2,
                          offset: Offset(0, 3),
                        )
                      ]),
                  padding: EdgeInsets.only(
                      top: 1.h, bottom: 1.h, right: 2.w, left: 2.w),
                  //Height:72%
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Image(
                          image: AssetImage('asset/icons/ic_route.png')),
                      UIHelper.horizontalSpaceSmall,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                              height: 3.h,
                              width: 80.w,
                              child: TextField(
                                enabled: false,
                                onTap: () {
                                  model.selectedfromTextField = true;
                                  model.setBusy(false);
                                },
                                controller: model.fromController,
                                decoration:
                                    InputDecoration.collapsed(hintText: 'From'),
                                onChanged: (val) {
                                  model.debouncer.run(() {
                                    print(model.fromController.text);
                                    if (model.fromController.text.length > 3) {
                                      model.searchAdressOnTextField(
                                          model.fromController.text);
                                    } else {
                                      LoginViewModel.showToast(
                                          "Enter Minimum 4 Characters");
                                    }
                                  });
                                },
                                textInputAction: TextInputAction.next,
                                onSubmitted: (v) {
                                  model.switchTextField();
                                },
                              )),
                          SizedBox(
                            height: 1.h,
                          ),
                          Image(
                            image: AssetImage('asset/icons/line.png'),
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                              height: 3.h,
                              width: 80.w,
                              child: TextField(
                                autofocus: true,
                                onTap: () {
                                  model.switchTextField();
                                },
                                controller: model.toController,
                                decoration:
                                    InputDecoration.collapsed(hintText: 'To'),
                                onChanged: (val) {
                                  model.debouncer.run(() {
                                    print(model.toController.text);
                                    if (model.toController.text.length > 3)
                                      model.searchAdressOnTextField(
                                          model.toController.text);
                                    else
                                      LoginViewModel.showToast(
                                          "Enter Minimum 4 Characters");
                                  });
                                },
                                textInputAction: TextInputAction.done,
                                onSubmitted: (v) {},
                              )),
                          SizedBox(
                            height: 1.h,
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                SizedBox(height: 4.h),
                SizedBox(
                  height: 4.h,
                ),
                //Height:52%
                model.busy
                    ? Center(child: CircularProgressIndicator())
                    : Container(
                        height: 50.h,
                        //group list view
                        child: GroupListView(
                          controller: scrollController,
                          sectionsCount: model.groupList.keys.toList().length,
                          countOfItemInSection: (int section) {
                            return model.groupList.values
                                .toList()[section]
                                .length;
                          },
                          itemBuilder: (context, index) => leadingListTile(
                            title: model.groupList.values
                                .toList()[index.section][index.index],
                            model: model,
                            controller: scrollController,
                          ),
                          groupHeaderBuilder: (context, section) => Text(
                            model.groupList.keys.toList()[section],
                            style:
                                boldHeading3.copyWith(color: onPrimaryColor2),
                          ),
                          separatorBuilder: (context, index) =>
                              Image(image: AssetImage('asset/icons/line.png')),
                          //sectionSeparatorBuilder: (context, section) => UIHelper.verticalSpaceMedium,
                        )),
              ],
            )),
      ),
    );
  }

  DateAndFareBottomSheet(HomeViewModel model, BuildContext screenContext) {
    return DraggableScrollableSheet(
      key: model.othersSheetKey,
      maxChildSize: 0.4,
      minChildSize: 0.4,
      initialChildSize: 0.4,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
            padding:
                EdgeInsets.only(right: 3.w, left: 3.w, top: 1.h), //,bottom: 1.h
            color: onSecondaryColor,
            //height:40%
            child: ListView(
              controller: scrollController,
              children: [
                //list view
                UIHelper.verticalSpaceMedium,
                Text(
                  "Ride Date:",
                  style: heading3.copyWith(color: onPrimaryColor2),
                ),
                UIHelper.verticalSpaceSmall,
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(model.dateFormatter()),
                      PrimaryButton(
                          text: Text("Update"),
                          ontap: () async {
                            var date = await showDatePicker(
                                context: screenContext,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime(2024));
                            model.selectedDateTime = date!;
                            TimeOfDay? time = await showTimePicker(
                                context: screenContext,
                                initialTime: TimeOfDay.now());
                            model.selectedDateTime = model.selectedDateTime
                                .copyWith(
                                    hour: time!.hour, minute: time!.minute);
                            model.setBusy(false);
                          }),
                    ],
                  ),
                ),
                Text(
                  "Expected rate:",
                  style: heading3.copyWith(color: onPrimaryColor2),
                ),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceAround,
                //   children: [
                //     Text("PKR ${model.estimatedFare}"),
                //     Container(
                //       // padding: EdgeInsets.symmetric(vertical: 2),
                //       decoration: BoxDecoration(
                //           color: Colors.green,
                //           borderRadius: BorderRadius.circular(30)),
                //       height: 40,
                //       child: Row(
                //         mainAxisSize: MainAxisSize.min,
                //         children: [
                //           //Minus Button
                //           Opacity(
                //             opacity: model.estimatedFare > 1 &&
                //                     model.estimatedFare - 5 > 1
                //                 ? 1
                //                 : 0.5,
                //             child: InkWell(
                //               child: Icon(Icons.remove,
                //                   color: Colors.white, size: 3.h),
                //               onTap: () {
                //                 if (model.estimatedFare > 1 &&
                //                     model.estimatedFare - 5 > 1) {
                //                   model.estimatedFare - 5;
                //
                //                   model.estimatedFareController.text =
                //                       model.estimatedFare.toString();
                //                   model.setBusy(false);
                //                 }
                //               },
                //             ),
                //           ),
                //
                //           //TEXT FIELD NUMBER
                //           Container(
                //             color: Colors.white,
                //             width: 10.w,
                //             child: TextField(
                //               readOnly: true,
                //               style: Theme.of(context)
                //                   .textTheme
                //                   .headline2!
                //                   .copyWith(color: Colors.blue),
                //               textAlign: TextAlign.center,
                //               textAlignVertical: TextAlignVertical.center,
                //               keyboardType: TextInputType.number,
                //               onChanged: (value) {
                //                 if (model.estimatedFareController.text.length <
                //                     3) {
                //                   model.estimatedFare = int.parse(value);
                //                 } else {
                //                   model.estimatedFareController.text =
                //                       model.bill.toInt().toString();
                //                   model.estimatedFare = model.bill.toInt();
                //                 }
                //
                //                 model.setBusy(false);
                //               },
                //               controller: model.estimatedFareController,
                //             ),
                //           ),
                //
                //           //ADD BUTTON
                //           Opacity(
                //             opacity: model.estimatedFare < 999 &&
                //                     model.estimatedFare + 5 < 999
                //                 ? 1
                //                 : 0.5,
                //             child: InkWell(
                //               child: Icon(
                //                 Icons.add,
                //                 color: Colors.white,
                //               ),
                //               onTap: () {
                //                 if (model.estimatedFare < 999 &&
                //                     model.estimatedFare + 5 < 999) {
                //                   model.estimatedFare = model.estimatedFare + 5;
                //                   model.estimatedFareController.text =
                //                       model.estimatedFare.toString();
                //                   model.setBusy(false);
                //                 }
                //               },
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),

                //Height:22%
                //Payment List tile
                Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: model.estimatedFareController,
                  ),
                ),
                ListTile(
                  onTap: () {},
                  title: Text(
                    LabelEstimateTripTime,
                    style: heading3.copyWith(color: onPrimaryColor2),
                  ),
                  subtitle: Text(
                    "${model.distance.toInt() * 3} min and PKR ${model.bill.toInt()}",
                    style: heading3.copyWith(color: secondaryColor),
                  ),
                ),
                Container(
                  margin: UIHelper.pagePaddingSmall.copyWith(bottom: 0, top: 0),
                  width: double.infinity,
                  child: model.busy
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : PrimaryButton(
                          ontap: () async {
                            await model.getDrivers();
                            model.switchState(LabelPaymentOption);
                            // await model.addAdress(model.toController.text);
                            // await model.addAdress(model.fromController.text);
                            // model.initializegroupList(model.localAdressTitles);
                            //
                            // //await model.checkDriver();
                            // dynamic driver = await model.getDriverDetails();
                            // print(
                            //     "*******We Got this*******$driver***********");
                            //
                            // if (driver == null) {
                            //   showToast("No Driver Available Currently");
                            // } else {
                            //   print("Driver Found");
                            //   await model.generateRequest();
                            //   if (requestId != '-') {
                            //     Navigator.push(
                            //         screenContext,
                            //         MaterialPageRoute(
                            //           builder: (screenContext) =>
                            //               ArrivingScreen(
                            //             requestedId: requestId!,
                            //           ),
                            //         ));
                            //   } else {
                            //     showToast("You Currently have an OnGoing Ride");
                            //   }
                            // }
                          },
                          text: Text(
                            "Find Driver",
                          ),
                        ),
                )
              ],
            )),
      ),
    );
  }

  Widget driversBottomSheet(HomeViewModel model, BuildContext screenContext) {
    return DraggableScrollableSheet(
      key: model.cardSheet,
      initialChildSize: 0.4,
      minChildSize: 0.4,
      maxChildSize: 0.4,
      builder: (context, scrollController) => ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30), topRight: Radius.circular(30)),
        child: Container(
          color: onSecondaryColor,
          padding: UIHelper.pagePaddingSmall.copyWith(top: 20),
          child: model.busy
              ? Center(child: CircularProgressIndicator())
              : model.drivers.length == 0
                  ? Center(
                      child: Text(
                        "Don't have any driver availble\nChange the requirements",
                        style: heading1,
                      ),
                    )
                  : ListView.separated(
                      controller: scrollController,
                      shrinkWrap: true,
                      itemCount: model.drivers.length,
                      separatorBuilder: (context, index) => Divider(
                        height: 2,
                      ),
                      itemBuilder: (context, index) => ListTile(
                        leading: Icon(Icons.person),
                        title: Text(model.drivers[index].user?.name ?? ""),
                        subtitle: Wrap(
                          direction: Axis.vertical,
                          children: [
                            UIHelper.verticalSpaceSmall,
                            Text("Starting Time: ${model.dateFormatter()}"),
                            UIHelper.verticalSpaceSmall,
                            RatingStars(
                              value: model.drivers[index].rating.toDouble(),
                              starBuilder: (index, color) => Icon(
                                Icons.star_outline,
                                color: color,
                              ),
                              starCount: 5,
                              starSize: 10,
                              maxValue: 5,
                              starSpacing: 5,
                              animationDuration: Duration(milliseconds: 1000),
                              valueLabelPadding: const EdgeInsets.symmetric(
                                  vertical: 1, horizontal: 8),
                              starOffColor: const Color(0xffe7e8ea),
                              starColor: Colors.yellow,
                            ),
                          ],
                        ),
                        onTap: () async {
                          model.selectedDriverIndex = index;
                          await model.createRide(screenContext);
                        },
                      ),
                    ),
        ),
      ),
    );
  }

  Widget leadingListTile(
      {required String title,
      required HomeViewModel model,
      required ScrollController controller}) {
    return ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: AssetImage('asset/icons/ic_place.png'),
        ),
        title: Text(
          title,
          style: heading2,
        ),
        //subtitle: Text("New york",style: heading3,),
        onTap: () {
          model.selectSearchItem(model.toController, title);
          // model.checkFromTextField();
          if (true) {
            if (model.toController.text != model.fromController.text) {
              model.showonMap();
              model.switchState(LabelRideOption);
              model.remoteAdressTitle.clear();
              model.initializegroupList(model.localAdressTitles);
              model.setBusy(false);
              controller.animateTo(controller.position.minScrollExtent,
                  duration: Duration(milliseconds: 500), curve: Curves.ease);
            } else
              LoginViewModel.showToast(
                  "Initial And Destination Address Must Not Be Same");
          } else {
            LoginViewModel.showToast("Invalid Initial Address");
            model.selectedfromTextField = true;
            model.checkToTextFieldval = false;
            model.selectedAddresses.add(model.toController.text);
            model.setBusy(false);
          }
        });
  }
}
