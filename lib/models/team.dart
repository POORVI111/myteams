import 'package:cloud_firestore/cloud_firestore.dart';

class Team {
  String id;
  String name;
  String leader;
  List<String> members;
  Timestamp teamCreated;

  Team({
    this.id,
    this.name,
    this.leader,
    this.members,
    this.teamCreated,

  });



  // Named constructor
  factory Team.fromDocument(DocumentSnapshot doc) {
    return Team(
        id: doc.id.toString(),
        name: doc["name"].toString(),
        leader : doc["leader"].toString(),
        members : List<String>.from(doc["members"]),
        teamCreated : doc["teamCreated"]);
  }

}