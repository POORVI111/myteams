import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myteams/enum/user_state.dart';
import 'package:myteams/models/user.dart';
import 'package:myteams/resources/auth_methods.dart';

import '../../utilities.dart';


class OnlineDotIndicator extends StatelessWidget {
  final String uid;
  final AuthMethods _authMethods = AuthMethods();

  OnlineDotIndicator({
    @required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    getColor(int state) {
      switch (Utils.numToState(state)) {
        case UserState.Offline:
          return Colors.red;
        case UserState.Online:
          return Colors.green;
        default:
          return Colors.orange;
      }
    }

    return Align(
      alignment: Alignment.bottomRight,
      child: StreamBuilder<DocumentSnapshot>(
        stream: _authMethods.getUserStream(
          uid: uid,
        ),
        builder: (context, snapshot) {
          UserHelper user;

          if (snapshot.hasData && snapshot.data.data != null) {
            user = UserHelper.fromMap(snapshot.data.data());
          }

          return Container(
            height: 10,
            width: 10,
            margin: EdgeInsets.only(right: 5, top: 5),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: getColor(user?.state),
            ),
          );
        },
      ),
    );
  }
}
