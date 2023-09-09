// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import 'package:whatsapp_clone/common/enums/message_enums.dart';
import 'package:whatsapp_clone/common/providers/message_reply_provider.dart';
import 'package:whatsapp_clone/common/repositories/common_firebase_storage_repository.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/chat_model.dart';
import 'package:whatsapp_clone/models/message_model.dart';
import 'package:whatsapp_clone/models/user_model.dart';

final chatRepositoryProvider = Provider(
  (ref) => ChatRepository(
      firebaseFirestore: FirebaseFirestore.instance,
      firebaseAuth: FirebaseAuth.instance),
);

class ChatRepository {
  final FirebaseFirestore firebaseFirestore;
  final FirebaseAuth firebaseAuth;
  ChatRepository({
    required this.firebaseFirestore,
    required this.firebaseAuth,
  });

  Stream<List<ChatContact>> getContactsList() {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .snapshots()
        .asyncMap((event) async {
      List<ChatContact> contacts = [];
      for (var document in event.docs) {
        var chatContact = ChatContact.fromMap(document.data());
        var userData = await firebaseFirestore
            .collection('users')
            .doc(chatContact.contactId)
            .get();

        var user = UserModel.fromMap(userData.data()!);
        contacts.add(ChatContact(
            user.name,
            user.profilePic,
            chatContact.contactId,
            chatContact.timeSent,
            chatContact.lastMessage));
      }

      return contacts;
    });
  }

  Stream<List<MessageModel>> getChatStream(String recieverUserId) {
    return firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .orderBy('timeSent')
        .snapshots()
        .map((event) {
      List<MessageModel> messages = [];
      for (var document in event.docs) {
        messages.add(MessageModel.fromMap(document.data()));
      }

      return messages;
    });
  }

  void _saveDataToContactSubcollection(
      {required UserModel senderUserData,
      required UserModel recieverUserData,
      required String textSent,
      required DateTime timeSent,
      required String recieverUserId}) async {
    //users->reciever user id => chat ->current user id->set data
    var recieverChatContact = ChatContact(
      senderUserData.name,
      senderUserData.profilePic,
      senderUserData.uid,
      timeSent,
      textSent,
    );

    await firebaseFirestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .set(recieverChatContact.toMap());

    //user->user id=> chat -> reciver user id-> set data
    var senderChatContact = ChatContact(
      recieverUserData.name,
      recieverUserData.profilePic,
      recieverUserData.uid,
      timeSent,
      textSent,
    );

    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .set(senderChatContact.toMap());
  }

  void _saveMessageToMessageSubcollection({
    required String recieverUserId,
    required String text,
    required DateTime timeSent,
    required String messageId,
    required String userName,
    required String recieverUserName,
    required MessageEnum messageType,
    required MessageReply? messageReply,
    required String senderUserName,
  }) async {
    final message = MessageModel(
        senderId: firebaseAuth.currentUser!.uid,
        recieverId: recieverUserId,
        text: text,
        timeSent: timeSent,
        isSeen: false,
        type: messageType,
        messageId: messageId,
        repliedMessage: messageReply == null ? "" : messageReply.message,
        repliedMessageType:
            messageReply == null ? MessageEnum.text : messageReply.messageEnum,
        repliedTo: messageReply == null
            ? ""
            : messageReply.isMe
                ? senderUserName
                : recieverUserName);

    // users-> sender id-> reciver id->messages->message id->store message
    await firebaseFirestore
        .collection('users')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('chats')
        .doc(recieverUserId)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());

    //users-> reciver id-> sender id-> messages-> message id-> store message
    await firebaseFirestore
        .collection('users')
        .doc(recieverUserId)
        .collection('chats')
        .doc(firebaseAuth.currentUser!.uid)
        .collection('messages')
        .doc(messageId)
        .set(message.toMap());
  }

  void sendTextMessage({
    required BuildContext context,
    required String text,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();

      var userDataMap =
          await firebaseFirestore.collection('users').doc(recieverUserId).get();

      UserModel recieverUser = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
          senderUserData: senderUser,
          recieverUserData: recieverUser,
          textSent: text,
          timeSent: timeSent,
          recieverUserId: recieverUserId);

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: text,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        recieverUserName: recieverUser.name,
        messageType: MessageEnum.text,
        messageReply: messageReply,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendFileMessage({
    required BuildContext context,
    required UserModel senderUser,
    required String recieverUserId,
    required File file,
    required MessageEnum messageEnum,
    required ProviderRef ref,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();
      var messageId = const Uuid().v1();

      String fileUrl = await ref
          .read(commonFirebaseStorageRepositoryProvider)
          .storeFileToFirebase(
              ref:
                  "chat/${messageEnum.type}/${senderUser.uid}/$recieverUserId/$messageId",
              file: file);

      var recieverUserDataMap =
          await firebaseFirestore.collection('users').doc(recieverUserId).get();
      UserModel recieverUser = UserModel.fromMap(recieverUserDataMap.data()!);

      String displayMsg;
      switch (messageEnum) {
        case MessageEnum.image:
          displayMsg = '📷 photo';
          break;
        case MessageEnum.audio:
          displayMsg = '🎵 audio';
          break;
        case MessageEnum.video:
          displayMsg = '📽 video';
          break;
        case MessageEnum.gif:
          displayMsg = 'GIF';
          break;
        default:
          displayMsg = 'Error';
      }

      _saveDataToContactSubcollection(
          senderUserData: senderUser,
          recieverUserData: recieverUser,
          textSent: displayMsg,
          timeSent: timeSent,
          recieverUserId: recieverUserId);

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: fileUrl,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        recieverUserName: recieverUser.name,
        messageType: messageEnum,
        messageReply: messageReply,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void sendGif({
    required BuildContext context,
    required String gif,
    required String recieverUserId,
    required UserModel senderUser,
    required MessageReply? messageReply,
  }) async {
    try {
      var timeSent = DateTime.now();

      var userDataMap =
          await firebaseFirestore.collection('users').doc(recieverUserId).get();

      UserModel recieverUser = UserModel.fromMap(userDataMap.data()!);

      var messageId = const Uuid().v1();

      _saveDataToContactSubcollection(
          senderUserData: senderUser,
          recieverUserData: recieverUser,
          textSent: "🆒 Gif",
          timeSent: timeSent,
          recieverUserId: recieverUserId);

      _saveMessageToMessageSubcollection(
        recieverUserId: recieverUserId,
        text: gif,
        timeSent: timeSent,
        messageId: messageId,
        userName: senderUser.name,
        recieverUserName: recieverUser.name,
        messageType: MessageEnum.gif,
        messageReply: messageReply,
        senderUserName: senderUser.name,
      );
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }

  void setChatMessageSeen({
    required BuildContext context,
    required String recieverId,
    required String messageId,
  }) async {
    try {
      await firebaseFirestore
          .collection('users')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('chats')
          .doc(recieverId)
          .collection('messages')
          .doc(messageId)
          .set({'isSeen': true});

      await firebaseFirestore
          .collection('users')
          .doc(recieverId)
          .collection('chats')
          .doc(firebaseAuth.currentUser!.uid)
          .collection('messages')
          .doc(messageId)
          .set({'isSeen': true});
    } catch (e) {
      showSnackBar(context: context, content: e.toString());
    }
  }
}
