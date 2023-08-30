// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:whatsapp_clone/common/enums/message_enums.dart';

class MessageModel {
  final String senderId;
  final String recieverId;
  final String text;
  final DateTime timeSent;
  final bool isSeen;
  final MessageEnum type;
  final String messageId;
  MessageModel({
    required this.senderId,
    required this.recieverId,
    required this.text,
    required this.timeSent,
    required this.isSeen,
    required this.type,
    required this.messageId,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'senderId': senderId,
      'recieverId': recieverId,
      'text': text,
      'timeSent': timeSent.millisecondsSinceEpoch,
      'isSeen': isSeen,
      'type': type.type,
      'messageId': messageId,
    };
  }

  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      senderId: map['senderId'] as String,
      recieverId: map['recieverId'] as String,
      text: map['text'] as String,
      timeSent: DateTime.fromMillisecondsSinceEpoch(map['timeSent'] as int),
      isSeen: map['isSeen'],
      type: (map['type'] as String).toEnum(),
      messageId: map['messageId'] as String,
    );
  }

}
