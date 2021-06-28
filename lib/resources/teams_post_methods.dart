import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myteams/constants/strings.dart';
import 'package:myteams/models/post.dart';

class PostMethods {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference _postCollection =
  _firestore.collection(POSTS_COLLECTION);

  Future<void> addPostToDb(
      Post post,
      ) async {
    var map = post.toMap();

     await _postCollection
        .doc(post.teamId)
       .collection('posts')
        .add(map);

  }

}