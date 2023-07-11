import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/componantes/helper_date.dart';
import 'package:firebase_test/componantes/like_button.dart';
import 'package:flutter/material.dart';
import 'comment_page.dart';
import 'comment_button.dart';

class PostWall extends StatefulWidget {
  final String postcommenst;
  final String user;
  final String timeStamp;
  final String postid;
  final List<String> likes;

  const PostWall({
    super.key,
    required this.postcommenst,
    required this.user,
    required this.timeStamp,
    required this.postid,
    required this.likes,
  });

  @override
  State<PostWall> createState() => _PostWallState();
}

class _PostWallState extends State<PostWall> {
  // current user
  final currentUser = FirebaseAuth.instance.currentUser!;
  // comment controller
  final commentController = TextEditingController();

  // firebase instance
  final db = FirebaseFirestore.instance;

// like bolen
  bool isLiked = false;

  @override
  void initState() {
    super.initState();
    isLiked = widget.likes.contains(currentUser.email!);
  }

  // toggole likes
  void toggleLike() {
    setState(() {
      isLiked = !isLiked;
    });

    // Document reference to firebase database
    DocumentReference postRef = db.collection("Post User").doc(widget.postid);

    // update likes
    if (isLiked) {
      postRef.update({
        "likes": FieldValue.arrayUnion([currentUser.email])
      });
    } else {
      postRef.update({
        "likes": FieldValue.arrayRemove([currentUser.email])
      });
    }
  }

  // add commets
  void addComments(String commentText) {
    // add comment
    db.collection("Post User").doc(widget.postid).collection("comments").add({
      "comment": commentText,
      "user": currentUser.email!,
      "time": Timestamp.now(),
    });
  }

  // showCommentDiolog comments
  void showCommentDiolog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: TextField(
          controller: commentController,
          decoration: const InputDecoration(
            hintText: "Write your comment",
          ),
        ),
        actions: [
          // cancel button
          TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // clear text
                commentController.clear();
              },
              child: const Text("Cancel")),
          // post button
          TextButton(
              onPressed: () {
                // add comment
                addComments(commentController.text);
                // clear text
                commentController.clear();
                // navigate back
                Navigator.of(context).pop();
              },
              child: const Text("Post")),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // post user
            Row(
              children: [
                // user image
                Icon(
                  Icons.person,
                  size: 30,
                  color: Colors.grey[200],
                ),
                const SizedBox(
                  width: 10.0,
                ),

                // user gmail
                Text(
                  widget.user,
                  style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[300]),
                ),
                const SizedBox(
                  width: 10.0,
                ),

                // post time
                Text(
                  widget.timeStamp,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w300,
                      color: Colors.grey[500]),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            // post comments
            Text(
              widget.postcommenst,
              overflow: TextOverflow.ellipsis,
              maxLines: 4,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 15.0,
            ),

            // like button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    // like button
                    LikeButton(onPressed: toggleLike, isLiked: isLiked),

                    // like count
                    Text(
                      "${widget.likes.length}",
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ],
                ),

                // comment by user
                Column(
                  children: [
                    // comment button
                    CommentButton(onTap: showCommentDiolog),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 5.0),
            // comment
            const Text("Comments"),
            const SizedBox(height: 5.0),
            // comment count
            StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection("Post User")
                  .doc(widget.postid)
                  .collection("comments")
                  .orderBy("time", descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                // loading circle
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: snapshot.data!.docs.map((doc) {
                    final commentData = doc.data() as Map<String, dynamic>;
                    return CommentPage(
                      commentText: commentData['comment'],
                      commentBy: commentData['user'],
                      time: Formatdate(
                        commentData['time'],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
