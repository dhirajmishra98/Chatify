import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/widgets.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/features/chat/widgets/video_player.dart';

class MessageBox extends StatelessWidget {
  final String message;
  final MessageEnum messageEnum;
  const MessageBox(
      {super.key, required this.message, required this.messageEnum});

  @override
  Widget build(BuildContext context) {
    switch (messageEnum) {
      case MessageEnum.text:
        return Text(
          message,
          style: const TextStyle(
            fontSize: 16,
          ),
        );

      case MessageEnum.video:
        return VideoPlayer(
          videoUrl: message,
        );

      case MessageEnum.image:
        return CachedNetworkImage(
          imageUrl: message,
        );

      case MessageEnum.gif:
        return CachedNetworkImage(
          imageUrl: message,
        );

      default:
        return Container();
    }
  }
}
