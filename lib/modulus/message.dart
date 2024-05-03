import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Message extends types.Message {
  final String senderEmail;
  final String receiverID;
  final String message;

  const Message({
    required super.author, // sender ID
    super.createdAt, // Time it was sent
    required super.id,
    required super.type,
    super.updatedAt,
    required this.message, // Message
    required this.receiverID,
    required this.senderEmail,
  });

  @override
  types.Message copyWith({
    types.User? author,
    int? createdAt,
    String? id,
    Map<String, dynamic>? metadata,
    String? remoteId,
    types.Message? repliedMessage,
    String? roomId,
    bool? showStatus,
    types.Status? status,
    int? updatedAt,
  }) {
    return Message(
      author: author ?? this.author,
      id: id ?? this.id,
      receiverID: receiverID,
      senderEmail: senderEmail,
      message: message,
      type: type,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id];

  @override
  Map<String, dynamic> toJson() {
    return {
      "author": author.toJson(),
      "createdAt": createdAt,
      "id": id,
      "updatedAt": updatedAt,
      "receiverID": receiverID,
      "senderEmail": senderEmail,
      "message": message,
      "type": type,
    };
  }

  @override

  /// Creates a particular message from a map (decoded JSON).
  /// Type is determined by the `type` field.
  factory Message.fromJson(Map<String, dynamic> json) {
    final type = types.MessageType.values.firstWhere(
      (e) => e.name == json['type'],
      orElse: () => types.MessageType.unsupported,
    );

    return Message(
      author: types.User.fromJson(json['author']),
      id: json['id'],
      type: type,
      message: json['message'],
      createdAt: json['createdAt'],
      receiverID: json['receiverID'],
      senderEmail: json['senderEmail'],
    );
  }
}
