import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../model/note_model.dart';

class NoteCardWidget extends StatelessWidget {
  final  NotesModel note;
  const NoteCardWidget({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    const String defaultImage = 'assets/image/boy_image.png';
    return Container(
      decoration: BoxDecoration(
        color: note.category == 'Work'
            ? const Color(0xffd6db3e)
            : const Color(0xFFD5D4D4),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 5,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              note.title ?? "No Title",
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 10),
            Text(
              formatDate(note.createdAt),
              style: const TextStyle(
                  color: Colors.black54,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            PhysicalModel(
              color: Colors.white,
              shape: BoxShape.circle,
              child: Padding(
                padding: const EdgeInsets.all(3.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(150),
                  child: SizedBox(
                    width: 25,
                    height: 25,
                    child: note.image != null && note.image!.startsWith('http')
                        ? CachedNetworkImage(
                      imageUrl: note.image!,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                      const CupertinoActivityIndicator(),
                      errorWidget: (context, url, error) =>
                          Image.asset(defaultImage, fit: BoxFit.cover),
                    )
                        : (note.image != null && File(note.image!).existsSync()
                        ? Image.file(
                      File(note.image!),
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Image.asset(defaultImage, fit: BoxFit.cover),
                    )
                        : Image.asset(defaultImage, fit: BoxFit.cover)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  String formatDate(String? dateString) {
    try {
      if (dateString == null) return "Unknown date";
      DateTime date = DateTime.parse(dateString);
      return DateFormat('MMM dd yyyy').format(date);
    } catch (e) {
      return "Invalid date";
    }
  }
}
