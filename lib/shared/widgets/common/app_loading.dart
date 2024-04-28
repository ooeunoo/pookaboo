import 'package:flutter/material.dart';
import 'package:pookabu/shared/localization/generated/message.dart';
import 'package:pookabu/shared/widgets/common/app_color_loaders.dart';

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
              Messages.of(context)!.pleaseWait,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
