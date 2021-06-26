import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myteams/models/team.dart';
import 'package:myteams/models/userteam.dart';
import 'package:myteams/resources/provider/userprovider.dart';
import 'package:myteams/resources/teams_methods.dart';
import 'package:myteams/utils/customtile.dart';
import 'package:myteams/utils/utilities.dart';
import 'package:provider/provider.dart';

import 'TeamScreen.dart';





class TeamView extends StatelessWidget {
  final UserTeam userteam;
  final TeamMethods _teamMethods=TeamMethods();

  TeamView(this.userteam);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Team>(
      future: _teamMethods.getTeamDetailsById(userteam.uid),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
            Team team = snapshot.data;

          return ViewLayout(
            userteam: team,
          );
        }
        return Center(
          child: CircularProgressIndicator(),

        );

      },
    );
  }
}

class ViewLayout extends StatelessWidget {
  final Team userteam;


  ViewLayout({
    @required this.userteam,
  });

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return CustomTile(
      mini: false,
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeamScreen(
              team: userteam,
            ),
          )),


      title: Text(
        (userteam != null ? userteam.name : null) != null ? userteam.name : "..",
        style:
        TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),

     subtitle:Text(
       (userteam != null ? userteam.name : null) != null ? userteam.name : "..",
       style:
       TextStyle(color: Colors.white, fontFamily: "Arial", fontSize: 19),
     ), /*LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),

      ),
       */
      leading: Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Color(Random().nextInt(0xffffffff)),
        ),
        child: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.center,
              child: Text(
                Utils.getInitials(userteam.name),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontSize: 13,
                ),
              ),
            ),


          ],


        ),
      ),
    );


  }
}
