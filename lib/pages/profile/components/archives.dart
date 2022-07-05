import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';

class Archives extends StatefulWidget {
  const Archives({Key? key}) : super(key: key);

  @override
  State<Archives> createState() => _ArchivesState();
}

// profileId not needed since this page is only for current user meaning we can use userProvider.
class _ArchivesState extends State<Archives> {
  @override
  void initState() {
    super.initState();
    debugPrint('built archives');
  }

  @override
  void dispose() {
    debugPrint('disposed archives');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey<String>("archives"),
          slivers: [
            SliverPadding(
              padding: EdgeInsets.only(bottom: navBarHeight(context)),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return Container(
                      height: 50,
                      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 11),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: index % 2 == 0 ? Colors.blue.shade100 : Colors.pink.shade100,
                        borderRadius: BorderRadius.circular(11),
                      ),
                      child: Text(index.toString()),
                    );
                  },
                  childCount: 69,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
