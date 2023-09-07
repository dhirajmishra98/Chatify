// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';

import 'package:whatsapp_clone/features/chat/repository/chat_repository.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/message_model.dart';

import '../../../common/enums/message_enums.dart';

final chatControllerProvider = Provider((ref) {
  final chatRepository = ref.watch(chatRepositoryProvider);
  return ChatController(chatRepository: chatRepository, ref: ref);
});

class ChatController {
  final ChatRepository chatRepository;
  final ProviderRef ref;
  ChatController({
    required this.chatRepository,
    required this.ref,
  });

  Stream<List<ChatContact>> chatContacts() {
    return chatRepository.getContactsList();
  }

  Stream<List<MessageModel>> chatMessages(String recieverUserId) {
    return chatRepository.getChatStream(recieverUserId);
  }

  void sendTextMessage(
      BuildContext context, String text, String recieverUserId) {
    final messageReply = ref.read(messageReplyProvider);
    ref.read(userDataAuthProvider).whenData(
          (value) => chatRepository.sendTextMessage(
            context: context,
            text: text,
            recieverUserId: recieverUserId,
            senderUser: value!,
            messageReply: messageReply,
          ),
        );

    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendFileMessage({
    required BuildContext context,
    required File file,
    required String recieverUserId,
    required MessageEnum messageEnum,
  }) {
    final messageReply = ref.read(messageReplyProvider);
    ref
        .read(userDataAuthProvider)
        .whenData((value) => chatRepository.sendFileMessage(
              context: context,
              senderUser: value!,
              recieverUserId: recieverUserId,
              file: file,
              messageEnum: messageEnum,
              ref: ref,
              messageReply: messageReply,
            ));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }

  void sendGif({
    required BuildContext context,
    required String gif,
    required String recieverUserId,
  }) {
    int gifUrlUniqueIndex = gif.lastIndexOf('-') + 1;
    String uniqueGifUrl = gif.substring(gifUrlUniqueIndex);
    String gifUrl = 'https://i.giphy.com/media/$uniqueGifUrl/200.gif';

    final messageReply = ref.read(messageReplyProvider);

    ref.read(userDataAuthProvider).whenData((value) => chatRepository.sendGif(
          context: context,
          gif: gifUrl,
          recieverUserId: recieverUserId,
          senderUser: value!,
          messageReply: messageReply,
        ));
    ref.read(messageReplyProvider.notifier).update((state) => null);
  }
}
