import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';
import 'package:whatsapp_clone/widgets/sliver_widget.dart';

class ArchivedBox extends StatelessWidget {
  const ArchivedBox({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomSliver(
      childCount: 1,
      child: InkWell(
        onTap: () {
          debugPrint("Archived tapped");
        },
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.0),
          child: ListTile(
            leading: Icon(
              Remix.inbox_archive_line,
              color: Colors.grey,
            ),
            title: Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(
                'Archived',
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
