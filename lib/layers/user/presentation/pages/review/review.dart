import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pookaboo/layers/user/presentation/pages/review/widgets/review_done.dart';
import 'package:pookaboo/layers/user/presentation/pages/review/widgets/review_undone.dart';
import 'package:pookaboo/shared/styles/dimens.dart';
import 'package:pookaboo/shared/widgets/app_text.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({
    super.key,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  late List<Map<String, dynamic>> tabs;

  @override
  void initState() {
    super.initState();

    tabs = [
      {
        "title": "작성 가능한 리뷰",
      },
      {"title": "내 리뷰"}
    ];
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: Dimens.space16),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: () {
                context.pop();
              },
            ),
          ),
          title: AppText(
            '리뷰 내역',
            style: Theme.of(context).textTheme.bodyLarge!,
          ),
          bottom: TabBar(
            tabs: tabs.map((tab) => Tab(text: tab["title"] as String)).toList(),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(vertical: Dimens.space20),
          child: const TabBarView(
            children: [
              // 첫 번째 탭: 작성 가능한 리뷰
              ReviewUndone(),
              // 두 번째 탭: 내 리뷰
              ReviewDone()
            ],
          ),
        ),
      ),
    );
  }
}
