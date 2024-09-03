import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../controller/note_controller.dart';

class GetAndSelectImageWidget extends StatelessWidget {
  final NoteController noteController;

  const GetAndSelectImageWidget({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      height: 150,
      width: 150,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        color: const Color(0xFF515156),
      ),
      child: noteController.selectedImage.value != null
          ? ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: Image.file(
          noteController.selectedImage.value!,
          fit: BoxFit.cover,
        ),
      )
          : IconButton(
        onPressed: noteController.pickImage,
        icon: const Icon(
          Icons.image,
          color: Colors.white,
          size: 70,
        ),
      ),
    ));
  }
}
