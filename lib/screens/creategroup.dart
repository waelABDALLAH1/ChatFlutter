import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatPage.dart';
import 'creategroup.dart';

class createGroup extends StatefulWidget {
  const createGroup({super.key});

  @override
  State<createGroup> createState() => _createGroupState();
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

class _createGroupState extends State<createGroup> {
  final FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    String email = _auth.currentUser?.email ?? ''; // Get the user's email

// Split the email using '@' as the delimiter
    List<String> parts = email.split('@');

// Check if the split produced two parts (before '@' and after '@')
    String displayText = parts.length == 2 ? parts[0] : 'Unknown';
    return Scaffold(

      appBar: AppBar(
        title: Center(child: Text('Create Group')),

        backgroundColor: Colors.green,
      ),
      body: _buildUserList(),
    );
  }

  //afficher tous les utilisateurs sauf celui qui est connecte
  Widget _buildUserList() {
    return StreamBuilder <QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('error');
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text('loading ....');
          }
          return Padding(
            padding: const EdgeInsets.all(8.0),

            child: ListView(
              children: snapshot.data!.docs.map<Widget>((doc) =>
                  _buildUserListItem(doc)).toList(),
            ),

          );
        }

    );
  }

//build indiv user for list items
  Widget _buildUserListItem(DocumentSnapshot document) {
    Map<String, dynamic> data = document.data()! as Map<String, dynamic>;

    //display all users except current one
    if (_auth.currentUser!.email != data['email']) {
      return Padding(
        padding: const EdgeInsets.all(4.0),
        child: ListTile(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
                10.0), // Set the border radius here
          ),
          selectedTileColor: Colors.white,
          title: Text(data['username'],
            style: TextStyle(color: Colors.black, fontSize: 20),),
          subtitle: Text(data['email'],
              style: TextStyle(color: Colors.black, fontSize: 18)),
          tileColor: Colors.white60,
          onTap: () {
            //chat page of the clicked user
            Navigator.push(context, MaterialPageRoute(builder: (context) =>
                ChatPage(
                  receiverUserEmail: data['email'] ?? data['email'] ??
                      'emailInconnu',
                  receiverUserID: data['username'] ?? data['uid'] ??
                      'UtilisateurInconnu',

                ),));
          },
        ),
      );
    }
    else {
      return Container();
    }
  }

}

