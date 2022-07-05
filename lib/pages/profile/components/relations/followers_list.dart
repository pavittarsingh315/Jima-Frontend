import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';

class FollowersList extends StatefulWidget {
  final String profileId;
  const FollowersList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<FollowersList> createState() => _FollowersListState();
}

class _FollowersListState extends State<FollowersList> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    _getFollowers();
  }

  Future<void> _getFollowers() async {
    // make api request to get followers.
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
            color: index % 2 == 0 ? Colors.orange.shade200 : Colors.purple.shade100,
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
