import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:nerajima/components/visit_profile.dart';

class ProfilePreviewCard extends StatelessWidget {
  final String profileId, name, username, imageUrl;
  final VoidCallback? onTap;
  final Widget? trailingWidget;
  const ProfilePreviewCard({
    Key? key,
    required this.profileId,
    required this.name,
    required this.username,
    required this.imageUrl,
    this.onTap,
    this.trailingWidget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
        backgroundColor: Colors.black,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name != "" ? name : username,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                if (name != "")
                  Text(
                    username,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                  ),
              ],
            ),
          ),
          if (trailingWidget != null) trailingWidget!,
        ],
      ),
      onTap: () {
        if (onTap != null) {
          onTap!();
        }
        pushNewScreenWithRouteSettings(
          context,
          screen: VisitProfile(profileId: profileId),
          settings: const RouteSettings(name: VisitProfile.route),
        );
      },
      contentPadding: const EdgeInsets.all(5),
    );
  }
}
