import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pookabu/layers/data/models/announcement/announcement.dart';
import 'package:pookabu/layers/presentation/bloc/announcement/announcement_bloc.dart';
import 'package:pookabu/layers/presentation/bloc/visitation/visitation_bloc.dart';
import 'package:pookabu/layers/presentation/pages/profile/announcement/widget/announcement_header.dart';
import 'package:pookabu/shared/extension/context.dart';
import 'package:pookabu/shared/styles/dimens.dart';
import 'package:pookabu/shared/styles/palette.dart';
import 'package:pookabu/shared/utils/logging/log.dart';
import 'package:pookabu/shared/widgets/common/app_divider.dart';
import 'package:pookabu/shared/widgets/common/app_spacer_v.dart';
import 'package:pookabu/shared/widgets/common/app_text.dart';

class AnnouncementPage extends StatefulWidget {
  const AnnouncementPage({super.key});

  @override
  _AnnouncementPageState createState() => _AnnouncementPageState();
}

class _AnnouncementPageState extends State<AnnouncementPage> {
  late List<Announcement> _announcements = [];

  void _setAnnouncements(List<Announcement> announcements) {
    setState(() {
      _announcements = announcements;
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
      body: BlocConsumer<AnnouncementBloc, AnnouncementState>(
          listener: (context, state) {
        if (state is LoadedAnnouncementsState) {
          log.d(state.announcements);
          _setAnnouncements(state.announcements);
        }
      }, builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.space20),
          child: ListView.builder(
            itemCount:
                _announcements.isEmpty ? 0 : _announcements.length * 2 - 1,
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

              final announcementsIndex = index ~/ 2;
              final announcement = _announcements[announcementsIndex];

              return InkWell(
                splashColor: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: Dimens.space20, vertical: Dimens.space20),
                  child: Column(
                    children: [AnnouncementHeader(header: announcement.header)],
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
