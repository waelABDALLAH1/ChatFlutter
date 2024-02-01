import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class ChatBubble extends StatefulWidget {
  final String message;

  const ChatBubble({super.key, required this.message});

  @override
  State<ChatBubble> createState() => _ChatBubbleState();
}

class _ChatBubbleState extends State<ChatBubble> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const  EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.green,
      ),
      child: Text(widget.message,style:TextStyle(fontSize: 16) ,),
    );
  }
}
