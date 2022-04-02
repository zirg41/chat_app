import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class NewMessage extends StatefulWidget {
  NewMessage({Key? key}) : super(key: key);

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  var _enteredMessage = '';
  final TextEditingController _controller = TextEditingController();
  void _sendMessage() {
    FocusScope.of(context).unfocus();
    _controller.clear();
    final user = FirebaseAuth.instance.currentUser;
    FirebaseFirestore.instance.collection('chat').add(
      {
        'text': _enteredMessage,
        'createdAt': Timestamp.now(),
      },
    );
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
              controller: _controller,
              decoration: InputDecoration(labelText: "Send a message..."),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
            icon: Icon(
              Icons.send,
              // color: Theme.of(context).primaryColor,
            ),
            color: Theme.of(context).colorScheme.primary,
          )
        ],
      ),
    );
  }
}
