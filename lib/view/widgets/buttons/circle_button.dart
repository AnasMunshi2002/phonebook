import 'package:flutter/material.dart';

class CButton extends StatelessWidget {
  final String text;
  final Function() event;
  final Icon icon;

  const CButton(
      {super.key, required this.text, required this.event, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        IconButton.filled(
            style: const ButtonStyle(
                padding: WidgetStatePropertyAll(EdgeInsets.all(14)),
                shape: WidgetStatePropertyAll(CircleBorder())),
            onPressed: event,
            icon: icon),
        const SizedBox(
          height: 12,
        ),
        Text(text)
      ],
    );
  }
}
