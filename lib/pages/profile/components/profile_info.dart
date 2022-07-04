import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/pages/profile/edit_profile.dart';
import 'package:nerajima/components/pill_button.dart';
import 'package:nerajima/components/loading_spinner.dart';

class ProfileInformation extends StatefulWidget {
  final String profileId, name, bio;
  final int numFollowers, numWhitelisted, numFollowing;
  final bool isCurrentUserProfile, areFollowing;

  const ProfileInformation({
    Key? key,
    required this.profileId,
    required this.name,
    required this.bio,
    required this.numFollowers,
    required this.numWhitelisted,
    required this.numFollowing,
    required this.isCurrentUserProfile,
    required this.areFollowing,
  }) : super(key: key);

  static final NumberFormat numberFormat = NumberFormat('###,000');

  @override
  State<ProfileInformation> createState() => _ProfileInformationState();
}

class _ProfileInformationState extends State<ProfileInformation> {
  late bool areFollowing = widget.areFollowing;
  late int numFollowers = widget.numFollowers;
  bool arePerformingAction = false;

  @override
  void didUpdateWidget(covariant ProfileInformation oldWidget) {
    super.didUpdateWidget(oldWidget);
    areFollowing = widget.areFollowing;
    numFollowers = widget.numFollowers;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double statsMargin = size.width * 0.05; // if a stat value goes onto the next line, reduce 0.05 until it doesn't
    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        child: Column(
          children: [
            if (widget.name != "") _name(widget.name),
            Row(
              children: [
                _statItem(context, 0, 'Followers', (numFollowers < 1000) ? numFollowers.toString() : ProfileInformation.numberFormat.format(numFollowers)),
                Container(
                  width: 1,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: statsMargin),
                  color: Colors.grey,
                ),
                _statItem(
                    context, 1, 'Whitelisted', (widget.numWhitelisted < 1000) ? widget.numWhitelisted.toString() : ProfileInformation.numberFormat.format(widget.numWhitelisted)),
                Container(
                  width: 1,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: statsMargin),
                  color: Colors.grey,
                ),
                _statItem(context, 2, 'Following', (widget.numFollowing < 1000) ? widget.numFollowing.toString() : ProfileInformation.numberFormat.format(widget.numFollowing)),
              ],
            ),
            const SizedBox(height: 25),
            widget.isCurrentUserProfile ? _editButton(context) : _actions(context),
            if (widget.bio != "") _bio(widget.bio),
          ],
        ),
      ),
    );
  }

  Widget _name(String fullName) {
    return Column(
      children: [
        Text(
          fullName,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 25,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  Widget _statItem(BuildContext context, int index, String label, String value) {
    // index for openning correct tab when click on the item
    // context for UserProvider
    return Expanded(
      child: Column(
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _editButton(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: PillButton(
            onTap: () {
              pushNewScreenWithRouteSettings(
                context,
                screen: const EditProfilePage(),
                settings: const RouteSettings(name: EditProfilePage.route),
              );
            },
            color: primary,
            margin: 0,
            child: const Text("Edit Profile"),
          ),
        ),
      ],
    );
  }

  Widget _bio(String bio) {
    return Column(
      children: [
        const SizedBox(height: 17),
        Text(
          bio,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 14),
        ),
      ],
    );
  }

  Widget _actions(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
    if (!areFollowing) {
      return Row(
        children: [
          Expanded(
            child: PillButton(
              onTap: () async {
                if (arePerformingAction) return; // prevents spam
                arePerformingAction = true;
                setState(() {});
                final res = await userProvider.followUser(profileId: widget.profileId);
                if (res["status"]) {
                  areFollowing = true;
                  numFollowers++;
                }
                arePerformingAction = false;
                setState(() {});
              },
              color: primary,
              margin: 0,
              child: arePerformingAction ? const LoadingSpinner() : const Text("Follow"),
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: PillButton(
              onTap: () async {
                if (arePerformingAction) return; // prevents spam
                arePerformingAction = true;
                setState(() {});
                final res = await userProvider.unfollowUser(profileId: widget.profileId);
                if (res["status"]) {
                  areFollowing = false;
                  numFollowers--;
                }
                arePerformingAction = false;
                setState(() {});
              },
              color: Colors.red,
              margin: 0,
              child: arePerformingAction ? const LoadingSpinner() : const Text("Unfollow"),
            ),
          ),
        ],
      );
    }
  }
}
