import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:custom_nested_scroll_view/custom_nested_scroll_view.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/pages/profile/components/profile_header.dart';
import 'package:nerajima/pages/profile/components/header_buttons.dart';
import 'package:nerajima/pages/profile/components/edit/edit_picture_options.dart';
import 'package:nerajima/pages/profile/components/profile_picture.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/utils/show_alert.dart';
import 'package:nerajima/utils/opacity_slope_calculator.dart';
import 'package:nerajima/utils/button_styles.dart';

import 'package:nerajima/pages/profile/components/edit/edit_username.dart';
import 'package:nerajima/pages/profile/components/edit/edit_name.dart';
import 'package:nerajima/pages/profile/components/edit/edit_bio.dart';
import 'package:nerajima/pages/profile/components/edit/edit_blacklist_message.dart';
import 'package:nerajima/pages/profile/components/whitelist/manage_whitelist.dart';

class EditProfilePage extends StatelessWidget {
  static const String route = "/editProfile";
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomNestedScrollView(
        physics: const BouncingScrollPhysics(),
        overscrollType: CustomOverscroll.outer,
        headerSliverBuilder: (context, outerBoxIsScrolled) {
          return [
            CustomSliverOverlapAbsorber(
              overscrollType: CustomOverscroll.outer,
              handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(context),
              sliver: _header(context),
            ),
          ];
        },
        body: _body(context),
      ),
    );
  }

  Widget _header(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double opacityIncreaseSlope = calculateOpacitySlope(maxOpacity: ((size.height / 2.2) - 103) * (1 - 0.75));

    return SliverPersistentHeader(
      pinned: true,
      delegate: ProfileHeaderDelegate(
        minExtentParam: 103,
        maxExtentParam: size.height / 2.2,
        opacityIncreaseSlope: opacityIncreaseSlope,
        percentScrollForOpacity: 0.75,
        username: "Edit Profile",
        dateJoined: "",
        isCurrentUserProfile: false,
        leading: const HeaderButtons(buttonType: Button.back),
        background: _background(context),
        action: null,
        onStrech: null,
        onHeaderTap: null,
      ),
    );
  }

  Widget _background(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return Stack(
          children: [
            Positioned.fill(
              child: (user.newProfilePicture != null) ? Image.file(user.newProfilePicture!, fit: BoxFit.cover) : cachedProfileImage(user.user.profilePicture, size),
            ),
            if (user.savedNewProfilePicture)
              Positioned.fill(
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: () async {
                    if (user.userStatus == UserStatus.uploading) return;
                    await showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      enableDrag: true,
                      useRootNavigator: true,
                      builder: (context) {
                        return const EditPictureOptions();
                      },
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(color: Colors.black.withOpacity(0.5)),
                    child: const Icon(Icons.edit, color: Colors.white),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      top: false,
      child: Builder(
        builder: (BuildContext context) {
          return CustomScrollView(
            slivers: [
              CustomSliverOverlapInjector(
                overscrollType: CustomOverscroll.outer,
                handle: CustomNestedScrollView.sliverOverlapAbsorberHandleFor(context),
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    Center(
                      child: SizedBox(
                        width: size.width * 0.85,
                        child: Consumer<UserProvider>(
                          builder: (context, user, child) {
                            return Column(
                              children: [
                                if (!user.savedNewProfilePicture) _profilePictureActions(context),
                                SizedBox(height: size.height * 0.025),
                                _field(context, "Username", user.user.username),
                                SizedBox(height: size.height * 0.03),
                                _field(context, "Name", user.user.name),
                                SizedBox(height: size.height * 0.03),
                                _field(context, "Bio", user.user.bio),
                                SizedBox(height: size.height * 0.03),
                                _field(context, "Blacklist Msg", user.user.blacklistMessage),
                                SizedBox(height: size.height * 0.03),
                                _field(context, "Manage Whitelist", ""),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _profilePictureActions(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<UserProvider>(
      builder: (context, user, child) {
        return Column(
          children: [
            SizedBox(height: size.height * 0.025),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      if (user.newProfilePicture == null) return;
                      showDialog(
                        context: context,
                        builder: (context) {
                          return Consumer<UserProvider>(
                            builder: (context, user, child) {
                              if (user.savedNewProfilePicture) {
                                Navigator.of(context).pop();
                                return const SizedBox();
                              } else {
                                return const LoadingSpinner();
                              }
                            },
                          );
                        },
                      );
                      final res = await user.changeProfilePicture();
                      if (!res["status"]) {
                        showAlert(msg: res["message"], context: context, isError: true);
                      }
                    },
                    style: noSplashButtonStyle(),
                    child: const Text(
                      "Save",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: primary),
                    ),
                  ),
                ),
                const SizedBox(width: 11),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => user.clearNewProfilePicture(),
                    style: noSplashButtonStyle(),
                    child: const Text(
                      "Clear",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  Widget _field(BuildContext context, String fieldName, String fieldValue) {
    final size = MediaQuery.of(context).size;
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (fieldName == "Username") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const EditUsernamePage(),
            settings: const RouteSettings(name: EditUsernamePage.route),
          );
        } else if (fieldName == "Name") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const EditNamePage(),
            settings: const RouteSettings(name: EditNamePage.route),
          );
        } else if (fieldName == "Bio") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const EditBioPage(),
            settings: const RouteSettings(name: EditBioPage.route),
          );
        } else if (fieldName == "Blacklist Msg") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const EditBlacklistMessagePage(),
            settings: const RouteSettings(name: EditBlacklistMessagePage.route),
          );
        } else if (fieldName == "Manage Whitelist") {
          pushNewScreenWithRouteSettings(
            context,
            screen: const ManageWhitelist(),
            settings: const RouteSettings(name: ManageWhitelist.route),
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(11),
          border: Border.all(color: Colors.grey, width: 0.2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              fieldName,
              style: const TextStyle(fontSize: 16),
            ),
            if (fieldName != "Manage Whitelist")
              SizedBox(
                width: size.width * 0.42,
                child: Text(
                  fieldValue,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontSize: 17),
                ),
              )
            else
              const Icon(Icons.arrow_forward_ios_rounded, size: 16),
          ],
        ),
      ),
    );
  }
}
