import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';

class AuthForm extends StatefulWidget {
  const AuthForm({super.key});

  @override
  State<AuthForm> createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formkey = GlobalKey<FormState>();
  var _email = '';
  var _password = '';
  var _username = '';
  bool isLoginPage = false;



  void startAuthentication() async {

    final formState = _formkey.currentState;
    if (formState != null) {
      final validity = formState.validate();
      FocusScope.of(context).unfocus();
      if (validity) {
        formState.save(); // Use formState consistently
        submitForm(_email, _password, _username);
      }
    }
  }

  Future<void> submitForm(String email, String password, String username) async {
    final auth = FirebaseAuth.instance;

    UserCredential? authResult; // Use UserCredential? to handle potential null
    try {
      if (isLoginPage) {
        authResult = await auth.signInWithEmailAndPassword(email: email, password: password);
      } else {
        authResult = await auth.createUserWithEmailAndPassword(email: email, password: password);
        String uid = authResult.user?.uid ?? ''; // Use null-aware operator
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'username': username,
          'email': email,
        });
      }
    } catch (err) {
      print(err);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      child: ListView(
        children: [
          Container(height: 100,
            margin: EdgeInsets.only(top:40),
            child: Icon(Icons.message,size: 100,),),
          SizedBox(height: 10,),
          Center(
            child: Container(
              child: isLoginPage? Text("Welcome Back to our chat App ! ",style: TextStyle(fontSize: 18)): Text("Let's create an Account for You ! ",style: TextStyle(fontSize: 18)),
            ),
          ),
          SizedBox(height: 30,),          Container(
              padding: EdgeInsets.only(left: 10, right: 10, top: 10),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!isLoginPage)
                      TextFormField(
                        keyboardType: TextInputType.emailAddress,
                        key: ValueKey('username'),
                        validator: (value) {
                          if (value?.isEmpty ?? true) {
                            return 'Incorrect username';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _username = value ?? '';
                        },
                        decoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide: new BorderSide(),
                                borderRadius: new BorderRadius.circular(8.0)),
                            labelText: "Enter username ",
                            labelStyle: GoogleFonts.roboto()),
                      ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      key: ValueKey('email'),
                      validator: (value) {
                        if (value?.isEmpty ??
                            true || !(value?.contains('@') ?? false)) {
                          return 'Incorrect Email';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _email = value ?? '';
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(),
                              borderRadius: new BorderRadius.circular(8.0)),
                          labelText: "Enter Email ",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      obscureText: true ,
                      keyboardType: TextInputType.visiblePassword,
                      key: ValueKey('password'),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'Incorrect password';
                        }
                        return null;
                      },
                      onSaved: (value) {
                        _password = value ?? '';
                      },
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderSide: new BorderSide(),
                              borderRadius: new BorderRadius.circular(8.0)),
                          labelText: "Enter Password ",
                          labelStyle: GoogleFonts.roboto()),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        padding: EdgeInsets.all(5),
                        height: 70,
                        width: double.infinity,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Theme.of(context).primaryColor),
                            onPressed: () {
                              startAuthentication();
                            },
                            child: isLoginPage
                                ? Text(
                              "Login",
                              style: GoogleFonts.roboto(fontSize: 16),
                            )
                                : Text("SignUp",
                                style: GoogleFonts.roboto(fontSize: 16)))),
                    SizedBox(
                      height: 10,
                    ),
                    Container(child: TextButton(onPressed: (){
                      setState(() {
                        isLoginPage = !isLoginPage;
                      });
                    }, child: isLoginPage? Text("Not a member  ? Register Now ",style: TextStyle(color: Colors.blue)): Text("Already a member ? Login Now ",style: TextStyle(color: Colors.blue))),)
                  ],
                ),
              ))
        ],
      ),
    );
  }
}
