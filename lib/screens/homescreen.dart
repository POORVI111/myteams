

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:myteams/enum/user_state.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/resources/provider/userprovider.dart';
import 'package:myteams/screens/notifications/NotificationScreen.dart';
import 'package:myteams/screens/teams/TeamsListScreen.dart';
import 'package:provider/provider.dart';

import '../resources/localDB/LogRepository.dart';
import 'chat/ChatListScreen.dart';
import 'widgets/call_pickup_layout.dart';


class  HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  PageController pageController;
  int currIndex = 0;
  UserProvider userProvider;

  final AuthMethods _authMethods = AuthMethods();


  @override
  void initState() {
    super.initState();

   SchedulerBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.refreshUser();

      _authMethods.setUserState(
        userId: userProvider.getUser.uid,
        userState: UserState.Online,
      );

      LogRepository.init(
        isHive: true,
        dbName: userProvider.getUser.uid,
      );


    });



    WidgetsBinding.instance.addObserver(this);
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    String currentUserId =
    (userProvider != null && userProvider.getUser != null)
        ? userProvider.getUser.uid
        : "";

    super.didChangeAppLifecycleState(state);

    switch (state) {
      case AppLifecycleState.resumed:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Online)
            : print("resume state");
        break;
      case AppLifecycleState.inactive:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("inactive state");
        break;
      case AppLifecycleState.paused:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Waiting)
            : print("paused state");
        break;
      case AppLifecycleState.detached:
        currentUserId != null
            ? _authMethods.setUserState(
            userId: currentUserId, userState: UserState.Offline)
            : print("detached state");
        break;
    }
  }


  //home screen page view
  void onPageChanged(int page) {
    setState(() {
      currIndex = page;
    });
  }
//home screen page view
  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  @override
  Widget build(BuildContext context) {

    return PickupLayout(
        scaffold:
      Scaffold(
        backgroundColor: Colors.white,
        body: PageView(
          children: <Widget>[
            NotifScreen(),
            TeamsListScreen(),
            ChatListScreen(),
          ],
          controller: pageController,
          onPageChanged: onPageChanged,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: Container(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: CupertinoTabBar(
              backgroundColor: Colors.white,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.notifications_none_outlined,
                      color: (currIndex== 0)
                          ? Colors.deepPurple
                          : Colors.black),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group_outlined,
                      color: (currIndex == 1)
                          ? Colors.deepPurple
                          : Colors.black),

                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.chat_outlined,
                      color: (currIndex == 2)
                          ? Colors.deepPurple
                          : Colors.black),

                ),
              ],
              onTap: navigationTapped,
              currentIndex: currIndex,
            ),
          ),
        ),
        ),
    );
  }
}
