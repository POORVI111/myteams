import 'package:cloud_firestore/cloud_firestore.dart';

class UserTeam  {
  String uid;
  Timestamp addedOn;

  UserTeam({
    this.uid,
    this.addedOn,
  });

  Map toMap(UserTeam userteam) {
    var data = Map<String, dynamic>();
    data['userteam_id']  =userteam.uid;
    data['added_on'] = userteam.addedOn;
    return data;
  }

  UserTeam.fromMap(Map<String, dynamic> mapData) {
    this.uid = mapData['userteam_id'];
    this.addedOn = mapData['added_on'];
  }
}
