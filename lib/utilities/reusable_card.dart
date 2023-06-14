import 'package:flutter/material.dart';

import 'constants.dart';

class ReusableCard extends StatelessWidget {
  const ReusableCard({required this.heading, required this.body, super.key});

  final String heading, body;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: kCardColor.withOpacity(0.1),
      /*shape: RoundedRectangleBorder(
        side: BorderSide(
          color: kCardColor.withOpacity(0.1),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(15),
      ),*/
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
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
    );
  }
}
