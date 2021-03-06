/*
 This is to display chat list screen
 */

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:myteams/models/contact.dart';
import 'package:myteams/resources/chat_methods.dart';
import 'package:myteams/resources/provider/userprovider.dart';
import 'package:myteams/screens/widgets/ContactView.dart';
import 'package:myteams/screens/widgets/HelperAppBar.dart';
import 'package:myteams/screens/widgets/InitialChatList.dart';
import 'package:provider/provider.dart';

import '../widgets/call_pickup_layout.dart';
import 'searchscreen.dart';


class ChatListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: HelperAppBar(
          title: "Chat",
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
            IconButton(
              icon: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onPressed: () {},
            ),
          ],
        ),

        body: ChatListContainer(),
      ),
    );
  }
}

class ChatListContainer extends StatelessWidget {
  final ChatMethods _chatMethods = ChatMethods();

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: _chatMethods.fetchContacts(
            userId: userProvider.getUser.uid,
          ),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              var docList = snapshot.data.docs;

              if (docList.isEmpty) {
                //when user has no chats with anyone
                return InitialList(
                  heading: "This is where all the chats are listed",
                  subtitle:
                  "Search for your friends and family to start calling or chatting with them",
                );
              }
              return ListView.builder(
                padding: EdgeInsets.all(10),
                itemCount: docList.length,
                itemBuilder: (context, index) {
                  Contact contact = Contact.fromMap(docList[index].data());

                  return ContactView(contact);
                },
              );
            }

            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
