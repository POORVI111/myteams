import 'package:flutter/material.dart';
import 'package:myteams/screens/notifications/NotifList.dart';
import 'package:myteams/screens/widgets/HelperAppBar.dart';

import '../widgets/call_pickup_layout.dart';


class NotifScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: HelperAppBar(
          title: "Feed",
          actions: <Widget>[
          ],
        ),

        body: Padding(
          padding: EdgeInsets.only(left: 15),
          child: NotifListContainer(),
        ),
      ),
    );
  }
}