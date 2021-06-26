import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import 'liveBroadcast.dart';

class JoinMeet extends StatefulWidget {
  @override
  _JoinMeet createState() => _JoinMeet();
}

class _JoinMeet extends State<JoinMeet> {
  final _username = TextEditingController();
  final _meetName = TextEditingController();
  bool _isBroadcaster = false;
  String check = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: Center(
          child: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: <Widget>[
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[

                      Container(
                        width: MediaQuery.of(context).size.width * 0.85,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            TextFormField(
                              controller: _username,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Username',
                              ),
                            ),
                            TextFormField(
                              controller: _meetName,
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(20),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                hintText: 'Meeting Id',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: SwitchListTile(
                            title: _isBroadcaster
                                ? Text('Broadcaster')
                                : Text('Audience'),
                            value: _isBroadcaster,
                            activeColor: Color.fromRGBO(45, 156, 215, 1),
                            secondary: _isBroadcaster
                                ? Icon(
                              Icons.account_circle,
                              color: Color.fromRGBO(45, 156, 215, 1),
                            )
                                : Icon(Icons.account_circle),
                            onChanged: (value) {
                              setState(() {
                                _isBroadcaster = value;
                                print(_isBroadcaster);
                              });
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 25),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.85,
                          decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(20)),
                          child: MaterialButton(
                            onPressed: onJoin,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'Join ',
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 1,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                Icon(
                                  Icons.arrow_forward,
                                  color: Colors.white,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      Text(
                        check,
                        style: TextStyle(color: Colors.red),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  Future<void> onJoin() async {
    if (_username.text.isEmpty || _meetName.text.isEmpty) {
      setState(() {
        check = 'Username and Meeting Id are required fields';
      });
    } else {
      setState(() {
        check = '';
      });
      await _handleCameraAndMic(Permission.camera);
      await _handleCameraAndMic(Permission.microphone);
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => BroadcastPage(
            userName: _username.text,
            meetName: _meetName.text,
            isBroadcaster: _isBroadcaster,
          ),
        ),
      );
    }
  }

  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}