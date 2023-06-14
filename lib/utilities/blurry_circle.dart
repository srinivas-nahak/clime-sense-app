import 'package:flutter/material.dart';
import 'dart:ui' as ui;

class BlurryCircle extends StatelessWidget {
  const BlurryCircle({required this.circleColor, super.key});

  final Color circleColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          height: double.infinity,
          width: double.infinity,
          transform: Matrix4.translationValues(
            MediaQuery.of(context).size.width * .3,
            -(MediaQuery.of(context).size.width * .4),
            0,
          ),
          child: CircleAvatar(
            backgroundColor: circleColor,
          ),
        ),
        BackdropFilter(
          filter: ui.ImageFilter.blur(
            sigmaX: 60.0,
            sigmaY: 60.0,
          ),
          child: const SizedBox(
              //color: Colors.transparent,
              ),
        )
      ],
    );
  }
}
