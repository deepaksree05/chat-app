// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class NewMessages extends StatefulWidget {
//
//
//   @override
//   State<NewMessages> createState() => _NewMessagesState();
// }
//
// class _NewMessagesState extends State<NewMessages> {
//   var _enteredMessage = "";
//
//   void _sendMessage(){
//     FocusScope.of(context).unfocus();
//     FirebaseFirestore.instance.collection('chat').add({
//   'text' : _enteredMessage
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.only(top: 8),
//       padding: EdgeInsets.all(8),
//       child: Row(
//         children: [
//           Expanded(child: TextField(
//             decoration: InputDecoration(
//               labelText: 'Send A Message...'
//             ),
//             onChanged: (value){
//               setState(() {
//                 _enteredMessage = value;
//               });
//             },
//           )),
//           IconButton(onPressed: (){
//
//             _enteredMessage.trim().isEmpty ? null:_sendMessage();
//           },
//
//               icon: Icon(Icons.send))
//         ],
//       ),
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class NewMessages extends StatefulWidget {
  @override
  State<NewMessages> createState() => _NewMessagesState();
}

class _NewMessagesState extends State<NewMessages> {
  final TextEditingController _textController = TextEditingController();

  void _sendMessage() {
    final enteredMessage = _textController.text.trim();

    if (enteredMessage.isEmpty) return;

    FocusScope.of(context).unfocus();

    // Get the current user
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print('User is not authenticated.');
      return;
    }

    // Send message to Firestore
    FirebaseFirestore.instance.collection('chat').add({
      'text': enteredMessage,
      'createdAt': Timestamp.now(),
      'userId': currentUser.uid,
    });

    // Clear the input field after sending the message
    _textController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: 'Send a message...',
              ),
            ),
          ),
          IconButton(
            onPressed: _sendMessage,
            icon: const Icon(Icons.send),
          ),
        ],
      ),
    );
  }
}
