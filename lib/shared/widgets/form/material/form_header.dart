import 'package:flutter/material.dart';
import 'package:pookabu/shared/styles/dimens.dart';

class FormHeader extends StatelessWidget {
  final String title;
  const FormHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(title,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: Dimens.bodyLarge)),
        ),
      ],
    );
  }
}
