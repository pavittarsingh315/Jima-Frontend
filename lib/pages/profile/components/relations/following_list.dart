import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';

class FollowingList extends StatefulWidget {
  final String profileId;
  const FollowingList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<FollowingList> createState() => _FollowingListState();
}

class _FollowingListState extends State<FollowingList> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _getFollowing();
  }

  Future<void> _getFollowing() async {
    // make api request to get following.
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ListView.builder(
      itemCount: 69,
      padding: EdgeInsets.only(bottom: navBarHeight(context)),
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
