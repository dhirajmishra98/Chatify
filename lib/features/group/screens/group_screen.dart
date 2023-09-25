import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:whatsapp_clone/common/widgets/loader.dart';
import 'package:whatsapp_clone/features/chat/controllers/chat_controller.dart';
import 'package:whatsapp_clone/features/chat/screens/mobile_chat_screen.dart';

import '../../../models/group_model.dart';

class MobGroupsList extends ConsumerWidget {
  const MobGroupsList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return StreamBuilder<List<GroupModel>>(
      stream: ref.watch(chatControllerProvider).chatGroups(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Loader();
        }
        return CustomScrollView(
          slivers: [
            SliverOverlapInjector(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  var groupData = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, MobileChatScreen.routeName,
                          arguments: {
                            'name': groupData.name,
                            'uid': groupData.groupId,
                            'isGroupChat': true,
                            'recieverProfilePic': groupData.groupProfilePic,
                          });
                    },
                    child: ListTile(
                      leading: groupData.groupProfilePic != ""
                          ? CircleAvatar(
                              backgroundImage:
                                  NetworkImage(groupData.groupProfilePic),
                              radius: 30,
                            )
                          : const CircleAvatar(
                              backgroundImage:
                                  AssetImage('assets/images/bot.png'),
                              radius: 30,
                            ),
                      title: Text(
                        groupData.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      subtitle: Text(
                        groupData.lastMessage,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.grey,
                        ),
                      ),
                      trailing: Text(
                        DateFormat.Hm().format(groupData.timeSent),
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  );
                },
                childCount: snapshot.data!.length,
              ),
            ),
          ],
        );
      },
    );
  }
}
