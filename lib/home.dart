import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:task2_freelance/Auth/login.dart';
import 'package:task2_freelance/MyDoc.dart';
import 'package:task2_freelance/createDoc.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late FirebaseAuth auth;
  @override
  void initState() {
    super.initState();
    auth = FirebaseAuth.instance;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          signOut();
          Get.to(const Login());
        },
        label: const FaIcon(FontAwesomeIcons.signOut),
        backgroundColor: Colors.red,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      backgroundColor: Colors.blue.shade100,
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: SizedBox(
              height: 200,
              width: 200,
              child: Lottie.asset('assets/file.json'),
            ),
          ),
          ElevatedButton(
            onPressed: (() {
              Get.to(const MyDoc());
            }),
            child: const Text("My Documents"),
          ),
          ElevatedButton(
            onPressed: (() {
              Get.to(const CreateNewDoc());
            }),
            child: const Text("Create a New Documents"),
          ),
        ],
      )),
    );
  }

  void signOut() async {
    try {
      var _user = await GoogleSignIn().currentUser;
      if (_user != null) {
        await GoogleSignIn().signOut();
        print("Sign Out");
      }
      await auth.signOut();
    } catch (e) {
      print(e.toString());
    }
  }
}
