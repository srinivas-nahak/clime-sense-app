import 'package:flutter/material.dart';

import 'constants.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard(
      {required this.heading,
      required this.body,
      required this.onPressed,
      super.key});

  final String heading, body;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: kCardColor.withOpacity(0.1),
      surfaceTintColor: Colors.transparent,
      borderRadius: BorderRadius.circular(25),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 25),
          child: Column(children: [
            Text(
              heading,
              style: kHeadingTextStyle,
            ),
            Text(
              body,
              style: kBodyTextStyle,
            )
          ]),
        ),
      ),
    );
  }
}
