import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:pookabu/shared/constant/assets.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/router/app_routes.dart';
import 'package:pookabu/shared/styles/palette.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  _SplashPageState createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Palette.coolGrey12,
        body: Center(
          child: Lottie.asset(
            Assets.splash,
            width: context.widthInPercent(100),
            height: context.heightInPercent(100),
            fit: BoxFit.fill,
            controller: _controller,
            onLoaded: (composition) {
              _controller
                ..duration = composition.duration
                ..forward().whenComplete(() => {
                      Future.delayed(const Duration(seconds: 1), () {
                        context.go(AppRoutes.map.path);
                      }),
                    });
            },
          ),
        ),
      ),
    );
  }
}
