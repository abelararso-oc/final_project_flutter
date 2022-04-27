import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSelectDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          leading: Icon(Icons.photo_library),
          title: Text('Photo Library'),
          onTap: () async {
            final bytes = await _getImage(imageSource: ImageSource.gallery);
            Navigator.of(context).pop(bytes);
          },
        ),
        ListTile(
          leading: Icon(Icons.photo_camera),
          title: Text('Camera'),
          onTap: () async {
            final bytes = await _getImage(imageSource: ImageSource.camera);
            Navigator.of(context).pop(bytes);
          },
        ),
      ],
    );
  }

  Future<Uint8List?> _getImage({required ImageSource imageSource}) async {
    final _picker = ImagePicker();
    final image = await _picker.pickImage(
      source: imageSource,
      preferredCameraDevice: CameraDevice.front,
    );

    return image?.readAsBytes();
  }
}
