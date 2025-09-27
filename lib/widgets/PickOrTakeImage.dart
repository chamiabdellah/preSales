import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickOrTakeImage extends StatelessWidget {
  const PickOrTakeImage({
    Key? key,
    required this.onPick,
    this.image,
  }) : super(key: key);

  final void Function(File) onPick;
  final File? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 200,
          width: double.infinity,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: image != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.file(
                    image!,
                    fit: BoxFit.cover,
                  ),
                )
              : const Center(
                  child: Icon(
                    Icons.person,
                    size: 80,
                    color: Colors.grey,
                  ),
                ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: CircleAvatar(
            backgroundColor: Colors.blue,
            child: IconButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Caméra'),
                          onTap: () async {
                            Navigator.pop(context);
                            final picker = ImagePicker();
                            final pickedImage = await picker.pickImage(
                              source: ImageSource.camera,
                              imageQuality: 10,
                            );
                            if (pickedImage != null) {
                              onPick(File(pickedImage.path));
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo_library),
                          title: const Text('Galerie'),
                          onTap: () async {
                            Navigator.pop(context);
                            final picker = ImagePicker();
                            final pickedImage = await picker.pickImage(
                              source: ImageSource.gallery,
                              imageQuality: 10,
                            );
                            if (pickedImage != null) {
                              onPick(File(pickedImage.path));
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
              icon: Icon(
                image != null ? Icons.edit : Icons.camera_alt,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}