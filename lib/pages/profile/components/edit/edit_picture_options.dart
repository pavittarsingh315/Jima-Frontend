import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:nerajima/utils/custom_bottom_sheet.dart';

class EditPictureOptions extends StatefulWidget {
  const EditPictureOptions({Key? key}) : super(key: key);

  @override
  State<EditPictureOptions> createState() => _EditPictureOptionsState();
}

class _EditPictureOptionsState extends State<EditPictureOptions> {
  Future<void> _onCameraTap() async {}
  Future<void> _onImageTap() async {}

  @override
  Widget build(BuildContext context) {
    return CustomBottomSheet(
      children: [
        _option(context, "Camera", CupertinoIcons.camera, _onCameraTap),
        const Divider(color: Colors.grey),
        _option(context, "Choose an image ", CupertinoIcons.photo, _onImageTap),
        const Divider(color: Colors.grey),
        _cancelBtn(context),
      ],
    );
  }

  Widget _option(BuildContext context, String label, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        height: 60,
        width: double.infinity,
        padding: const EdgeInsets.only(left: 15, right: 18),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 15)),
            Icon(icon, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _cancelBtn(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        Navigator.of(context).pop();
      },
      child: const SizedBox(
        height: 60,
        width: double.infinity,
        child: Center(
          child: Text(
            "Cancel",
            style: TextStyle(
              color: Colors.red,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
