import 'package:flutter/material.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/features/chat/widgets/message_box.dart';

import '../../../constants/colors.dart';

class MessageCard extends StatelessWidget {
  final String isMe;
  final String message;
  final String date;
  final MessageEnum messageEnum;

  const MessageCard(
      {Key? key,
      required this.message,
      required this.date,
      required this.isMe,
      required this.messageEnum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe == "true" ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width - 45,
        ),
        child: Card(
          elevation: 1,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: isMe == 'true' ? messageColor : senderMessageColor,
          margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Stack(
            children: [
              Padding(
                padding: messageEnum == MessageEnum.text
                    ? const EdgeInsets.only(
                        left: 10,
                        right: 30,
                        top: 5,
                        bottom: 20,
                      )
                    : const EdgeInsets.only(
                        left: 5,
                        right: 5,
                        top: 5,
                        bottom: 25,
                      ),
                child: MessageBox(
                  message: message,
                  messageEnum: messageEnum,
                ),
              ),
              Positioned(
                bottom:isMe=='true'? 4:2,
                right: 10,
                child: Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.white60,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Icon(
                      isMe == "true" ? Icons.done_all : null,
                      size: 20,
                      color: Colors.white60,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
