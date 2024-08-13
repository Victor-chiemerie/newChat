import 'package:chat/services/auth/auth_service.dart';
import 'package:chat/services/chat/chat_service.dart';
import 'package:chat/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

import '../components/my_icon.dart';

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
  void sendMessage(types.PartialText message) async {
    // send message if the message is not empty
    if (message.text.isNotEmpty) {
      await _chatService.sendMessage(widget.receiverID, message.text);
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
            return const Center(child: Text("Error encountered"));
          }

          // loading...
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: Text("Loading..."));
          }

          final MyChatTheme _theme = MyChatTheme(
            attachmentButtonIcon: const Icon(Icons.attachment_rounded),
            attachmentButtonMargin: const EdgeInsets.all(3),
            backgroundColor: Colors.black,
            dateDividerMargin: const EdgeInsets.all(3),
            dateDividerTextStyle: const TextStyle(),
            deliveredIcon: const Icon(Icons.mark_chat_read_rounded),
            documentIcon: const Icon(Icons.edit_document),
            emptyChatPlaceholderTextStyle: const TextStyle(),
            errorColor: Colors.red,
            errorIcon: null,
            inputBackgroundColor: Colors.white,
            inputSurfaceTintColor: Theme.of(context).colorScheme.onPrimary,
            inputElevation: 0,
            inputBorderRadius: BorderRadius.circular(5),
            inputMargin: const EdgeInsets.all(3),
            inputPadding: const EdgeInsets.all(3),
            inputTextColor: Colors.black,
            inputTextDecoration: const InputDecoration(),
            inputTextStyle: const TextStyle(),
            messageBorderRadius: 5,
            messageInsetsHorizontal: 5,
            messageInsetsVertical: 5,
            messageMaxWidth: 100,
            primaryColor: Colors.green,
            receivedEmojiMessageTextStyle: const TextStyle(),
            receivedMessageBodyTextStyle: const TextStyle(),
            receivedMessageCaptionTextStyle: const TextStyle(),
            receivedMessageDocumentIconColor: Colors.brown,
            receivedMessageLinkDescriptionTextStyle: const TextStyle(),
            receivedMessageLinkTitleTextStyle: const TextStyle(),
            secondaryColor: Theme.of(context).colorScheme.secondary,
            seenIcon: const Icon(Icons.remove_red_eye),
            sendButtonIcon: const RoundIconButton(
              backgroundColor: Colors.green,
              iconData: Icons.arrow_upward_sharp,
            ),
            sendButtonMargin: const EdgeInsets.all(3),
            sendingIcon: const Icon(
              Icons.send_and_archive_outlined,
            ),
            sentEmojiMessageTextStyle: const TextStyle(),
            sentMessageBodyTextStyle: const TextStyle(),
            sentMessageCaptionTextStyle: const TextStyle(),
            sentMessageDocumentIconColor: Colors.brown,
            sentMessageLinkDescriptionTextStyle: const TextStyle(),
            sentMessageLinkTitleTextStyle: const TextStyle(),
            statusIconPadding: const EdgeInsets.all(3),
            systemMessageTheme: const SystemMessageTheme(
              margin: EdgeInsets.all(3),
              textStyle: TextStyle(),
            ),
            typingIndicatorTheme: TypingIndicatorTheme(
              animatedCirclesColor: Colors.brown,
              animatedCircleSize: 5,
              bubbleBorder: BorderRadius.circular(5),
              bubbleColor: Colors.brown,
              countAvatarColor: Colors.brown,
              countTextColor: Colors.brown,
              multipleUserTextStyle: const TextStyle(),
            ),
            unreadHeaderTheme: const UnreadHeaderTheme(
              color: Colors.brown,
              textStyle: TextStyle(),
            ),
            userAvatarImageBackgroundColor:
                Theme.of(context).colorScheme.background,
            userAvatarNameColors: Colors.primaries,
            userAvatarTextStyle: const TextStyle(),
            userNameTextStyle: const TextStyle(),
          );

          List<types.Message> _messages = [];

          for (var doc in snapshot.data!.docs) {
            Map<String, dynamic> data =
                doc.data() as Map<String, dynamic>; // Get message data

            final newMessage = types.Message.fromJson(data);

            _messages.add(newMessage);
          }

          // return chat list
          return Chat(
            // messages: _messages.reversed.toList(),
            messages: _messages,
            onSendPressed: (text) => sendMessage(text),
            user: _user,
            // theme: _theme,
          );
        },
      ),
    );
  }
}
