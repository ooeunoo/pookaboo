import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kakao_map_plugin/kakao_map_plugin.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/presentation/bloc/map/map_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_button.dart';

class DetailSheetButton extends StatefulWidget {
  final Toilet toilet;

  const DetailSheetButton({super.key, required this.toilet});

  @override
  State<DetailSheetButton> createState() => _DetailSheetButtonState();
}

class _DetailSheetButtonState extends State<DetailSheetButton> {
  AppUser? user;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  void _fetchUser() {
    UserState state = context.read<UserBloc>().state;
    if (state is AuthenticatedState) {
      setState(() {
        user = state.user;
      });
    }
  }

  void _startNavigation() {
    context.back();
    if (user != null) {
      context.read<VisitataionBloc>().add(CreateToiletVisitationEvent(
          user_id: user!.id, toilet_id: widget.toilet.id));
    }
    context.read<MapBloc>().add(StartNavigationEvent(toilet: widget.toilet));
  }

  @override
  Widget build(BuildContext context) {
    return AppButton(title: '길찾기', onPressed: _startNavigation);
  }
}
