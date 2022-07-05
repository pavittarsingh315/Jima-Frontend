import 'package:flutter/material.dart';

import 'package:nerajima/providers/theme_provider.dart';

class PrivatePosts extends StatelessWidget {
  final String profileId, profileBlacklistMessage;
  final bool areWhitelisted;

  const PrivatePosts({Key? key, required this.profileId, required this.profileBlacklistMessage, required this.areWhitelisted}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (areWhitelisted) {
      return PrivatePostsBody(profileId: profileId);
    } else {
      return _displayBlackListMessage(context);
    }
  }

  Widget _displayBlackListMessage(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      removeTop: true,
      child: SafeArea(
        child: Center(
          child: Wrap(
            children: [
              Center(
                child: Text(
                  profileBlacklistMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22),
                ),
              ),
              // Container makes it so emojis don't render all choppy. Replace it with a button or leave it like so.
              Container(height: 1, color: Colors.transparent),
            ],
          ),
        ),
      ),
    );
  }
}

class PrivatePostsBody extends StatefulWidget {
  final String profileId;

  const PrivatePostsBody({Key? key, required this.profileId}) : super(key: key);

  @override
  State<PrivatePostsBody> createState() => _PrivatePostsBodyState();
}

class _PrivatePostsBodyState extends State<PrivatePostsBody> {
  @override
  void initState() {
    super.initState();
    debugPrint('built private posts');
  }

  @override
  void dispose() {
    debugPrint('disposed private posts');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        return CustomScrollView(
          key: const PageStorageKey("private_posts"),
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
                        color: index % 2 == 0 ? Colors.green.shade100 : Colors.pink.shade100,
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
