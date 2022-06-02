import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:intl/intl.dart';

import 'package:nerajima/router/router.gr.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/components/pill_button.dart';

class ProfileInformation extends StatelessWidget {
  final String name, bio;
  final int numFollowers, numWhitelisted, numFollowing;

  const ProfileInformation({
    Key? key,
    required this.name,
    required this.bio,
    required this.numFollowers,
    required this.numWhitelisted,
    required this.numFollowing,
  }) : super(key: key);

  static final NumberFormat numberFormat = NumberFormat('###,000');

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double statsMargin = size.width * 0.05; // if a stat value goes onto the next line, reduce 0.05 until it doesn't
    return Center(
      child: SizedBox(
        width: size.width * 0.8,
        child: Column(
          children: [
            if (name != "") _name(name),
            Row(
              children: [
                _statItem(context, 0, 'Followers', (numFollowers < 1000) ? numFollowers.toString() : numberFormat.format(numFollowers)),
                Container(
                  width: 1,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: statsMargin),
                  color: Colors.grey,
                ),
                _statItem(context, 1, 'Whitelisted', (numWhitelisted < 1000) ? numWhitelisted.toString() : numberFormat.format(numWhitelisted)),
                Container(
                  width: 1,
                  height: 40,
                  margin: EdgeInsets.symmetric(horizontal: statsMargin),
                  color: Colors.grey,
                ),
                _statItem(context, 2, 'Following', (numFollowing < 1000) ? numFollowing.toString() : numberFormat.format(numFollowing)),
              ],
            ),
            const SizedBox(height: 25),
            _editButton(context),
            if (bio != "") _bio(bio),
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
              context.router.push(const EditRouter());
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
}
