import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PickImageCamera extends StatefulWidget {
  const PickImageCamera({Key? key, required this.onPick, this.link})
      : super(key: key);

  final void Function(File) onPick;
  final String? link;

  @override
  State<PickImageCamera> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<PickImageCamera> {
  File? imageFile;

  void takePicture() async {
    ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera, imageQuality: 10);
    if (image != null) {
      setState(() {
        imageFile = File(image.path);
      });
      widget.onPick(imageFile!);
    }
  }

  Widget defaultContent = Container(
    width: 80,
    height: 80,
    //color: Colors.black12,
    decoration: const BoxDecoration(
      gradient: LinearGradient(
        transform: GradientRotation(45),
        colors: [Colors.black, Colors.black26, Colors.black],
        stops: [0, 0.8, 1.0],
      ),
    ),
    child: const Icon(
      color: Colors.white54,
      Icons.camera_alt,
      size: 40,
    ),
  );

  Widget noImageContent() {
    return widget.link == null ? defaultContent : CachedNetworkImage(
      height: 150,
      imageUrl : widget.link!,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) {
        return defaultContent;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: takePicture,
      child: imageFile == null
          ? noImageContent()
          : Image.file(imageFile!, fit: BoxFit.fill, height: 150),
    );
  }
}
