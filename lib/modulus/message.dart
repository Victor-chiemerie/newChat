import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class Message extends types.Message {
  const Message({
    required super.author, // sender ID
    super.createdAt, // Time it was sent
    required super.id,
    required super.type,
    super.repliedMessage, // message
    super.updatedAt,
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
      repliedMessage: repliedMessage,
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
      "repliedMessage": repliedMessage,
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
      repliedMessage: json['repliedMessage'],
      createdAt: json['createdAt'],
    );
  }

  // @override
  // String toString() {
  //   return 'Message(author: $author, createdAt: $createdAt, id: $id, type: $type, repliedMessage: $repliedMessage, updatedAt: $updatedAt,)';
  // }
}
