import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/constants/info.dart';
import 'package:whatsapp_clone/widgets/chat_list.dart';

class MobileChatScreen extends StatelessWidget {
  const MobileChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBarColor,
        title: Text(
          info[0]['name'].toString(),
        ),
        titleSpacing: 0,
        centerTitle: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Remix.video_add_fill),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Remix.phone_fill),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Remix.more_2_fill),
          ),
        ],
      ),
      body: const Column(
        children: [
          Expanded(
            child: ChatList(),
          ),
          TypeBox(),
        ],
      ),
    );
  }
}

class TypeBox extends StatelessWidget {
  const TypeBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.07,
      padding: const EdgeInsets.all(3),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(color: dividerColor),
        ),
        color: backgroundColor,
      ),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              keyboardType: TextInputType.multiline,
              expands: true,
              maxLines: null,
              decoration: InputDecoration(
                prefixIcon: IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.emoji_emotions_outlined,
                    color: Colors.grey,
                  ),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Remix.attachment_2,
                          color: Colors.grey,
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Remix.camera_fill,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                filled: true,
                fillColor: searchBarColor,
                hintText: 'Message',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                  borderSide: const BorderSide(
                    width: 0,
                    style: BorderStyle.none,
                  ),
                ),
                contentPadding: const EdgeInsets.only(left: 20),
              ),
            ),
          ),
          const SizedBox(
            width: 5,
          ),
          FloatingActionButton(
            backgroundColor: tabColor,
            onPressed: () {},
            shape: const CircleBorder(),
            child: const Icon(Icons.mic),
          )
        ],
      ),
    );
  }
}
