import 'package:flutter/material.dart';

class Customaccount extends StatelessWidget {
  final String textone;
  final String texttwo;
  final void Function()? onTap;

  const Customaccount({super.key, required this.textone, required this.texttwo, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(textone,
          style: Theme.of(context).textTheme.bodySmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(width: 10),
        InkWell(
          onTap: onTap,
          child: Text(texttwo,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
