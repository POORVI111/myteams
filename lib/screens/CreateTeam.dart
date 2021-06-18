



import 'package:flutter/material.dart';
import 'package:myteams/models/user.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/resources/teams_methods.dart';


class CreateTeam extends StatefulWidget {
  @override
  _CreateTeamState createState() => _CreateTeamState();
}

class _CreateTeamState extends State<CreateTeam> {
  final TeamMethods _teamMethods = TeamMethods();
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController nameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Create Community',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Name',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Name your community',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 18),
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Theme.of(context).buttonColor),
                  ),
                ),
              )),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FlatButton(
              onPressed: createCommunity,
              child: Text('Create Community',
                  style: TextStyle(
                      color: Theme.of(context).accentColor, fontSize: 18)),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0),
                  side: BorderSide(color: Theme.of(context).accentColor)),
            ),
          )
        ],
      ),
    );
  }

  // This will create community
  createCommunity() async {
    String commName = nameController.text;
    if (commName.isEmpty ||
        commName.length < 3 ||
        commName.length > 25) {
      await showAlertDialog(context);
      return;
    }
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(hours: 1),
      content: Row(
        children: <Widget>[
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.grey),
          ),
          SizedBox(
            width: 15,
          ),
          Text("Uploading...")
        ],
      ),
    ));
    try {
     UserHelper user=await _authMethods.getUserDetails();

     await _teamMethods.createteam(commName,user);

      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Community creation done.'),
      ));
    } catch (e) {
      print(e.toString());
      _scaffoldKey.currentState.hideCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text('Community creation failed.'),
      ));
    }
    Navigator.pop(context);
  }





  // This will show alert dialogue in case of error
  showAlertDialog(BuildContext context) async {
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Community name should be alphanumeric"),
      content: Text(
          "No special characters or spaces allowed. Length should be between 3 and 25 (inclusive)"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
