import 'package:cloud_firestore/cloud_firestore.dart';

class Post {
  String senderId;
  String type;
  String message;
  Timestamp timestamp;
  String photoUrl;
  String teamId;

  Post({
    this.senderId,
    this.type,
    this.message,
    this.timestamp,
    this.teamId,
  });

  //only called when  user wants to send an image
  // named constructor
  Post.imagePost({
    this.senderId,
    this.message,
    this.type,
    this.timestamp,
    this.photoUrl,
    this.teamId,
  });

  Map toMap() {
    var map = Map<String, dynamic>();
    map['senderId'] = this.senderId;
    map['type'] = this.type;
    map['message'] = this.message;
    map['timestamp'] = this.timestamp;
    map['teamId']=this.teamId;
    return map;
  }

  Map toImageMap() {
    var map = Map<String, dynamic>();
    map['message'] = this.message;
    map['senderId'] = this.senderId;
    map['type'] = this.type;
    map['timestamp'] = this.timestamp;
    map['photoUrl'] = this.photoUrl;
    map['teamId']=this.teamId;
    return map;
  }

  // named constructor
  Post.fromMap(Map<String, dynamic> map) {
    this.senderId = map['senderId'];
    this.type = map['type'];
    this.message = map['message'];
    this.timestamp = map['timestamp'];
    this.photoUrl = map['photoUrl'];
    this.teamId=map['teamId'];
  }
}
