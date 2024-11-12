import 'package:flutter/material.dart';

import '../../../view_model/theme/common.dart';
import '../avatar/avatar.dart';
import '../icons/appicons.dart';

class PButton extends StatefulWidget {
  const PButton({super.key});

  @override
  State<PButton> createState() => _PButtonState();
}

class _PButtonState extends State<PButton> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: const EdgeInsets.all(5),
      color: Colors.transparent,
      icon: CA(
        radius: 19,
        backColor: CommonColors.profile,
        child: AppIcons.person,
      ),
      onPressed: () {},
    );
  }
}
