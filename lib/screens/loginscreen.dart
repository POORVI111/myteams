import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/screens/widgets/call_pickup_layout.dart';

import 'broadcast/JoinMeet.dart';
import 'homescreen.dart';

class LoginScreen extends StatefulWidget {
  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final AuthMethods _authMethods = AuthMethods();



  Widget build(BuildContext context) {
    return PickupLayout(
        scaffold:
     Scaffold(
      appBar: AppBar(
          backgroundColor: new Color(0xfff8faf8),
          centerTitle: true,
          elevation: 1.0,
          title: SizedBox(
              height: 35.0, child: Text("Sign In"))),
      body:

      Column(
       children: [
         Padding(
           padding:const EdgeInsets.only(left: 20.0, right: 20.0, top: 30.0),
           child:ClipOval(

             child: Container(
               height: 240.0, width: 240.0,
                 child: Image.asset('images/introimage.jpg')
             )
           ),
         ),

         Padding(
           padding:const EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0),
           child:Text('Select an account to sign in',
               style: TextStyle(color: Colors.black, fontSize: 16.0)),
         ),
         Padding(
           padding:const EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
           child: GestureDetector(
               child: Container(
                 width: 329.0,
                 height: 50.0,
                 decoration: BoxDecoration(
                 border: Border.all(color: Colors.deepPurple),
                 borderRadius: BorderRadius.circular(10),
                 ),
                      child: Row(
                          children: <Widget>[
                            Padding(padding:const EdgeInsets.all(8.0),
                              //Image.asset('images/google.png').,
                              child: ClipOval(
                                child: Image.asset('images/google.png'),
                              ),
                            ),
                         Padding(
                            padding: const EdgeInsets.only(left: 60.0),
                          child: Text('Sign in with Google',
                         style: TextStyle(color: Colors.black, fontSize: 16.0)),
                         ),


              ],

            ),
          ),
            onTap: () {
            performLogin();
          },
        ),

         ),
         Padding(padding: const EdgeInsets.only(top: 100.0),
         child: Align(
           alignment:Alignment.center,
           child: OutlinedButton(
             onPressed: () {
               Navigator.push(
                   context,
                   MaterialPageRoute(builder: (context) => JoinMeet()));
             },


             child: Text('Join a meeting',
                 style: TextStyle(color: Colors.black, fontSize: 16.0)),


           ),
         )
         ),
    ],
    ),
     ),
      );

  }

  void performLogin() async {

    User user = await _authMethods.signIn();

    if (user != null) {
      authenticateUser(user);
    }

  }

  void authenticateUser(User user) {
    _authMethods.authenticateUser(user).then((isNewUser) {

      if (isNewUser) {
        _authMethods.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
                return HomeScreen();
              }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
              return HomeScreen();
            }));
      }
    });
  }

}
