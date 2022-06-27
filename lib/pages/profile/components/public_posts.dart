import 'package:flutter/material.dart';

class PublicPosts extends StatefulWidget {
  final String profileId;

  const PublicPosts({Key? key, required this.profileId}) : super(key: key);

  @override
  State<PublicPosts> createState() => _PublicPostsState();
}

class _PublicPostsState extends State<PublicPosts> {
  @override
  void initState() {
    super.initState();
    debugPrint('built public posts');
  }

  @override
  void dispose() {
    debugPrint('disposed public posts');
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
              color: index % 2 == 0 ? Colors.orange.shade200 : Colors.purple.shade100,
              borderRadius: BorderRadius.circular(11),
            ),
            child: Text(index.toString()),
          );
        },
      ),
    );
  }
}
