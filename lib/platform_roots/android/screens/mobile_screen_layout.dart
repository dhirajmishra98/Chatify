// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:remixicon/remixicon.dart';
import 'package:whatsapp_clone/common/utils/utils.dart';
import 'package:whatsapp_clone/constants/colors.dart';
import 'package:whatsapp_clone/features/auth/controller/auth_controller.dart';
import 'package:whatsapp_clone/features/contacts/screens/select_contacts_screen.dart';
import 'package:whatsapp_clone/features/status/screens/confirm_status_screen.dart';
import 'package:whatsapp_clone/features/status/screens/status_contacts_screen.dart';
import 'package:whatsapp_clone/features/chat/widgets/contacts_list.dart';

class MobileScreenLayout extends ConsumerStatefulWidget {
  const MobileScreenLayout({super.key});

  @override
  ConsumerState<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends ConsumerState<MobileScreenLayout>
    with WidgetsBindingObserver, TickerProviderStateMixin {
  late TabController tabBarController;
  int currentIndex = 1;

  @override
  void initState() {
    super.initState();

    tabBarController = TabController(
      length: 4,
      vsync: this,
      initialIndex: 1,
    );
    WidgetsBinding.instance.addObserver(this);
    tabBarController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      currentIndex = tabBarController.index;
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    tabBarController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        ref.read(authControllerProvider).updateUserState(true);
        break;
      case AppLifecycleState.detached:
      case AppLifecycleState.inactive:
      case AppLifecycleState.paused:
        ref.read(authControllerProvider).updateUserState(false);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
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
                  bottom: TabBar(
                    controller: tabBarController,
                    indicatorColor: tabColor,
                    indicatorSize: TabBarIndicatorSize.tab,
                    labelColor: tabColor,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                    tabs: const [
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
            controller: tabBarController,
            children: [
              Builder(builder: (context) {
                return const Center(
                  child: Text('Implement Teams'),
                );
              }),
              Builder(builder: (context) {
                return const MobContactsList();
              }),
              Builder(builder: (context) {
                return const StatusContactsScreen();
              }),
              Builder(builder: (context) {
                return const Center(
                  child: Text("To Be Implemented"),
                );
              })
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            if (currentIndex == 1) {
              Navigator.pushNamed(context, SelectContactsScreen.routeName);
            } else if (currentIndex == 2) {
              File? pickedImage = await pickImageFromGallery(context);
              if (pickedImage != null) {
                Navigator.pushNamed(context, ConfirmStatusScreen.routeName,
                    arguments: pickedImage);
              }
            } else {
              debugPrint("To Be Implemented");
            }
          },
          backgroundColor: tabColor,
          child: Icon(
            currentIndex == 0
                ? Icons.person_sharp
                : currentIndex == 1
                    ? Icons.comment
                    : currentIndex == 2
                        ? Icons.add
                        : Icons.phone,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
