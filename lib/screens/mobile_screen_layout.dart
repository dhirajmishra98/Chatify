import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/features/contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/widgets/archived.dart';
import 'package:whatsapp_clone/widgets/contacts_list.dart';
import 'package:whatsapp_clone/widgets/sliver_widget.dart';

class MobileScreenLayout extends StatelessWidget {
  const MobileScreenLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      initialIndex: 1,
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  pinned: true,
                  centerTitle: false,
                  floating: true,
                  snap: true,
                  backgroundColor: appBarColor,
                  title: const Text(
                    'WhatsApp',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: Colors.grey,
                      fontSize: 25,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.camera_alt_outlined,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search,
                        color: Colors.grey,
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.more_vert_rounded,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                  bottom: const TabBar(
                    indicatorColor: tabColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: tabColor,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: TextStyle(fontWeight: FontWeight.bold),
                    tabs: [
                      Tab(
                        icon: Icon(Remix.team_fill),
                      ),
                      Tab(
                        text: "Chats",
                      ),
                      Tab(
                        text: 'Status',
                      ),
                      Tab(
                        text: 'Calls',
                      ),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              CustomTabView(
                widgets: const [
                  CustomSliver(childCount: 1, child: Text('Team'))
                ],
              ),
              CustomTabView(
                widgets: const [ArchivedBox(), MobContactsList()],
              ),
              CustomTabView(
                widgets: const [],
              ),
              CustomTabView(
                widgets: const [],
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, SelectContactsScreen.routeName);
          },
          backgroundColor: tabColor,
          child: const Icon(
            Icons.comment,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

// ignore: must_be_immutable
class CustomTabView extends StatelessWidget {
  CustomTabView({
    required this.widgets,
    super.key,
  });

  List<Widget> widgets;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return CustomScrollView(
        slivers: [
          SliverOverlapInjector(
              handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context)),
          if (widgets.isNotEmpty) widgets[0],
          if (widgets.length >= 2) widgets[1],
        ],
      );
    });
  }
}
