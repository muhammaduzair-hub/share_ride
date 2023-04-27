import 'package:flutter/material.dart';

class LeadindBackButton extends StatelessWidget {
  LeadindBackButton({Key? key, required this.icon, required this.ontap})
      : super(key: key);
  final AssetImage icon;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: icon,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class LeadingBackButton extends StatelessWidget {
  LeadingBackButton(
      {Key? key, required this.icon, required this.ontap, required this.radius})
      : super(key: key);
  final AssetImage icon;
  final VoidCallback ontap;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        radius: 30,
        backgroundImage: icon,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}

class NavButton extends StatelessWidget {
  NavButton({Key? key, required this.icon, required this.ontap, this.radius})
      : super(key: key);
  final AssetImage icon;
  final VoidCallback ontap;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: CircleAvatar(
        radius: radius ?? 40,
        backgroundImage: icon,
        backgroundColor: Colors.transparent,
      ),
    );
  }
}
