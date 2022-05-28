import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

Widget profileImage(String url, Size size) {
  return FadeInImage.memoryNetwork(
    placeholder: kTransparentImage,
    image: url,
    fit: BoxFit.cover,
    imageErrorBuilder: (context, object, stacktrace) {
      return Container(
        height: size.height * 0.35,
        width: size.width,
        color: Colors.transparent,
        child: const Center(
          child: Text(
            'Failed to load image.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    },
  );
}
