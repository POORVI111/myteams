import 'package:flutter/material.dart';
import 'package:myteams/screens/widgets/userProfileWidget.dart';

import '../../customappbar.dart';

class HelperAppBar extends StatelessWidget implements PreferredSizeWidget {
  final title;
  final List<Widget> actions;

  const HelperAppBar({
    Key key,
    @required this.title,
    @required this.actions,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomAppBar(
      leading: UserProfileWidget(),
      title: (title is String)
          ? Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      )
          : title,
      centerTitle: false,
      actions: actions,
    );
  }

  final Size preferredSize = const Size.fromHeight(kToolbarHeight + 10);
}
