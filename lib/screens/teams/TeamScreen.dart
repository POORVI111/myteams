/*
 this will display inside of particular team
 */


import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:myteams/constants/strings.dart';
import 'package:myteams/enum/view_state.dart';
import 'package:myteams/models/post.dart';
import 'package:myteams/models/team.dart';
import 'package:myteams/models/user.dart';
import 'package:myteams/resources/auth_methods.dart';
import 'package:myteams/resources/provider/UploadImageProvider.dart';
import 'package:myteams/resources/teams_post_methods.dart';
import 'package:myteams/screens/broadcast/liveBroadcast.dart';
import 'package:myteams/screens/widgets/cachedImage.dart';
import 'package:myteams/screens/widgets/call_pickup_layout.dart';
import 'package:myteams/screens/widgets/customappbar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TeamScreen extends StatefulWidget {
  final Team team;

  TeamScreen({this.team});

  @override
  _TeamScreenState createState() => _TeamScreenState();
}

class _TeamScreenState extends State<TeamScreen> {
  ImageUploadProvider _imageUploadProvider;

  final AuthMethods _authMethods = AuthMethods();
  final PostMethods _postMethods=PostMethods();

  TextEditingController textFieldController = TextEditingController();
  FocusNode textFieldFocus = FocusNode();


  UserHelper sender,postsender;
  String _currentUserId;
  bool isWriting = false;
  bool showEmojiPicker = false;

  @override
  void initState() {
    super.initState();
    _authMethods.getCurrentUser().then((user) {
      _currentUserId = user.uid;

      setState(() {
        sender = UserHelper(
          uid: user.uid,
          name: user.displayName,
          profilePhoto: user.photoURL,
        );
      });
    });
  }

  showKeyboard() => textFieldFocus.requestFocus();
  hideKeyboard() => textFieldFocus.unfocus();

  hideEmojiContainer() {
    setState(() {
      showEmojiPicker = false;
    });
  }

  showEmojiContainer() {
    setState(() {
      showEmojiPicker = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    _imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    return PickupLayout(
      scaffold: Scaffold(
        backgroundColor: Color(0xFFF6F6F6),
        appBar: customAppBar(context),
        body: Column(
          children: <Widget>[
             Flexible(
              child: postList(),
            ),

            _imageUploadProvider.getViewState == ViewState.LOADING
                ? Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.only(right: 15),
              child: CircularProgressIndicator(),
            )
                : Container(),
            chatControls(),
            showEmojiPicker ? Container(child: emojiContainer()) : Container(),
          ],
        ),
      ),
    );
  }

  emojiContainer() {
    return EmojiPicker(
      bgColor: Colors.white,
      indicatorColor: Colors.blue,
      rows: 3,
      columns: 7,
      onEmojiSelected: (emoji, category) {
        setState(() {
          isWriting = true;
        });

        textFieldController.text = textFieldController.text + emoji.emoji;
      },
      recommendKeywords: ["face", "happy", "party", "sad"],
      numRecommended: 50,
    );
  }

 //get post finally in layout
   getPost(Post post) {
    return post.type != MESSAGE_TYPE_IMAGE
        ? Text(
      post.message,
      style: TextStyle(
        color: Colors.black,
        fontSize: 16.0,
      ),
    )
        : post.photoUrl != null
        ? CachedImage(
      post.photoUrl,
      height: 250,
      width: 250,
      radius: 10,
    )
        : Text("Url was null");
  }

//to uplaod post in database
  sendPost() {
    var text = textFieldController.text;

    Post _post = Post(
      senderId: sender.uid,
      message: text,
      timestamp: Timestamp.now(),
      type: 'text',
      teamId: widget.team.id,
    );


    setState(() {
      isWriting = false;
    });

    textFieldController.text = "";

    _postMethods.addPostToDb(_post);
  }


  Widget postList()
  {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection(POSTS_COLLECTION)
          .doc(widget.team.id)
          .collection('posts')
          .orderBy(TIMESTAMP_FIELD, descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.data == null) {
          return Center(child: CircularProgressIndicator());
        }


        return ListView.builder(
          padding: EdgeInsets.all(10),
          reverse: true,
          itemCount: snapshot.data.docs.length,
          itemBuilder: (context, index) {
            return chatPostItem(snapshot.data.docs[index]);
          },
        );
      },
    );
  }
  Widget chatPostItem(DocumentSnapshot snapshot) {
    Post _post = Post.fromMap(snapshot.data());
    return Container(
      padding: EdgeInsets.all(10.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          buildPostHeader(_post),
          receiverLayout(_post),
        ],
      ),
    );
  }

  Widget receiverLayout(Post message) {
    return Container(
      color: Colors.white,
      alignment: Alignment.topLeft,

      child: Padding(
        padding: EdgeInsets.all(10),
        child: getPost(message),
      ),
    );
  }

 Widget LeadDialog(String teamid) {
  return Dialog(
    child: Container(
      height: 200.0,
      width: 100.0,
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Align(
           alignment: Alignment.center,
            child: Text(
              'Share this code',
              style:
              TextStyle(color: Colors.black, fontSize: 22.0),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              'Let others join the team',
              style:
              TextStyle(color: Colors.black, fontSize: 22.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:8.0),
         child: Align(
            alignment: Alignment.center,
            child: Text(
              teamid,
              style:
              TextStyle(color: Colors.blue, fontSize: 16.0),
            ),
          ),
          ),
        ],
      ),
    ),
  );
}

  buildPostHeader(Post post) {
    String dateLong = formatDate(
        DateTime.fromMillisecondsSinceEpoch(post.timestamp.millisecondsSinceEpoch),
        [yyyy, ' ', MM, ' ', dd, ', ', hh, ':', nn, ' ', am]);
    return FutureBuilder<UserHelper>(
      future: _authMethods.getUserDetailsById(post.senderId),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          UserHelper user = snapshot.data;

          return Container(
            color: Colors.white,
            child: ListTile(
              leading: CachedImage(
                user.profilePhoto,
                isRound: true,
                radius: 40,
              ),
              title: GestureDetector(
                onTap: () =>{},
                child: Text(
                  sender.uid==user.uid ? "You" : user.name,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              subtitle: Text(dateLong),
              trailing: IconButton(
                onPressed: () => {},
                icon: Icon(Icons.more_vert),
              ),
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );



  }
  Widget chatControls() {
    setWritingTo(bool val) {
      setState(() {
        isWriting = val;
      });
    }
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[

          SizedBox(
            width: 5,
          ),
          Expanded(
            child: Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: textFieldController,
                  focusNode: textFieldFocus,
                  onTap: () => hideEmojiContainer(),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                  onChanged: (val) {
                    (val.length > 0 && val.trim() != "")
                        ? setWritingTo(true)
                        : setWritingTo(false);
                  },
                  decoration: InputDecoration(
                    hintText: "Type a message",
                    hintStyle: TextStyle(
                      color: Colors.grey,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(50.0),
                        ),
                        borderSide: BorderSide.none),
                    contentPadding:
                    EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    filled: true,
                    //fillColor: Colors.separatorColor,
                  ),
                ),
                IconButton(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                  onPressed: () {
                    if (!showEmojiPicker) {
                      // keyboard is visible
                      hideKeyboard();
                      showEmojiContainer();
                    } else {
                      //keyboard is hidden
                      showKeyboard();
                      hideEmojiContainer();
                    }
                  },
                  icon: Icon(Icons.face),
                ),
              ],
            ),
          ),
          isWriting
              ? Container()
              : Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Icon(Icons.record_voice_over),
          ),
          isWriting
              ? Container()
              : GestureDetector(
            child: Icon(Icons.camera_alt),
            // onTap: () => pickImage(source: ImageSource.gallery),
          ),
          isWriting
              ? Container(
              margin: EdgeInsets.only(left: 10),
              decoration: BoxDecoration(
                //gradient: Colors.fabGradient,
                  shape: BoxShape.circle),
              child: IconButton(
                icon: Icon(
                  Icons.send,
                  size: 15,
                ),
                onPressed: () => sendPost(),
              ))
              : Container()
        ],
      ),
    );
  }

/*
  void pickImage({@required ImageSource source}) async {
    PickedFile selectedImage = await Utils.pickImage(source: source);
    _storageMethods.uploadImage(
        image: File(selectedImage.path),
        receiverId: widget.receiver.uid,
        senderId: _currentUserId,
        imageUploadProvider: _imageUploadProvider);
  }

*/
  CustomAppBar customAppBar(context) {
    return CustomAppBar(
      leading: IconButton(
        icon: Icon(
          Icons.arrow_back,
        ),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: false,
      title: Text(
        widget.team.name,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.video_call,
          ),
          onPressed:() async {
            await _handleCameraAndMic(Permission.camera);
            await _handleCameraAndMic(Permission.microphone);

            Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => BroadcastPage(
                userName: sender.name,
                meetName: widget.team.id,
                isBroadcaster: true,
              ),
            ),
          );},
        ),
        IconButton(
          icon: Icon(
            Icons.share,
          ),
          onPressed:() { showDialog(
    context: context,
    builder: (BuildContext context) => LeadDialog(widget.team.id));

    },

    ),
  ]
    );
  }
  Future<void> _handleCameraAndMic(Permission permission) async {
    final status = await permission.request();
    print(status);
  }
}


