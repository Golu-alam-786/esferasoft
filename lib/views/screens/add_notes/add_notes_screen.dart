import 'package:esferasoft/views/screens/add_notes/widgets/get_and_select_image_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/note_controller.dart';
import 'package:esferasoft/views/utils/app_widgets.dart';

class AddNoteScreen extends StatelessWidget {
  final NoteController noteController = Get.put(NoteController());
  final view = AppWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E1E),
      appBar: AppBar(
        title: const Text('Add Note', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF1E1E1E),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetAndSelectImageWidget(noteController: noteController),
              view.sizedBoxView(height: 20),
              view.textFormFieldView(
                controller: noteController.titleController,
                hintText: 'Title',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Title is required';
                  }
                  if (value.length < 3) {
                    return 'Title must be at least 3 characters long';
                  }
                  return null;
                },
              ),
              view.sizedBoxView(height: 10),
              view.textFormFieldView(
                controller: noteController.contentController,
                hintText: 'Content',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Content is required';
                  }
                  if (value.length < 10) {
                    return 'Content must be at least 10 characters long';
                  }
                  return null;
                },
              ),
              view.sizedBoxView(height: 10),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Align( alignment: Alignment.topLeft,child: Text("Please Select category", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16))),
              ),
              Obx(()=> view.checkBoxListTile(title: "Work", value: noteController.isWorkCheckValue.value, onChanged: (value) {
                  noteController.isWorkCheckValue.value = value ?? false;
                },),
              ),
              Obx(()=> view.checkBoxListTile(title: "Home", value: noteController.isHomeCheckValue.value, onChanged: (value) {
                noteController.isHomeCheckValue.value = value ?? false;
              },),
              ),
              view.sizedBoxView(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF515156),fixedSize: const Size(280, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: noteController.addNote,
                child: const Text('Save Note',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
