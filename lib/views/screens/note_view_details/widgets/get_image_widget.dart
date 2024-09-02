import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../../model/note_model.dart';

class GetImageWidget extends StatelessWidget {
  final NotesModel note;

  const GetImageWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    const String defaultImage = 'assets/image/boy_image.png';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18.0),
      child: PhysicalModel(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: SizedBox(
              width: 200,
              height: 250,
              child: note.image != null &&
                  note.image!.startsWith('http')
                  ? CachedNetworkImage(
                imageUrl: note.image!,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                const CupertinoActivityIndicator(),
                errorWidget: (context, url, error) =>
                    Image.asset(defaultImage, fit: BoxFit.cover),
              )
                  : (note.image != null &&
                  File(note.image!).existsSync()
                  ? Image.file(
                File(note.image!),
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Image.asset(defaultImage,
                        fit: BoxFit.cover),
              )
                  : Image.asset(defaultImage, fit: BoxFit.cover)),
            ),
          ),
        ),
      ),
    );
  }
}
