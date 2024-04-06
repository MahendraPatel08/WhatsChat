import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {
  const UserImagePicker({super.key, required this.onPickedImage});

  final void Function(File pickedImage) onPickedImage;

  @override
  State<UserImagePicker> createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {
  File? _pickedImageFile;

  void _pickImage() async {
    final pickedImage = await ImagePicker().pickImage(
        source: ImageSource.gallery, imageQuality: 50, maxHeight: 150);

    if (pickedImage == null) {
      return;
    }

    setState(() {
      _pickedImageFile = File(pickedImage.path);
    });

    widget.onPickedImage(_pickedImageFile!);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: _pickImage,
          child: _pickedImageFile != null
              ? CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey,
                  foregroundImage: FileImage(_pickedImageFile!),
                )
              : const CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 40,
                  child: Icon(
                    Icons.person,
                    color: Colors.white,
                  ),
                ),
        ),
        TextButton.icon(
          onPressed: _pickImage,
          icon: Icon(
            Icons.image,
            color: Theme.of(context).textTheme.bodySmall!.color,
          ),
          label: Text(
            'Add Image',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodySmall!.color,
            ),
          ),
        ),
        const Text(
          "you won't be  able to change it later",
          style: TextStyle(color: Colors.grey),
        )
      ],
    );
  }
}
