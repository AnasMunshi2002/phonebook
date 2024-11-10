import 'package:flutter/material.dart';

import '../../../view_model/theme/common.dart';
import '../icons/appicons.dart';

class CA extends StatelessWidget {
  final double radius;
  final Widget? child;
  final ImageProvider? image;
  final Color? backColor;

  const CA(
      {this.backColor,
      super.key,
      this.child,
      required this.radius,
      this.image});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: child == AppIcons.redBlock
          ? CommonColors.greyC
          : backColor ?? CommonColors.profile,
      foregroundImage: image,
      child: child,
    );
  }
}
