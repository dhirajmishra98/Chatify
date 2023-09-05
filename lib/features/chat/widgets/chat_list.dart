import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/widgets/message_card.dart';

class ChatList extends ConsumerStatefulWidget {
  final String recieverUserId;
  const ChatList(this.recieverUserId, {super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ChatListState();
}

class _ChatListState extends ConsumerState<ChatList> {
  final ScrollController _messageController = ScrollController();

  @override
  void dispose() {
    super.dispose();
    _messageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<MessageModel>>(
      stream:
          ref.read(chatControllerProvider).chatMessages(widget.recieverUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }

        SchedulerBinding.instance.addPostFrameCallback((_) {
          _messageController
              .jumpTo(_messageController.position.maxScrollExtent);
        });

        return ListView.builder(
          controller: _messageController,
          itemCount: snapshot.data!.length,
          itemBuilder: (context, index) {
            final messages = snapshot.data![index];
            return MessageCard(
                message: messages.text,
                date: DateFormat.Hm().format(messages.timeSent),
                isMe:
                    messages.senderId == FirebaseAuth.instance.currentUser!.uid
                        ? "true"
                        : "false");
          },
        );
      },
    );
  }
}
