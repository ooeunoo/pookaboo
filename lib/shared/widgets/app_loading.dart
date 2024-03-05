import 'package:flutter/material.dart';
import 'package:pookaboo/shared/localization/generated/strings.dart';
import 'package:pookaboo/shared/widgets/app_color_loaders.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({super.key, this.showMessage = true});

  final bool showMessage;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const AppColorLoader(),
          Visibility(
            visible: showMessage,
            child: Text(
              Strings.of(context)!.pleaseWait,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
