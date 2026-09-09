import 'package:flutter/material.dart';

class Customtextbody extends StatelessWidget {
  final String text;
  const Customtextbody({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text
      ,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: TextAlign.center,
    );
  }
}
