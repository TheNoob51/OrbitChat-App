import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

class DividerWithText extends StatelessWidget {
  final String text;
  final TextStyle textStyle;
  final Color color;

  const DividerWithText(
      {super.key,
      required this.text,
      required this.color,
      required this.textStyle});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Divider(color: color)),
        const Gap(10),
        Text(
          text,
          style: textStyle,
        ),
        const Gap(10),
        Expanded(child: Divider(color: color)),
      ],
    );
  }
}
