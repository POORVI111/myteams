import 'package:flutter/material.dart';
import 'package:myteams/models/user.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/resources/teams_methods.dart';


class JoinTeam extends StatefulWidget {
  @override
  _JoinTeamState createState() => _JoinTeamState();

}

class _JoinTeamState extends State<JoinTeam> {
  final TeamMethods _teamMethods = TeamMethods();
  final AuthMethods _authMethods = AuthMethods();
  TextEditingController nameController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Join Team',
            style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: ListView(
        physics: BouncingScrollPhysics(),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Enter code to join',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: 'Enter code',
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
              child: Text('Join team',
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
    if (commName.isEmpty
         ) {
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

      await _teamMethods.jointeam(commName,user);

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
      title: Text("Couldn't join this team with that code."),
      content: Text(
          "Double check the code or try another one"),
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
