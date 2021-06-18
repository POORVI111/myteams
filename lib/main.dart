import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/resources/provider/upload_image_provier.dart';
import 'package:myteams/resources/provider/userprovider.dart';
import 'package:myteams/screens/homescreen.dart';
import 'package:myteams/screens/loginscreen.dart';
import 'package:myteams/screens/searchscreen.dart';
import 'package:provider/provider.dart';
import 'package:splashscreen/splashscreen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  var _authmethods = AuthMethods();

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => ImageUploadProvider()),
      ChangeNotifierProvider(create: (_) => UserProvider()),
    ],
      child: MaterialApp(

      initialRoute: '/',
       routes: {
       '/searchscreen': (context) => SearchScreen(),
      },
       title: 'Teams',
        debugShowCheckedModeBanner: false,
        theme: new ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Colors.black,
            primaryIconTheme: IconThemeData(color: Colors.black),
            primaryTextTheme: TextTheme(
                title: TextStyle(color: Colors.black, fontFamily: "Aveny")),
            textTheme: TextTheme(title: TextStyle(color: Colors.black))),
        home: FutureBuilder(
          future: _authmethods.getCurrentUser(),
          builder: (context, AsyncSnapshot<User> snapshot) {
            if (snapshot.hasData) {
              return
                HomeScreen();
            } else {
              return SplashScreen(
                seconds: 6,
                navigateAfterSeconds: LoginScreen(),
                title: new Text('Microsoft Teams',textScaleFactor: 2,),
                image: new Image.asset('images/introimage.jpg', height:400),
                loadingText: Text("Loading"),
                photoSize: 100.0,
                loaderColor: Colors.deepPurple,
              );
            }
          },
        )
    ),
    );
  }
}