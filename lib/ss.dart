import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

import 'chat/message_bubble.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
    Timer.periodic(Duration(seconds: 5), (timer) {
      setState(() {});
    });
  }

  Future<List<Map<String, dynamic>>> fetchMessages() async {
    final url = Uri.parse(
      'https://firestore.googleapis.com/v1/projects/flutter-chat-36630/databases/(default)/documents/?orderBy=createdAt desc',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final documents = data['documents'] ?? [];
      return documents.map<Map<String, dynamic>>((doc) {
        final fields = doc['fields'] ?? {};
        return {
          'text': fields['text']['stringValue'],
          'userId': fields['userId']['stringValue'],
        };
      }).toList();
    } else {
      throw Exception('Failed to load messages');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return const Center(child: Text('No user is currently signed in.'));
    }

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: fetchMessages(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }

        final chatDocs = snapshot.data;

        if (chatDocs == null || chatDocs.isEmpty) {
          return const Center(child: Text('No messages available.'));
        }

        return ListView.builder(
          reverse: true,
          itemCount: chatDocs.length,
          itemBuilder: (ctx, index) {
            final chatData = chatDocs[index];
            final text = chatData['text'] ?? 'No message';
            final userId = chatData['userId'] ?? 'Unknown User';
            final isCurrentUser = userId == currentUser.uid;

            return MessageBubble(
              text,
              isCurrentUser,
              userId,
            );
          },
        );
      },
    );
  }
}
