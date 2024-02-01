import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'model/message.dart';

class ChatService extends ChangeNotifier {
  // get instance of autth and firestore
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firerStore = FirebaseFirestore.instance;

  //SEND message
  Future<void> sendMessage(String receiverId, String message) async {
    //get current user
    final String currentUserId = _firebaseAuth.currentUser!.uid;
    final String currentUserEmail = _firebaseAuth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    //creer un message
    Message newMessage = Message(
        senderusername: currentUserId,
        senderEmail: currentUserEmail,
        receiverusername: receiverId,
        message: message,
        timestamp: timestamp);

    //construire chat room
    List<String> ids = [currentUserId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    // add the message to db
    await _firerStore.collection('chat_rooms').doc(chatRoomId).collection(
        'messages').add(newMessage.toMap());
  }

//getmessages
  Stream<QuerySnapshot> getMessages(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");
    return _firerStore.collection('chat_rooms').doc(chatRoomId).collection(
        'messages').orderBy('timestamp',descending: false ).snapshots();
  }
}
