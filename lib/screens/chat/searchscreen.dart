/*
this is created to search users
*/


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:myteams/models/user.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/screens/widgets/customtile.dart';

import '../widgets/cachedImage.dart';
import '../widgets/call_pickup_layout.dart';
import 'chatscreen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final AuthMethods _authMethods = AuthMethods();

  List<UserHelper> userList;
  String query = "";
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _authMethods.getCurrentUser().then((User user) {
      _authMethods.fetchAllUsers(user).then((List<UserHelper> list) {
        setState(() {
          userList = list;
        });
      });
    });
  }

  searchAppBar(BuildContext context) {
    return AppBar(
       backgroundColor: Colors.white,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: Colors.black),
        onPressed: () => Navigator.pop(context),
      ),
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight+10),
        child: Padding(
          padding: EdgeInsets.only(left: 20),
          child: TextField(
            controller: searchController,
            onChanged: (val) {
              setState(() {
                query = val;
              });
            },
            cursorColor: Colors.black,
            autofocus: true,
            style: TextStyle(
              color: Colors.black87,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              suffixIcon: IconButton(
                icon: Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  WidgetsBinding.instance
                      .addPostFrameCallback((_) => searchController.clear());
                },
              ),
              border: InputBorder.none,
              hintText: "Search",
              hintStyle: TextStyle(
                fontSize: 20,
                color: Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }


//returns list view of queried users
  searchUserList(String query) {
    final List<UserHelper> suggestionList = query.isEmpty
    ? []
    : userList != null?
    userList.where((UserHelper user) {
    if (query != null || user.username != null || user.name != null) {
    String _getUsername = user.username.toLowerCase();
    String _query = query.toLowerCase();
    String _getName = user.name.toLowerCase();
    bool matchesUsername = _getUsername.contains(_query);
    bool matchesName = _getName.contains(_query);

    return (matchesUsername || matchesName);
    } else { return false; }

    }).toList()
        : [];

    return ListView.builder(
    itemCount: suggestionList.length,
    itemBuilder: ((context, index) {
    UserHelper searchedUser = UserHelper(
    uid: suggestionList[index].uid,
    profilePhoto: suggestionList[index].profilePhoto,
    name: suggestionList[index].name,
    username: suggestionList[index].username);


    return CustomTile(
    mini: false,
    onTap: () {
    Navigator.push(
    context,
    MaterialPageRoute(
    builder: (context) => ChatScreen(
    receiver: searchedUser,
    )));
    },
    leading: CachedImage(
    searchedUser.profilePhoto,
    radius: 35,
    isRound: true,
    ),
    // leading: CircleAvatar(
    //   backgroundImage: NetworkImage(searchedUser.profilePhoto),
    //   backgroundColor: Colors.grey,
    // ),
    title: Text(
    searchedUser.username,
    style: TextStyle(
    color: Colors.grey,
    fontWeight: FontWeight.bold,
    ),
    ),
    subtitle: Text(
    searchedUser.name,
    style: TextStyle(color: Colors.black),
    ),
    );
    }),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Colors.white,
        appBar: searchAppBar(context),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: searchUserList(query),
        ),
      ),
    );
  }
}
