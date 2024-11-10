import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/theme/theme.dart';
import '../../widgets/avatar/avatar.dart';

class ViewImage extends StatelessWidget {
  final String image;
  final String tag;

  const ViewImage({required this.image, super.key, required this.tag});

  @override
  Widget build(BuildContext context) {
    final themeColor = context.watch<CtTheme>().currentTheme.colorScheme;
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: themeColor.secondary,
      appBar: AppBar(
        backgroundColor: themeColor.secondary,
      ),
      body: Center(
        child: SizedBox(
          height: height * 0.4,
          width: width > 600 ? width * 0.6 : width,
          child: Hero(
            tag: tag,
            child: CA(
              image: Image.file(File(image)).image,
              radius: width * 0.25,
            ),
          ),
        ),
      ),
    );
  }
}
