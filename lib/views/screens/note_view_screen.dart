import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/note_controller.dart';
import '../../model/note_model.dart';
import 'home_screen.dart';
import 'note_edit_screen.dart';

class NoteViewScreen extends StatelessWidget {
  final NotesModel note;
  final int index;
  final NoteController noteController = Get.find();

  NoteViewScreen({required this.note, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text(
          'Note Details',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF1E1E1E),
        elevation: 1,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Note Title
            Padding(
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
            ),
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  color: const Color(0xFF515156).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withOpacity(0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Title",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  Divider(color: Colors.white,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      note.title ?? "Untitled",
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Note Content
            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: const Color(0xFF515156).withOpacity(0.3),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: Colors.white.withOpacity(0.5))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Content",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                  Divider(color: Colors.white,),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      note.content ?? "no content available",
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w300,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8.0),

            // Note Category
            if (note.category != null)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  'Category :   ${note.category!}',
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ),

            // Action Buttons
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if(note.category?.contains("Work") == true){
                        noteController.completedStatus.value = true;
                      }else{
                        noteController.completedStatus.value = false;
                      }
                      if(note.category?.contains("Home") == true){
                        noteController.completedStatus1.value = true;
                      }else{
                        noteController.completedStatus1.value = false;
                      }
                      Get.to(() => NoteEditScreen(
                            note: note,
                            index: index,
                          ));
                    },
                    child: const Text('Edit',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF515156),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12.0),
                  ElevatedButton(
                    onPressed: () {
                      noteController.deleteNote(note.id!);
                      Get.back(); // Navigate back to the previous screen
                    },
                    child: const Text('Delete',style: TextStyle(color: Colors.white),),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 12.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
