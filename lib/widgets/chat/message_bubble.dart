import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble(this.message, this.userId, this.isMe, {this.key});
  final String message;
  final String userId;
  final bool isMe;
  final Key? key;

  @override
  Widget build(BuildContext context) {
    const _borderRadius = Radius.circular(12);
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Theme.of(context).colorScheme.secondary
                : Colors.grey[800],
            borderRadius: BorderRadius.only(
              topLeft: _borderRadius,
              topRight: _borderRadius,
              bottomRight: isMe ? Radius.zero : _borderRadius,
              bottomLeft: !isMe ? Radius.zero : _borderRadius,
            ),
          ),
          width: 140,
          padding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 16,
          ),
          margin: const EdgeInsets.symmetric(
            vertical: 4,
            horizontal: 8,
          ),
          child: Column(
            children: [
              FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .doc(userId)
                    .get(),
                builder: (ctx,
                    AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>>
                        snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Loading...');
                  }
                  return Text(
                    snapshot.data!.get('username'),
                    style: TextStyle(
                        color: Theme.of(context).textTheme.headline1!.color),
                  );
                },
              ),
              Text(
                message,
                style: TextStyle(
                    color: Theme.of(context).textTheme.headline1!.color),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
