import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'ChatPage.dart';
import 'creategroup.dart';
import 'package:todo/chat_service.dart';


class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}
final ChatService _chatService = ChatService();
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
    String userEmail = _auth.currentUser?.email ?? '';

// Split the email using '@' as the delimiter
    List<String> parts = userEmail.split('@');

// Check if the split produced two parts (before '@' and after '@')
    String displayText = parts.length == 2 ? parts[0] : 'Unknown';
    return Scaffold(

      appBar: AppBar(
        title: Center(child: Text('Welcome $displayText')),


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
      body: _buildChatList(userEmail),
    floatingActionButton:
    FloatingActionButton(
      onPressed: () {
        // Perform an action when FAB is pressed
        // For example, you can navigate to a new screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => createGroup()),
        );
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.green,
      shape: const CircleBorder(),
    )
    ,
    );
  }

  //afficher tous les utilisateurs sauf celui qui est connecte
  Widget _buildChatList(String userEmail) {
    return StreamBuilder<QuerySnapshot>(
      stream: _chatService.getChatRooms(userEmail),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        // Obtenez la liste des documents (chat rooms) depuis le snapshot
        List<DocumentSnapshot> chatRooms = snapshot.data!.docs;

        if (chatRooms.isEmpty) {
          // Affichez un message lorsque la liste est vide
          return Center(
            child: Text("Veuillez Commencer une discussion"),
          );
        }

        return ListView.builder(
          itemCount: chatRooms.length,
          itemBuilder: (context, index) {
            Map<String, dynamic> data = chatRooms[index].data() as Map<String, dynamic>;

            return ListTile(
              title: Text(data['name'] ?? 'Unnamed Chat'),
              subtitle: Text(data['lastMessage'] ?? 'No messages yet'),
              onTap: () {
                // Naviguez vers la page de discussion (ChatPage) en passant les données nécessaires
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatPage(
                      receiverUserEmail: data['receiverEmail'],
                      receiverUserID: data['receiverUserID'],
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }


}
