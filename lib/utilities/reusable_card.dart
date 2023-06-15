import 'package:flutter/material.dart';

import 'constants.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({required this.heading, required this.body, super.key});

  final String heading, body;

  @override
  Widget build(BuildContext context) {
    return Padding(
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
    );
  }
}
