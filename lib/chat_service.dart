import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of autth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;

  //SEND message
  Future<void> sendMessage(String receiverEmail, String message) async {
    //get current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //creer un message
    Message newMessage = Message(
        senderusername: currentUserId,
        senderEmail: currentUserEmail,
        receiverEmail: receiverEmail,
        message: message,
        timestamp: timestamp);

    //construire chat room
    List<String> ids = [currentUserEmail, receiverEmail];
    ids.sort();
    String chatRoomId = ids.join("_");
    // add the message to db
    await _fireStore.collection('chat_rooms').doc(chatRoomId).collection(
        'messages').add(newMessage.toMap());
  }

  // Obtenir la liste des chat rooms de l'utilisateur actuel
  Stream<QuerySnapshot> getChatRooms(String userEmail) {
    return _fireStore.collection('chat_rooms').doc().collection(
        'messages').snapshots();
  }

//getmessages
  Stream<QuerySnapshot> getMessages(String userEmail, String otherUserEmail) {
    List<String> ids = [userEmail, otherUserEmail];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _fireStore.collection('chat_rooms').doc(chatRoomId).collection(
        'messages').orderBy('timestamp',descending: false ).snapshots();
  }
}
