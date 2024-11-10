import 'package:flutter/material.dart';

import '../../../view_model/theme/common.dart';

class Tf extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final TextInputType? type;

  const Tf(
      {required this.hint,
      required this.controller,
      super.key,
      this.type = TextInputType.text});

  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType: type,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint,
          hintStyle: TextStyle(color: CommonColors.greyC)),
    );
  }
}
