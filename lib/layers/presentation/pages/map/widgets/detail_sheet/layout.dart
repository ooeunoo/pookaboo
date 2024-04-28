import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pookabu/layers/data/models/toilet/toilet.dart';
import 'package:pookabu/layers/data/models/user/app_user.dart';
import 'package:pookabu/layers/domain/entities/user/create_user_inquiry_params.dart';
import 'package:pookabu/layers/presentation/bloc/user/user_bloc.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/inquire_dialog.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/location_guide.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/header/property.dart';
import 'package:pookabu/layers/presentation/pages/map/widgets/detail_sheet/tab_bar_view.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/widgets/common/app_snak_bar.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class DetailSheetLayout extends StatefulWidget {
  final bool isExpand;
  final Toilet toilet;

  const DetailSheetLayout({
    super.key,
    required this.isExpand,
    required this.toilet,
  });

  @override
  State<DetailSheetLayout> createState() => _DetailSheetLayoutState();
}

class _DetailSheetLayoutState extends State<DetailSheetLayout> {
  bool get isExpand => widget.isExpand;
  Toilet get toilet => widget.toilet;

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

  void openInquire() {
    context.pop();

    if (user != null) {
      showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(Dimens.space16))),
                backgroundColor: Palette.coolGrey10,
                content: InquireDialog(
                  toilet: toilet,
                  confirmPress: (String inquiry) {
                    context.read<UserBloc>().add(CreateUserInquiryEvent(
                        params: CreateUserInquiryParams(
                            toilet_id: toilet.id,
                            user_id: user!.id,
                            inquiry: inquiry)));
                  },
                ));
          });
    } else {
      NotifyRequireLoginSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /////////////////////////////////////////////
              ///  HEADER
              /////////////////////////////////////////////
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                      width: context.widthInPercent(60),
                      child: AppText(toilet.name,
                          maxLines: isExpand ? 5 : 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodyLarge!)),

                  /////////////////////////////////////////////
                  ///  Edit & Confirm Button
                  /////////////////////////////////////////////
                  if (!isExpand) ...{
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            openInquire();
                          },
                          child: AppText('문의하기',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium!
                                  .copyWith(
                                      height: Dimens.space20 / Dimens.space9,
                                      color:
                                          Palette.blueLatte.withOpacity(0.9))),
                        ),
                      ],
                    )
                  }
                ],
              ),
              const AppSpacerV(),
              /////////////////////////////////////////////
              ///  Location Guide
              /////////////////////////////////////////////
              LocationGuide(
                toilet: toilet,
                isExpand: isExpand,
              ),
              const AppSpacerV(),
            ],
          ),
        ),
        // Divider Padding 때문에 분리함
        if (isExpand) ...[
          Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimens.space20),
                child: DetailSheetProperty(toilet),
              ),
              const AppSpacerV(),
              DetailSheetTabBarView(toilet)
            ],
          ),
        ]
      ],
    );
  }
}
