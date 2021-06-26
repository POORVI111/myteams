import 'dart:math';

import 'package:flutter/material.dart';
import 'package:myteams/resources/call_methods.dart';
import 'package:myteams/screens/callscreen.dart';

import 'constants/strings.dart';
import 'models/call.dart';
import 'models/log.dart';
import 'models/user.dart';

class CallUtils {
  static final CallMethods callMethods = CallMethods();

  static dial({UserHelper from, UserHelper to, context}) async {
    Call call = Call(
      callerId: from.uid,
      callerName: from.name,
      callerPic: from.profilePhoto,
      receiverId: to.uid,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      channelId: Random().nextInt(1000).toString(),
    );

    Log log = Log(
      callerName: from.name,
      callerPic: from.profilePhoto,
      callStatus: CALL_STATUS_DIALLED,
      receiverName: to.name,
      receiverPic: to.profilePhoto,
      timestamp: DateTime.now().toString(),
    );

    bool callMade = await callMethods.makeCall(call: call);

    
    
    call.hasDialled = true;

    if (callMade) {
      // enter log
      LogRepository.addLogs(log);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => CallScreen(call: call),
        ),
      );
    }
  }
}
