// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/models/user_model.dart';
import 'package:whatsapp_clone/screens/mobile_chat_screen.dart';

final selectContactsRepositoryProvider = Provider(
  (ref) => SelectContactsRepository(
    firebaseFirestore: FirebaseFirestore.instance,
  ),
);

class SelectContactsRepository {
  FirebaseFirestore firebaseFirestore;

  SelectContactsRepository({required this.firebaseFirestore});

  Future<List<Contact>> getContactsList() async {
    List<Contact> contacts = [];
    try {
      if (await FlutterContacts.requestPermission()) {
        contacts = await FlutterContacts.getContacts(
          withProperties: true,
          withPhoto: true,
        );
      }
    } catch (e) {
      debugPrint(e.toString());
    }

    return contacts;
  }

  void selectContact(Contact selectedContact, BuildContext context) async {
    try {
      final userCollection = await firebaseFirestore.collection('users').get();
      bool isFound = false;

      for (var documents in userCollection.docs) {
        final user = UserModel.fromMap(documents.data());
        String selectedPhoneNum =
            selectedContact.phones[0].number.replaceAll(' ', '');

        debugPrint(selectedPhoneNum);

        if (selectedPhoneNum == user.phoneNumber) {
          isFound = true;
          Navigator.pushNamed(context, MobileChatScreen.routeName, arguments: {
            'name': user.name,
            'uid': user.uid,
          });
        }
      }

      if (!isFound) {
        showSnackBar(
            context: context, content: "User doesn't use this app, Invite ?");
      }
    } catch (error) {
      showSnackBar(context: context, content: error.toString());
    }
  }
}
