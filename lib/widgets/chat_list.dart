import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/info.dart';
import 'package:whatsapp_clone/widgets/message_card.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: messages.length,
      itemBuilder: (context, index) {
        return MessageCard(
            message: messages[index]["text"].toString(),
            date: messages[index]["time"].toString(),
            isMe: messages[index]["isMe"].toString());
      },
    );
  }
}
