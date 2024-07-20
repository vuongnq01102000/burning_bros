

import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WidgetFooterCustom extends StatelessWidget {
  const WidgetFooterCustom({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomFooter(builder: (context, mode) {
      Widget body;
      if (mode == LoadStatus.idle) {
        body = const Text("pull up load");
      } else if (mode == LoadStatus.loading) {
        body = const SizedBox.shrink();
      } else if (mode == LoadStatus.failed) {
        body = const Text("Load Failed!Click retry!");
      } else if (mode == LoadStatus.canLoading) {
        body = const Text("release to load more");
      } else {
        body = const Text("No more Data");
      }
      return SizedBox(
        height: 20.0,
        child: Center(child: body),
      );
    });
  }
}
