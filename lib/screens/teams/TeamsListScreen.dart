
/*
 This is to display all the user's team
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

import '../widgets/call_pickup_layout.dart';
import 'CreateTeam.dart';
import 'JoinTeam.dart';
import 'TeamView.dart';


class TeamsListScreen extends StatelessWidget {
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

                            GestureDetector(
                              child: Container(

                                child: Row(
                                  children: <Widget>[
                                                                         //Image.asset('images/google.png').,
                                      Icon(
                                        Icons.add,
                                        color: Colors.black,
                                        size: 22.0,
                                      ),

                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0),
                                      child: Text('Create Team        ',
                                          style: TextStyle(color: Colors.black, fontSize: 16.0)),
                                    ),


                                  ],

                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => CreateTeam()),
                                );
                              },
                            ),



              ],
            ),
          ),
                     PopupMenuItem(
                       child: Row(
                         children: [

                           GestureDetector(
                             child: Container(

                               child: Row(
                                 children: <Widget>[
                                   //Image.asset('images/google.png').,
                                   Icon(
                                     Icons.group_outlined,
                                     color: Colors.black,
                                     size: 22.0,
                                   ),

                                   Padding(
                                     padding: const EdgeInsets.only(left: 10.0),
                                     child: Text('Join team with a code',
                                         style: TextStyle(color: Colors.black, fontSize: 16.0)),
                                   ),


                                 ],

                               ),
                             ),
                             onTap: () {
                               Navigator.push(
                                 context,
                                 MaterialPageRoute(builder: (context) => JoinTeam()),
                               );
                             },
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
                return InitialList(
                  heading: "This is where all the teams are listed",
                  subtitle: "Create new teams and join teams",
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
