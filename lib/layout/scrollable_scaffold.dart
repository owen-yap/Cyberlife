import 'package:flutter/material.dart';

/* Attempt to make the layout of the app scrollable when phone is tilted.
 * Currently still buggy.
 */
class ScrollableScaffold extends StatelessWidget {
  final Widget appBar;
  final Widget body;

  ScrollableScaffold({required this.appBar, required this.body});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            toolbarHeight: kToolbarHeight,
            flexibleSpace: appBar,
          ),
        ],
        body: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: body,
            ),
          ],
        ),
      ),
    );
  }
}
