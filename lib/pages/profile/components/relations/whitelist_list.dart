import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:nerajima/providers/theme_provider.dart';
import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/components/loading_spinner.dart';

class WhitelistList extends StatefulWidget {
  final String profileId;
  const WhitelistList({Key? key, required this.profileId}) : super(key: key);

  @override
  State<WhitelistList> createState() => _WhitelistListState();
}

class _WhitelistListState extends State<WhitelistList> with AutomaticKeepAliveClientMixin {
  bool loading = true, accessDenied = false, hasError = false;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _getWhitelist();
  }

  Future<void> _getWhitelist() async {
    try {
      _userProvider = Provider.of<UserProvider>(context, listen: false);
      if (widget.profileId != _userProvider.user.profileId) {
        loading = false;
        accessDenied = true;
        setState(() {});
        return;
      }
    } catch (e) {
      loading = false;
      hasError = true;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (loading) {
      return const LoadingSpinner();
    } else if (accessDenied) {
      return accessDeniedBody(context);
    } else if (hasError) {
      return const Center(child: Text("Error..."));
    } else {
      return whitelistBody(context);
    }
  }

  Widget whitelistBody(BuildContext context) {
    return ListView.builder(
      itemCount: 69,
      padding: EdgeInsets.only(bottom: navBarHeight(context)),
      itemBuilder: (BuildContext context, int index) {
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
    );
  }

  Widget accessDeniedBody(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        SizedBox(height: size.height / 3.33),
        const Icon(
          CupertinoIcons.nosign,
          size: 50,
          color: Colors.red,
        ),
        const SizedBox(height: 10),
        const Text(
          "Access Denied",
          style: TextStyle(fontSize: 35),
        ),
        const SizedBox(height: 10),
        const Text("You are only allowed to view your own whitelist."),
      ],
    );
  }

  @override
  bool get wantKeepAlive => true;
}
