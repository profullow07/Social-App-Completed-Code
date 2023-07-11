import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_test/componantes/my_button.dart';
import 'package:firebase_test/componantes/my_textfiled.dart';
import 'package:flutter/material.dart';

class RegiesterPage extends StatefulWidget {
  final void Function()? onTap;
  const RegiesterPage({super.key, required this.onTap});

  @override
  State<RegiesterPage> createState() => _RegiesterPageState();
}

class _RegiesterPageState extends State<RegiesterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final auth = FirebaseAuth.instance;
  final firestore = FirebaseFirestore.instance;

  void signUp() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));

    // confirm password matched
    if (passwordController.text != confirmPasswordController.text) {
      // pop loading circle
      Navigator.of(context).pop();
      // display error message
      dispalyMessage("Passwords do not match");
      return;
    }
    // try to sign up
    try {
      // create user account
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      // after creating user
      await firestore.collection('Users').doc(userCredential.user!.uid).set({
        'email': emailController.text.split('@')[0],
        "bio": "Add your bio",
      });

     
    } on FirebaseAuthException catch (e) {
      // display error message
      dispalyMessage(e.message!);
    }
  }

// show the message
  void dispalyMessage(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(message),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: SingleChildScrollView(
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            const SizedBox(height: 30),

            // logo

            const Icon(
              Icons.message,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            // sign up discription
            const Text(
              "Sign Up to create your account for you",
              style: TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 30),
            // email text field
            MyTextFiled(
              controller: emailController,
              hintText: "Email",
            ),
            const SizedBox(height: 20),

            // password text field
            MyTextFiled(
                controller: passwordController,
                obscureTex: true,
                hintText: "Password"),

            const SizedBox(height: 20),
            // confirom password
            MyTextFiled(
              controller: confirmPasswordController,
              hintText: "Confirm Password",
              obscureTex: true,
            ),

            const SizedBox(height: 20),
            // button login
            MyButton(
              text: "SIGN UP ",
              onTap: signUp,
            ),

            // not an member? register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // already an member?
                const Text("Already have an account?"),
                // login now
                TextButton(
                  onPressed: widget.onTap,
                  child: const Text("Login Now"),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }
}
