import 'package:flutter/material.dart';
class createGroup extends StatefulWidget {
  const createGroup({super.key});

  @override
  State<createGroup> createState() => _createGroupState();
}

class _createGroupState extends State<createGroup> {
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Text('Create group') ,
        backgroundColor: Colors.green,
      ),
    );
  }
}
