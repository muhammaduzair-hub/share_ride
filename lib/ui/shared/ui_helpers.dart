import 'package:flutter/material.dart';

/// Contains useful consts to reduce boilerplate and duplicate code
class UIHelper {
  //Padding of full pages
  static const EdgeInsets pagePaddingMedium =  EdgeInsets.only(right:36, left: 36, bottom: 20 );
  static const EdgeInsets pagePaddingSmall = EdgeInsets.only(top: 30,left: 18,right: 18,bottom: 30);
  static const EdgeInsets paddingSmallest = EdgeInsets.only(top: 7.0, bottom : 7.0);

  // Vertical spacing constants. Adjust to your liking.
  static const double _VerticalSpaceLeast = 10.0;
  static const double _VerticalSpaceSmall = 10.0;
  static const double _VerticalSpaceMedium = 20.0;
  static const double _VerticalSpaceLarge = 60.0;
  static const double _VerticalSpaceXLarge = 110.0;


  // Vertical spacing constants. Adjust to your liking.
  static const double _HorizontalSpaceSmall = 10.0;
  static const double _HorizontalSpaceMedium = 20.0;
  static const double _HorizontalSpaceLarge = 60.0;

  static  Widget verticalSpaceLeast = SizedBox(height: _VerticalSpaceLeast);
  static  Widget verticalSpaceSmall = SizedBox(height: _VerticalSpaceSmall);
  static  Widget verticalSpaceMedium = SizedBox(height: _VerticalSpaceMedium);
  static  Widget verticalSpaceLarge = SizedBox(height: _VerticalSpaceLarge);
  static  Widget verticalSpaceXLarge = SizedBox(height: _VerticalSpaceXLarge);


  static const Widget horizontalSpaceSmall = SizedBox(width: _HorizontalSpaceSmall);
  static const Widget horizontalSpaceMedium = SizedBox(width: _HorizontalSpaceMedium);
  static const Widget horizontalSpaceLarge = SizedBox(width: _HorizontalSpaceLarge);
}
