import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

import 'package:nerajima/providers/user_provider.dart';
import 'package:nerajima/utils/custom_bottom_sheet.dart';
import 'package:nerajima/utils/custom_dialog.dart';

class EditPictureOptions extends StatefulWidget {
  const EditPictureOptions({Key? key}) : super(key: key);

  @override
  State<EditPictureOptions> createState() => _EditPictureOptionsState();
}

class _EditPictureOptionsState extends State<EditPictureOptions> {
  final ImagePicker _picker = ImagePicker();
  bool ignoreGesture = false;

  void popBottomSheet() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context, listen: false);

    Future<void> _cropImage(XFile image) async {
      CroppedFile? croppedImage = await ImageCropper().cropImage(
        sourcePath: image.path,
        compressQuality: 100,
        compressFormat: ImageCompressFormat.jpg,
        cropStyle: CropStyle.rectangle,
        uiSettings: [
          AndroidUiSettings(toolbarTitle: "Crop", showCropGrid: false),
          IOSUiSettings(title: "Crop", showCancelConfirmationDialog: true),
        ],
      );
      if (croppedImage != null) {
        userProvider.setNewProfilePicture(newProfilePicture: File(croppedImage.path));
        popBottomSheet();
      }
    }

    Future<void> _onCameraTap() async {
      // isDenied is true by default. When user actually clicks "Dont Allow", then isPermanentlyDenied is set to true.
      if (await Permission.camera.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder: (context) {
            void cancel() => Navigator.of(context).pop();
            void settings() => openAppSettings();
            return CustomDialog(
              message: "Allow Camera Access in Settings",
              actionLabels: const ["Cancel", "Settings"],
              actionCallbacks: [cancel, settings],
              actionColors: const [Colors.red, Colors.blue],
            );
          },
        );
        return;
      }

      if (await Permission.camera.request().isGranted) {
        try {
          ignoreGesture = true;
          setState(() {});
          final XFile? image = await _picker.pickImage(source: ImageSource.camera);
          ignoreGesture = false;
          setState(() {});
          if (image != null) {
            await _cropImage(image);
          }
        } catch (_) {}
      }
    }

    Future<void> _onImageTap() async {
      if (await Permission.photos.isPermanentlyDenied) {
        showDialog(
          context: context,
          builder: (context) {
            void cancel() => Navigator.of(context).pop();
            void settings() => openAppSettings();
            return CustomDialog(
              message: "Allow Photo Access in Settings",
              actionLabels: const ["Cancel", "Settings"],
              actionCallbacks: [cancel, settings],
              actionColors: const [Colors.red, Colors.blue],
            );
          },
        );
        return;
      }

      if (await Permission.photos.request().isGranted) {
        try {
          final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
          if (image != null) {
            await _cropImage(image);
          }
        } catch (_) {}
      }
    }

    return IgnorePointer(
      ignoring: ignoreGesture,
      child: CustomBottomSheet(
        children: [
          _option(context, "Camera", CupertinoIcons.camera, _onCameraTap),
          const Divider(color: Colors.grey),
          _option(context, "Choose an image ", CupertinoIcons.photo, _onImageTap),
          const Divider(color: Colors.grey),
          _cancelBtn(context),
        ],
      ),
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
