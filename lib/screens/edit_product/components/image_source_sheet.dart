import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageSourceSheet extends StatelessWidget {
  ImageSourceSheet({@required this.onImageSelected});

  final ImagePicker picker = ImagePicker();

  final Function(File) onImageSelected;

  @override
  Widget build(BuildContext context) {
    Future<void> editImage(File path) async {
      //setando a iamgem obtida
      onImageSelected(path);
    }

// for android
    if (Platform.isAndroid) {
      return BottomSheet(
        onClosing: () {},
        builder: (_) => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextButton(
              onPressed: () async {
                final XFile file =
                    await picker.pickImage(source: ImageSource.camera);
                if (file != null) {
                  editImage(File(file.path));
                }
              },
              child: const Text("Camera"),
            ),
            TextButton(
              onPressed: () async {
                final XFile file =
                    await picker.pickImage(source: ImageSource.gallery);
                if (file != null) {
                  editImage(File(file.path));
                }
              },
              child: const Text("Galeria"),
            ),
          ],
        ),
      );
    } else {
      return CupertinoActionSheet(
        title: const Text("Selecionar foto para o item"),
        message: const Text("Escolha a origem da foto"),
        cancelButton: CupertinoActionSheetAction(
            onPressed: () {}, child: const Text("Cancelar")),
        actions: [
          CupertinoActionSheetAction(
            child: const Text("Camera"),
            onPressed: () async {
              final XFile file =
                  await picker.pickImage(source: ImageSource.camera);
              if (file != null) {
                editImage(File(file.path));
              }
            },
          ),
          CupertinoActionSheetAction( 
            child: const Text("Galeria"),
            onPressed: () async {
              final XFile file =
                  await picker.pickImage(source: ImageSource.camera);

              if (file != null) {
                editImage(File(file.path));
              }
            },
          ),
        ],
      );
    }
  }
}
