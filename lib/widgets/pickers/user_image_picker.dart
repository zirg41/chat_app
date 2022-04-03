import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImage;

  _pickImage() async {
    final PickedFile? pickedImageFile =
        await ImagePicker.platform.pickImage(source: ImageSource.camera);

    setState(() {
      _pickedImage = File(pickedImageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: Colors.grey,
          backgroundImage:
              _pickedImage == null ? null : FileImage(_pickedImage!),
        ),
        FlatButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.image),
          label: const Text("Add image"),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
