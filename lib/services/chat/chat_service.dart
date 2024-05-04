import 'package:chat/modulus/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:uuid/uuid.dart';

const uuid = Uuid();

class ChatService {
  // get instance of fireStore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // get user stream
  Stream<List<Map<String, dynamic>>> getUsersStream() {
    return _firestore.collection("Users").snapshots().map((snapshot) {
      return snapshot.docs.map((doc) {
        // go through each individual user
        final user = doc.data();

        // return user
        return user;
      }).toList();
    });
  }

  // send message
  Future<void> sendMessage(String receiverID, message) async {
    // get current user info
    final String currentUserID = _auth.currentUser!.uid;
    final String currentUserEmail = _auth.currentUser!.email!;
    final user = types.User(
      id: currentUserID,
    );
    // final String messageType = types.MessageType.text.toString();

    // create a new message
    // Message newMessage = Message(
    //   author: user,
    //   id: uuid.v4(),
    //   senderEmail: currentUserEmail,
    //   receiverID: receiverID,
    //   message: message,
    //   createdAt: DateTime.now().millisecondsSinceEpoch,
    //   type: types.MessageType.text,
    // );

    // construct chat room ID for the two users (sorted to ensure uniqueness)
    List<String> ids = [currentUserID, receiverID];
    ids.sort(); // sort the ids (this ensures chat room ID is the same for any 2 people)
    String chatRoomID = ids.join('_');

    // add new message to database
    await _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .add(
      {
        "author": user.toJson(),
        "id": uuid.v4(),
        "message": message,
        "createdAt": DateTime.now().millisecondsSinceEpoch,
      },
    );
  }

  // receive message
  Stream<QuerySnapshot> getMessages(String userID, otherUserID) {
    // construct a chat room ID for the 2 users
    List<String> ids = [userID, otherUserID];
    ids.sort();
    String chatRoomID = ids.join('_');

    // return fetched chat
    return _firestore
        .collection("chat_rooms")
        .doc(chatRoomID)
        .collection("messages")
        .orderBy("createdAt", descending: false)
        .snapshots();
  }
}
