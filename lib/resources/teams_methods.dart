
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:myteams/constants/strings.dart';
import 'package:myteams/models/team.dart';
import 'package:myteams/models/user.dart';
import 'package:myteams/models/userteam.dart';

class TeamMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _userCollection =
  _firestore.collection(USERS_COLLECTION);

  DocumentReference getTeamsDocument({String userid, String teamid}) =>
      _userCollection
          .doc(userid).collection(TEAMS_COLLECTION).doc(teamid);


  addToTeams({String teamId, String userId}) async {
    Timestamp currentTime = Timestamp.now();

    await addToUserTeam(teamId, currentTime, userId);

  }

  Future<void> addToUserTeam(
      String teamId,
      currentTime,
      String userId,
      ) async {
    DocumentSnapshot Snapshot =
    await getTeamsDocument(userid: userId, teamid: teamId).get();

    if (!Snapshot.exists) {
      //does not exists
      UserTeam team = UserTeam(
        uid: teamId,
        addedOn: currentTime,
      );

      var userMap = team.toMap(team);
      await getTeamsDocument(userid: userId,teamid: teamId)
          .set(userMap);
    }
  }

  Future<void> createteam(String teamName, UserHelper user) async {
  //  String retVal = "error";
    List<String> members = List();


    try {



      DocumentReference _docRef;


      _docRef = await _firestore.collection(TEAMS_COLLECTION).add({
        'name': teamName.trim(),
        'leader': user.uid,
        'members': members,
        'teamCreated': Timestamp.now(),



      });
      await addToTeams(userId: user.uid, teamId: _docRef.id);

     print( "success");
    } catch (e) {
      print(e);
    }

   // return retVal;
  }

  Future<String> jointeam(String teamId, UserHelper user) async {
    String retVal = "error";
    List<String> members = List();


    try {
      members.add(user.uid);

      await _firestore.collection(TEAMS_COLLECTION).doc(teamId).update({
        'members': FieldValue.arrayUnion(members),

      });


      retVal = "success";
    } on PlatformException catch (e) {
      retVal = "Make sure you have the right team ID!";
      print(e);
    } catch (e) {
      print(e);
    }

    return retVal;
  }

  Stream<QuerySnapshot> fetchTeams({String userId}) => _userCollection
      .doc(userId)
      .collection(TEAMS_COLLECTION)
      .snapshots();

  Future<Team> getTeamDetailsById(id) async {
    try {
      DocumentSnapshot documentSnapshot =
      await _firestore.collection(TEAMS_COLLECTION).doc(id).get();
      return Team.fromDocument(documentSnapshot);
    } catch (e) {
      print( e);
      return null;
    }
  }


}
