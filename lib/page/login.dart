// ignore_for_file: use_build_context_synchronously

import 'package:firebase_test/componantes/my_button.dart';
import 'package:firebase_test/componantes/my_textfiled.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  final void Function()? onTap;
  const LoginPage({super.key, required this.onTap});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final auth = FirebaseAuth.instance;

  void signIn() async {
    // show loading circle
    showDialog(
        context: context,
        builder: (context) => const Center(
              child: CircularProgressIndicator(),
            ));
    // try to sign in
    try {
      // sign in account
      await auth.signInWithEmailAndPassword(
          email: emailController.text, password: passwordController.text);
      // pop loading circle end
      if (context.mounted) Navigator.of(context).pop();
    } on FirebaseAuthException catch (e) {
      // pop loading circle
      Navigator.of(context).pop();
      // display error message
      dispalyMessage(e.message!);
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
              Icons.person,
              size: 100,
              color: Colors.blue,
            ),

            const SizedBox(height: 30),

            // welcome back to the app
            const Text(
              "Welcome Back Buddy-Login Your Account!",
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
            // button login
            MyButton(
              text: "SIGN IN",
              onTap: signIn,
            ),

            // not an member? register
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // not an member?
                const Text("Not a member?"),
                // register
                TextButton(
                  onPressed: widget.onTap,
                  child: const Text("Register Now"),
                )
              ],
            )
          ]),
        ),
      )),
    );
  }
}
