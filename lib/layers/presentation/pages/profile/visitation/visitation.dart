import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/data/models/visitation/visitation.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/layers/presentation/pages/profile/visitation/widgets/review_form.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/helper/time_helper.dart';
import 'package:pookabu/shared/utils/helper/url_helper.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_divider.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';
import 'package:pookabu/shared/widgets/app_review_header.dart';

class VisitationPage extends StatefulWidget {
  final String userId;

  const VisitationPage({super.key, required this.userId});

  @override
  State<VisitationPage> createState() => _VisitationPageState();
}

class _VisitationPageState extends State<VisitationPage> {
  late List<Visitation> _visitations = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _showBottomSheet(Visitation visitation) async {
    showModalBottomSheet(
        context: context,
        useRootNavigator: true,
        isScrollControlled: true,
        isDismissible: true,
        useSafeArea: true,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(Dimens.space20),
                topRight: Radius.circular(Dimens.space20))),
        builder: (context) {
          return SizedBox(
            height: context.heightInPercent(95),
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: ReviewForm(userId: widget.userId, visitation: visitation),
            ),
          );
        });
  }

  void _setVisitations(List<Visitation> visitations) {
    setState(() {
      _visitations = visitations;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: Dimens.space16),
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              context.back();
            },
          ),
        ),
        title: AppText(
          '최근에 방문한 화장실',
          style: Theme.of(context).textTheme.bodyLarge!,
        ),
      ),
      body: BlocConsumer<VisitataionBloc, VisitationState>(
          listener: (context, state) {
        if (state is LoadedToiletVisitationsByUserIdState) {
          _setVisitations(state.visitations);
        }
      }, builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.space20),
          child: ListView.builder(
            itemCount: _visitations.isEmpty ? 0 : _visitations.length * 2 - 1,
            itemBuilder: (context, index) {
              if (index.isOdd) {
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                  child: AppDivider(
                    color: Palette.coolGrey08,
                    height: Dimens.space1,
                  ),
                );
              }

              final visitationIndex = index ~/ 2;
              final visitation = _visitations[visitationIndex];

              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  if (!visitation.reviewed) {
                    _showBottomSheet(visitation);
                  }
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.space20, vertical: Dimens.space20),
                  child: Column(
                    children: [
                      AppReviewHeader(
                        image: visitation.toilet.image_url,
                        name: visitation.toilet.name,
                        date: visitation.created_at,
                        reviewed: visitation.reviewed,
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
