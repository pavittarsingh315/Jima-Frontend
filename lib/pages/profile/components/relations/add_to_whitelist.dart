import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart';
import 'dart:convert' as convert;

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/components/ui_search_bar.dart';
import 'package:nerajima/models/search_models.dart';
import 'package:nerajima/utils/api_endpoints.dart';
import 'package:nerajima/components/loading_spinner.dart';
import 'package:nerajima/components/profile_preview_card.dart';
import 'package:nerajima/components/pill_button.dart';

class AddToWhitelist extends StatefulWidget {
  const AddToWhitelist({Key? key}) : super(key: key);

  @override
  State<AddToWhitelist> createState() => _AddToWhitelistState();
}

class _AddToWhitelistState extends State<AddToWhitelist> {
  Timer? searchTimer;
  final TextEditingController searchController = TextEditingController();
  bool isClosing = false, showClearButton = false, showSuggestions = false;
  double currentFABPadding = 0; // autofocus == true => isKeyboardVisible == true => padding == 0

  // infinte scroll props
  final int limit = 30;
  final ScrollController _scrollController = ScrollController();
  int page = 1;
  bool isLoading = false, hasError = false, hasMore = true;
  List<SearchUser> searchSuggestions = [];

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      if (_scrollController.position.maxScrollExtent == _scrollController.offset) {
        if (!hasError) makeSearch();
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _checkIfSearchHasValue() {
    if (searchController.text != "") {
      if (!showClearButton) {
        showClearButton = true;
        showSuggestions = true;
        setState(() {});
      }
    } else {
      if (showClearButton) {
        showClearButton = false;
        showSuggestions = false;
        setState(() {});
      }
    }
  }

  void _onSearchTypingStop(value) {
    if (searchTimer != null) searchTimer?.cancel();
    setState(() {
      searchTimer = Timer(const Duration(milliseconds: 500), () {
        page = 1;
        isLoading = false;
        hasError = false;
        hasMore = true;
        searchSuggestions = [];
        makeSearch();
      });
    });
  }

  Future<void> makeSearch() async {
    final String query = searchController.text;
    if (query != "") {
      if (isLoading || !hasMore) return; // prevents excess requests being performed.
      isLoading = true;

      UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);
      final url = Uri.parse("${ApiEndpoints.searchForUser}/$query?page=$page&limit=$limit");
      Response response = await get(url, headers: userProvider.requestHeaders);
      final Map<String, dynamic> resData = convert.jsonDecode(convert.utf8.decode(response.bodyBytes));

      if (resData["message"] == "Success") {
        List resArray = resData["data"]["data"];
        List<SearchUser> parsedRes = resArray.map((e) {
          return SearchUser.fromJson(e);
        }).toList();

        setState(() {
          hasMore = parsedRes.length == limit;
          isLoading = false;
          page++;
          searchSuggestions.addAll(parsedRes);
        });
      } else if (resData["message"] == "Error") {
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final safeAreaPadding = MediaQuery.of(context).padding;
    return Scaffold(
      floatingActionButton: _closeButton(context),
      body: Center(
        child: SizedBox(
          width: size.width * 0.95,
          child: Column(
            children: [
              UISearchBar(
                autofocus: true,
                hintText: "Search",
                controller: searchController,
                padding: EdgeInsets.only(top: safeAreaPadding.top, bottom: 6),
                suffix: _clearSearchBar(context),
                onChanged: (v) {
                  _checkIfSearchHasValue();
                  _onSearchTypingStop(v);
                },
              ),
              if (!showSuggestions) _noSearchValue(context) else _suggestions(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _clearSearchBar(BuildContext context) {
    if (showClearButton) {
      return GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          HapticFeedback.lightImpact();
          searchController.text = "";
          showClearButton = false;
          showSuggestions = false;
          setState(() {});
        },
        child: const Icon(
          CupertinoIcons.clear_circled,
          color: Colors.grey,
          size: 16,
        ),
      );
    }
    return null;
  }

  Widget _noSearchValue(BuildContext context) {
    return Expanded(
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            children: [
              AnimatedContainer(
                curve: Curves.linear,
                duration: const Duration(milliseconds: 50),
                alignment: Alignment.center,
                constraints: BoxConstraints(maxHeight: constraints.maxHeight - navBarHeight(context)),
                child: Wrap(
                  direction: Axis.vertical,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Icon(CupertinoIcons.search, size: 50),
                    SizedBox(height: 10),
                    Text(
                      "Search Users",
                      style: TextStyle(fontSize: 35),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text("Search for a user you would like to whitelist.", textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _closeButton(BuildContext context) {
    return KeyboardVisibilityBuilder(
      builder: (context, isKeyboardVisible) {
        if (!isClosing) currentFABPadding = isKeyboardVisible ? 0 : 50; // if screen is closing, don't change the padding
        return AnimatedPadding(
          padding: EdgeInsets.only(bottom: currentFABPadding),
          duration: const Duration(milliseconds: 400),
          curve: Curves.linear,
          child: FloatingActionButton(
            onPressed: () {
              isClosing = true;
              HapticFeedback.mediumImpact();
              Navigator.of(context).pop();
            },
            backgroundColor: Colors.red,
            child: const Icon(
              CupertinoIcons.xmark,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget loadingBody(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, theme, child) {
        return LoadingSpinner(color: theme.isDarkModeEnabled ? Colors.white : Colors.black);
      },
    );
  }

  Widget errorBody(BuildContext context) {
    return const Center(child: Text("Error..."));
  }

  Widget _suggestions(BuildContext context) {
    if (hasError) {
      return errorBody(context);
    }
    return Expanded(
      child: Center(
        child: SizedBox(width: MediaQuery.of(context).size.width * 0.95, child: results(context)),
      ),
    );
  }

  Widget results(BuildContext context) {
    if (searchSuggestions.isEmpty) return const SizedBox();

    return Scrollbar(
      child: ListView.builder(
        controller: _scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: searchSuggestions.length + 1,
        padding: EdgeInsets.only(bottom: navBarHeight(context)),
        itemBuilder: (context, index) {
          if (index == searchSuggestions.length) {
            return Container(
              padding: EdgeInsets.symmetric(vertical: hasMore ? 25.0 : 0),
              child: hasMore ? Center(child: loadingBody(context)) : const SizedBox(),
            );
          }
          return ProfilePreviewCard(
            profileId: searchSuggestions[index].profileId,
            name: searchSuggestions[index].name,
            username: searchSuggestions[index].username,
            imageUrl: searchSuggestions[index].miniProfilePicture,
            trailingWidget: AddToWhitelistAction(profileId: searchSuggestions[index].profileId),
          );
        },
      ),
    );
  }
}

class AddToWhitelistAction extends StatefulWidget {
  final String profileId;
  const AddToWhitelistAction({Key? key, required this.profileId}) : super(key: key);

  @override
  State<AddToWhitelistAction> createState() => _AddToWhitelistActionState();
}

class _AddToWhitelistActionState extends State<AddToWhitelistAction> {
  bool didInviteUser = false;
  bool arePerformingAction = false;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    if (widget.profileId == userProvider.user.profileId) return const SizedBox();

    return PillButton(
      onTap: () async {
        if (arePerformingAction) return;
        setState(() => arePerformingAction = true);

        final res = await userProvider.inviteToWhitelist(profileId: widget.profileId);
        if (res["status"] || res["message"] == "Invite already sent.") didInviteUser = true; // TODO: insert this new invite into sent invites

        setState(() => arePerformingAction = false);
      },
      color: primary,
      width: 100,
      enabled: !didInviteUser,
      child: arePerformingAction ? const LoadingSpinner() : Text(!didInviteUser ? "Invite" : "Invited"),
    );
  }
}
