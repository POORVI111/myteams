
/*
 This is to display teams screen
 */



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myteams/models/userteam.dart';
import 'package:myteams/resources/provider/userprovider.dart';
import 'package:myteams/resources/teams_methods.dart';
import 'package:myteams/screens/chat/searchscreen.dart';
import 'package:myteams/screens/widgets/HelperAppBar.dart';
import 'package:myteams/screens/widgets/InitialChatList.dart';
import 'package:provider/provider.dart';

import 'CreateTeam.dart';
import 'TeamView.dart';
import 'call_pickup_layout.dart';


class TeamsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: HelperAppBar(
          title: "Teams",
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.black,
              ),
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SearchScreen()),
                );
              },
            ),
            PopupMenuButton(
                  tooltip: 'Menu',
              child: Icon(
                  Icons.more_vert,
                   size: 28.0,
                   color: Colors.black,
                   ),
                   itemBuilder: (context) => [
                   PopupMenuItem(
                     child: Row(
                       children: [
                         IconButton(
                          icon: Icon(
                           Icons.add,
                          color: Colors.black,
                          size: 22.0,
                          ),
                          onPressed: () {
                          Navigator.push(
                          context,
                              MaterialPageRoute(builder: (context) => CreateTeam()),
                        );


                      },
                           ),
                          Padding(
                           padding: EdgeInsets.only(
                           left: 10.0,
                           ),
                            child: Text(
                            "Create Team",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18.0,
                    ),
                  ),
                ),

              ],
            ),
          ),
                     PopupMenuItem(
                       child: Row(
                        children: [
                       IconButton(
                       icon: Icon(
                           Icons.group_outlined,
                            color: Colors.black,
                         size: 22.0,
                         ),
                         onPressed: (){
                           Navigator.push(
                             context,
                             MaterialPageRoute(builder: (context) => SearchScreen()),
                           );
                         },
                       ),
                         Padding(
                          padding: EdgeInsets.only(
                            left: 10.0,
                           ),
                         child: Text(
                         "Join Team",
                          style: TextStyle(
                         color: Colors.black,
                           fontSize: 18.0,
                    ),
                  ),
                ),
              ],
            ),
          ),

          ],
        ),
    ],
    ),
                      // floatingActionButton: NewChatButton(),
        body: TeamListContainer(),
      ),

    );
  }
}

class TeamListContainer extends StatelessWidget {
  final TeamMethods _teamMethods = TeamMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _teamMethods.fetchTeams(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.docs;

              if (docList.isEmpty) {
                //when user has no chats with anyone
                return InitialChatList(
                  heading: "This is where all the teams are listed",
                  subtitle:
                  "Search friends and family",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  UserTeam userteam = UserTeam.fromMap(docList[index].data());

                  return TeamView(userteam);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
