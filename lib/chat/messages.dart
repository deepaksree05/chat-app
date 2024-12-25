import 'package:chatapp/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatefulWidget {
  const Messages({super.key});

  @override
  _MessagesState createState() => _MessagesState();
}

class _MessagesState extends State<Messages> {
  // Scroll controller to manage scrolling to the bottom
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true) // Ensure messages are sorted by timestamp
          .snapshots(),
      builder: (ctx, streamSnapshot) {
        if (streamSnapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (streamSnapshot.hasError) {
          return Center(child: Text('Error: ${streamSnapshot.error}'));
        }

        final chatDocs = streamSnapshot.data?.docs;

        if (chatDocs == null || chatDocs.isEmpty) {
          return const Center(child: Text('No messages available.'));
        }

        final currentUser = FirebaseAuth.instance.currentUser;
        if (currentUser == null) {
          return const Center(child: Text('No user is currently signed in.'));
        }

        return ListView.builder(
          reverse: true, // Reverse the list to show the latest messages at the bottom
          controller: _scrollController,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            final chatData = chatDocs[index].data() as Map<String, dynamic>;

            final text = chatData['text'] as String? ?? 'No message';
            final userId = chatData['userId'] as String? ?? 'Unknown User';


            // Compare the userId with the current user's ID
            final isCurrentUser = userId == currentUser.uid;

            return MessageBubble(
              text,

              isCurrentUser,
                  userId
                  // Pass boolean indicating if the message is from the current user
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
