import 'package:flutter/material.dart';

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
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: ListView.builder(
        itemCount: 69,
        padding: const EdgeInsets.only(bottom: 50),
        itemBuilder: (BuildContext context, int index) {
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
      ),
    );
  }
}
