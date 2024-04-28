import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/layout.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/button.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/login_message.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/widgets/common/app_drag_handle_bar.dart';

class DetailSheet extends StatefulWidget {
  final ScrollController controller;
  final Toilet toilet;
  final double offset;

  const DetailSheet(
      {super.key,
      required this.offset,
      required this.toilet,
      required this.controller});

  @override
  State<DetailSheet> createState() => _DetailSheetState();
}

class _DetailSheetState extends State<DetailSheet> {
  bool isExpand = false;

  @override
  Widget build(BuildContext context) {
    isExpand = widget.offset > 0.4;

    return Stack(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: EdgeInsets.all(Dimens.space12),
            child: const AppDragHandleBar(),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.space36),
          child: SingleChildScrollView(
            controller: widget.controller,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DetailSheetLayout(
                  toilet: widget.toilet,
                  isExpand: isExpand,
                ),
              ],
            ),
          ),
        ),
        BlocBuilder<UserBloc, UserState>(builder: (context, UserState state) {
          bool isAuthenticated = state is AuthenticatedState;
          return Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: EdgeInsets.all(Dimens.space20),
              child: !isAuthenticated && isExpand
                  ? const LogInMessage()
                  : DetailSheetButton(toilet: widget.toilet),
            ),
          );
        })
      ],
    );
  }
}
