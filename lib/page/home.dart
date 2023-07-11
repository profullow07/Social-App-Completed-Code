import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/componantes/my_textfiled.dart';
import 'package:firebase_test/page/profile_page.dart';
import 'package:flutter/material.dart';
import '../componantes/helper_date.dart';
import '../componantes/mydrawer.dart';
import '../componantes/post_wall.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // auth instance
  final auth = FirebaseAuth.instance;
  // firestore instance
  final firestore = FirebaseFirestore.instance;

  // controller
  final controller = TextEditingController();

  // post wall
  void postWall() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // try to post
    try {
      // post wall
      if (controller.text.isNotEmpty) {
        firestore.collection("Post User").add({
          "post": controller.text,
          "userEmail": auth.currentUser!.email!,
          "timeStamp": Timestamp.now(),
          "likes": [],
        });
      }

      // clear text
      setState(() {
        controller.clear();
      });

      // pop loading circle end
      Navigator.of(context).pop();
    } on FirebaseException catch (e) {
      // display error message
      dispalyMessage(e.message!);
      Navigator.of(context).pop();
    }
  }

  // display message
  void dispalyMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

// use signout
  void signOUt() {
    auth.signOut();
  }


    

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 0.0,
        title: Text(auth.currentUser!.email!),
      ),

      // drawer section
      drawer: Mydreawer(
        signOut: signOUt,
        goToFavorite: () {},
        gotToProfile: () {
          Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ProfilePage()),
    );
  
        },
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          children: [
            // post wall
            Expanded(
              child: StreamBuilder(
                  stream: firestore
                      .collection("Post User")
                      .orderBy("timeStamp", descending: false)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final post = snapshot.data!.docs[index];
                            return PostWall(
                              postcommenst: post['post'],
                              user: post['userEmail'],
                              postid: post.id,
                              likes: List<String>.from(post['likes'] ?? []),
                              timeStamp: Formatdate(
                                post['timeStamp'],
                              ),
                            );
                          });
                    } else if (snapshot.hasError) {
                      return Text(snapshot.error.toString());
                    }
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
            ),

            // post section
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0, top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: MyTextFiled(
                        hintText: "Write your post...", controller: controller),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: postWall,
                    child: Container(
                      padding: const EdgeInsets.all(15.0),
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
