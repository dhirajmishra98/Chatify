import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/features/chat/controllers/chat_controller.dart';

import '../../../constants/colors.dart';

class BottomChatField extends ConsumerStatefulWidget {
  final String recieverUserId;
  const BottomChatField({
    required this.recieverUserId,
    super.key,
  });

  @override
  ConsumerState<BottomChatField> createState() => _BottomChatFieldState();
}

class _BottomChatFieldState extends ConsumerState<BottomChatField> {
  bool showSendIcon = false;
  final TextEditingController _messageController = TextEditingController();

  void sendTextMessage() {
    if (showSendIcon & _messageController.text.isNotEmpty) {
      ref.read(chatControllerProvider).sendTextMessage(
          context, _messageController.text.trim(), widget.recieverUserId);

      setState(() {
        _messageController.text = "";
      });
    }
  }

  void sendFile({
    required File file,
    required MessageEnum messageEnum,
  }) {
    ref.read(chatControllerProvider).sendFileMessage(
        context: context,
        file: file,
        recieverUserId: widget.recieverUserId,
        messageEnum: messageEnum);
  }

  void selectImageFile() async {
    File? image = await pickImageFromGallery(context);
    if (image != null) {
      sendFile(file: image, messageEnum: MessageEnum.image);
    }
  }

  void selectVideoFile() async {
    File? video = await pickVideoFromGallery(context);
    if (video != null) {
      sendFile(file: video, messageEnum: MessageEnum.video);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 3.0, bottom: 3.0),
            child: TextFormField(
              controller: _messageController,
              expands: true,
              maxLines: null,
              onChanged: (val) {
                if (val.isNotEmpty) {
                  setState(() {
                    showSendIcon = true;
                  });
                } else {
                  setState(() {
                    showSendIcon = false;
                  });
                }
              },
              decoration: InputDecoration(
                filled: true,
                fillColor: mobileChatBoxColor,
                prefixIcon: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.emoji_emotions,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.gif,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                suffixIcon: SizedBox(
                  width: 100,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: selectImageFile,
                        icon: const Icon(
                          Icons.camera_alt,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: selectVideoFile,
                        icon: const Icon(
                          Icons.attach_file,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                hintText: 'Message',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.all(5),
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 5,
        ),
        FloatingActionButton(
          backgroundColor: tabColor,
          onPressed: sendTextMessage,
          shape: const CircleBorder(),
          child:
              Icon(_messageController.text.isNotEmpty ? Icons.send : Icons.mic),
        )
      ],
    );
  }
}
