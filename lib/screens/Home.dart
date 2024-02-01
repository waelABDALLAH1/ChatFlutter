import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'ChatPage.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final FirebaseAuth _auth = FirebaseAuth.instance;

void sign_out() async {
  try {
    await _auth.signOut();
    print('User signed out');
  } catch (e) {
    print('Error signing out: $e');
  }
}

class _HomeState extends State<Home> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Chat')),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  await _auth.signOut();
                  print('User signed out');
                } catch (e) {
                  print('Error signing out: $e');
                }
              },
              icon: Icon(Icons.logout))
        ],
        backgroundColor: Colors.green,
      ),
      body: _buildUserList(),
    );
  }

  //afficher tous les utilisateurs sauf celui qui est connecte
  Widget _buildUserList() {
    return StreamBuilder <QuerySnapshot> (
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
    builder: (context,snapshot){
    if (snapshot.hasError){
    return const Text('error');
    }
    if (snapshot.connectionState == ConnectionState.waiting){
    return const Text('loading ....');
    }
    return ListView(
      children: snapshot.data!.docs.map<Widget>((doc) => _buildUserListItem(doc)).toList(),
    );
  }

  );
}

//build indiv user for list items
Widget _buildUserListItem(DocumentSnapshot document){
    Map<String,dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current one
  if(_auth.currentUser!.email !=data['email']){
    return ListTile(
      title: Text(data['email']),
      onTap: (){
        //chat page of the clicked user
        Navigator.push(context,MaterialPageRoute(builder: (context) => ChatPage(
          receiverUserEmail:data['email'] ?? data['email'] ?? 'emailInconnu',
          receiverUserID: data['username'] ?? data['uid'] ?? 'UtilisateurInconnu',

        ),));
      },
    );
  }
  else{
    return Container();
  }}

}

