import 'package:flutter/material.dart';
import 'package:myteams/models/team.dart';
import 'package:myteams/models/userteam.dart';
import 'package:myteams/resources/provider/userprovider.dart';
import 'package:myteams/resources/teams_methods.dart';
import 'package:myteams/utils/customtile.dart';
import 'package:provider/provider.dart';





class TeamView extends StatelessWidget {
  final UserTeam userteam;
  final TeamMethods _teamMethods=TeamMethods();

  TeamView(this.userteam);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Team>(
      future: _teamMethods.getTeamDetailsById(userteam.uid),
      builder: (context, snapshot) {
        //print(snapshot.toString());
        if (snapshot.hasData) {
            Team team = snapshot.data;
          print('a');
          return ViewLayout(
            userteam: team,
          );
        }
        print('b');
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
      /*onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChatScreen(
              receiver: contact,
            ),
          )),

       */
      title: Text(
        (userteam != null ? userteam.name : null) != null ? userteam.name : "..",
        style:
        TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
      ),

     subtitle:Text(
       (userteam != null ? userteam.name : null) != null ? userteam.name : "..",
       style:
       TextStyle(color: Colors.black, fontFamily: "Arial", fontSize: 19),
     ), /*LastMessageContainer(
        stream: _chatMethods.fetchLastMessageBetween(
          senderId: userProvider.getUser.uid,
          receiverId: contact.uid,
        ),

      ),
       */
      leading: Container(
        constraints: BoxConstraints(maxHeight: 60, maxWidth: 60),
        child: Stack(
          children: <Widget>[
            /*
            CachedImage(
              contact.profilePhoto,
              radius: 80,
              isRound: true,
            ),
            OnlineDotIndicator(
              uid: contact.uid,
            ),

             */
          ],


        ),
      ),
    );


  }
}
