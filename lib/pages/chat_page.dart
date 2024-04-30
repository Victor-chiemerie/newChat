import 'package:chat/modulus/message.dart';
import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatPage extends StatefulWidget {
  final String receiverEmail;
  final String receiverID;
  const ChatPage({
    super.key,
    required this.receiverEmail,
    required this.receiverID,
  });

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final String _senderID;
  late types.User _user;

  // get sender ID
  @override
  void initState() {
    super.initState();
    _senderID = _authService.getCurrentUser()!.uid;
    _user = types.User(id: _senderID);
  }

  // chat and auth services
  final ChatService _chatService = ChatService();
  final AuthService _authService = AuthService();

  // send message
  void sendMessage(String text) async {
    // send message if the message is not empty
    if (text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, text);
    }
  }

  // send message
  Stream getMessage() {
    // retrieve message
    return _chatService.getMessages(widget.receiverID, _senderID);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.receiverEmail),
      ),
      body: StreamBuilder(
        stream: getMessage(),
        builder: (context, snapshot) {
          // error
          if (snapshot.hasError) {
            return const Text("Error encountered");
          }

          // loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading...");
          }

          // return chat list
          return Chat(
            messages: snapshot.data!,
            onSendPressed: (text) => sendMessage(text as String),
            user: _user,
          );
        },
      ),
    );
  }
}
