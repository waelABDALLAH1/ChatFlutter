import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Message {
  final String senderusername;
  final String senderEmail;
  final String receiverusername;
  final String message;
  final Timestamp timestamp;

  Message(
      {required this.senderusername,
      required this.senderEmail,
      required this.receiverusername,
      required this.message,
      required this.timestamp});

  Map<String, dynamic> toMap() {
    return{
      'senderUsername':senderusername,
      'senderemail':senderEmail,
      'receiverusername':receiverusername,
      'message':message,
      'timestamp':timestamp,
    };  }
}
