import 'dart:async';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/auth/authscreen.dart';
import 'package:todo/screens/Home.dart';
import 'package:todo/auth/authscreen.dart';
import 'package:firebase_core/firebase_core.dart';

class MySplash extends StatefulWidget {
  @override
  _MySplashPageState createState() => _MySplashPageState();
}

class _MySplashPageState extends State<MySplash> {
  @override
  void initState() {
    super.initState();

    // Simulate a long-running task to show the splash screen
    Future.delayed(
      Duration(seconds: 2), // Adjust the duration as needed
          () async {
        showOverlay(context);
        await _loadData(); // Your asynchronous data loading function
        hideOverlay(context);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, userssnapshot) {
                  if (userssnapshot.hasData) {
                    return Home();
                  } else {
                    return AuthScreen();
                  }
                }),
          ),
        );
      },
    );
  }

  Future<void> _loadData() async {
    // Simulate loading data
    await Future.delayed(Duration(seconds: 2));
  }

  void showOverlay(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.purple),
            ),
            SizedBox(height: 10),
            Text(
              'Loading ...',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        );
      },
    );
  }

  void hideOverlay(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black,
          image: DecorationImage(
            image: AssetImage('assets/1.png'),
            fit: BoxFit.contain,
          ),
        ),
        child: Center(
          // child: //FlutterLogo(size: 150),
        ),
      ),
    );
  }
}
