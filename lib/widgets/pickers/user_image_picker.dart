import 'package:flutter/material.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({Key? key}) : super(key: key);

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
        ),
        FlatButton.icon(
          onPressed: () {},
          icon: const Icon(Icons.image),
          label: const Text("Add image"),
          textColor: Theme.of(context).primaryColor,
        ),
      ],
    );
  }
}
