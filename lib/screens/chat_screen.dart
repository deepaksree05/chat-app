import 'package:chatapp/chat/messages.dart';
import 'package:chatapp/chat/new_messages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Chat'),
        actions: [
          DropdownButton(icon: Icon(Icons.more_vert,color: Colors.grey,),
          items: [
            DropdownMenuItem(
              child: Container(
                child: Row(
                  children: [
                    Icon(Icons.exit_to_app),
                    SizedBox(width: 8,),
                    Text('Logout')
                  ],
                ),
              ),
              value: 'logout',
            )
              ],

              onChanged: (itemIdentifier){
            if(itemIdentifier == 'logout'){
              FirebaseAuth.instance.signOut();
            }
              }),
        ],
      ),
    body: Container(
      child: Column(
        children: [
          Expanded(child: Messages(),
          ),
          NewMessages(),
        ],
      ),
    ),
    );
  }
}

//
//
//
// import 'package:flutter/material.dart';
// // import 'package:cloud_firestore/cloud_firestore.dart';
// //
// // class ChatScreen extends StatelessWidget {
// //   const ChatScreen({super.key});
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Chat Screen'),
// //       ),
// //       body: Center(child: const Text('Chat messages will appear here.')),
// //       floatingActionButton: FloatingActionButton(
// //         onPressed: () {
// //           FirebaseFirestore.instance
// //               .collection('chats/1SKDGPxkCaRo7mRUTypM/messages')
// //               .snapshots()
// //               .listen((data) {
// //             if (data.docs.isNotEmpty) {
// //               print(data.docs[0]['text']); // Corrected to use 'docs' instead of 'documents'
// //             } else {
// //               print('No messages found.');
// //             }
// //           });
// //         },
// //         child: const Icon(Icons.add),
// //       ),
// //     );
// //   }
// // }



//body: StreamBuilder(
//         stream: FirebaseFirestore.instance
//             .collection('chats/1SKDGPxkCaRo7mRUTypM/messages')
//             .snapshots(),
//         builder: (ctx, streamsnapshots) {
//           if (streamsnapshots.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           }
//           final documents = streamsnapshots.data?.docs;
//           return ListView.builder(
//             itemCount: documents?.length,
//             itemBuilder: (ctx, index) => Container(
//               padding: const EdgeInsets.all(8),
//               child: Text(documents?[index]['text']),
//             ),
//           );
//         },
//       ),