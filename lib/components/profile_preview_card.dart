import 'package:flutter/material.dart';

class ProfilePreviewCard extends StatelessWidget {
  final String name, username, imageUrl;
  final VoidCallback? onTap;
  final Widget? trailingWidget;
  const ProfilePreviewCard({
    Key? key,
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
                  name,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
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
      onTap: onTap,
      contentPadding: const EdgeInsets.all(5),
    );
  }
}
