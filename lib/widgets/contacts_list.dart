import 'package:flutter/material.dart';
import 'package:whatsapp_clone/constants/info.dart';
import 'package:whatsapp_clone/screens/mobile_chat_screen.dart';

class MobContactsList extends StatelessWidget {
  const MobContactsList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
          childCount: info.length,
          (context, index) => Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MobileChatScreen()));
                    },
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(info[index]['profilePic']!),
                        radius: 30,
                      ),
                      title: Text(
                        info[index]['name']!,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        info[index]['message']!,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        info[index]['time']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              )),
    );
  }
}

/*
Expanded(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: info.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              InkWell(
                onTap: () {},
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(info[index]['profilePic']!),
                    radius: 30,
                  ),
                  title: Text(
                    info[index]['name']!,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Text(
                    info[index]['message']!,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  trailing: Text(
                    info[index]['time']!,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
*/
