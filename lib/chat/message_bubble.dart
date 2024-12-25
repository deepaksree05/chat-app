// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// class MessageBubble extends StatelessWidget {
//   final String message;
//   final bool isMee;
//   final String userId;
//
//
//   const MessageBubble(this.message, this.isMee,this.userId);
//
//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       mainAxisAlignment: isMee ? MainAxisAlignment.end : MainAxisAlignment.start,
//       children: [
//         Container(
//           decoration: BoxDecoration(
//             color: isMee ? Colors.grey.shade300 : Colors.deepPurpleAccent,
//             borderRadius: BorderRadius.only(
//               topRight: const Radius.circular(12),
//               topLeft: const Radius.circular(12),
//               bottomLeft: !isMee ? const Radius.circular(0) : const Radius.circular(12),
//               bottomRight: isMee ? const Radius.circular(0) : const Radius.circular(12),
//             ),
//           ),
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
//           margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           constraints: const BoxConstraints(maxWidth: 250), // Optional: set a max width for the message bubble
//           child: Column(
//             children: [
//               FutureBuilder<Object>(
//                 future: FirebaseFirestore.instance.collection('users'),
//                 builder: (context, snapshot) {
//                   return Text(
//                     username,style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     color: Colors.cyan
//                   ),);
//                 }
//               ),
//               Text(
//                 message,
//                 style: TextStyle(
//                   color: isMee ? Colors.black : Colors.white,
//                   fontSize: 16,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMee;
  final String userId;

  const MessageBubble(this.message, this.isMee, this.userId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMee ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMee ? Colors.grey.shade300 : Colors.deepPurpleAccent,
            borderRadius: BorderRadius.only(
              topRight: const Radius.circular(12),
              topLeft: const Radius.circular(12),
              bottomLeft: !isMee ? const Radius.circular(0) : const Radius.circular(12),
              bottomRight: isMee ? const Radius.circular(0) : const Radius.circular(12),
            ),
          ),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
          margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
          constraints: const BoxConstraints(maxWidth: 250), // Optional: set a max width for the message bubble
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FutureBuilder<DocumentSnapshot>(
                future: FirebaseFirestore.instance.collection('users').doc(userId).get(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text(
                      'Loading...',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    );
                  }
                  if (snapshot.hasError || !snapshot.hasData || !snapshot.data!.exists) {
                    return const Text(
                      'Unknown User',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.cyan,
                      ),
                    );
                  }

                  final username = snapshot.data!['username'] as String;
                  return Text(
                    username,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.cyan,
                    ),
                  );
                },
              ),
              Text(
                message,
                style: TextStyle(
                  color: isMee ? Colors.black : Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
