import 'dart:io';
import 'package:esferasoft/views/screens/home/home_screen.dart';
import 'package:esferasoft/views/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/note_controller.dart';
import '../../../model/note_model.dart';

class NoteEditScreen extends StatefulWidget {
  final NotesModel? note;
  final int index;

  NoteEditScreen({this.note, required this.index});

  @override
  _NoteEditScreenState createState() => _NoteEditScreenState();
}

class _NoteEditScreenState extends State<NoteEditScreen> {
  final NoteController noteController = Get.find();

  late TextEditingController _titleController;
  late TextEditingController _contentController;

  var view = AppWidgets();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    noteController.selectedImage.value = widget.note?.image != null ? File(widget.note!.image!) : null;
    noteController.isWorkCheckValue.value = widget.note?.category?.contains("Work") == true;
    noteController.isHomeCheckValue.value = widget.note?.category?.contains("Home") == true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text('Edit Note', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFF121212),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Obx(() => buildSelectImage()),
            view.sizedBoxView(height: 16),
            view.textFormFieldView(controller: _titleController, labelText: 'Title'),
            view.sizedBoxView(height: 16),
            view.textFormFieldView(controller: _contentController, labelText: 'Content'),
            view.sizedBoxView(height: 16),
            const Text(
              "Please Select category",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
            Obx(() => view.checkBoxListTile(
              title: "Work",
              value: noteController.isWorkCheckValue.value,
              onChanged: (value) {
                noteController.isWorkCheckValue.value = value ?? false;
              },
            )),
            Obx(() => view.checkBoxListTile(
              title: "Home",
              value: noteController.isHomeCheckValue.value,
              onChanged: (value) {
                noteController.isHomeCheckValue.value = value ?? false;
              },
            )),
            view.sizedBoxView(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: view.elevatedButtonView(
                        onPressed: () async {
                            if (!noteController.isWorkCheckValue.value && !noteController.isHomeCheckValue.value) {
                              Get.snackbar(
                                "Error",
                                "Please select at least one category.",
                                backgroundColor: Colors.redAccent.withOpacity(0.7),
                                colorText: Colors.white,
                              );
                              return;
                            }

                            if (noteController.isWorkCheckValue.value && noteController.isHomeCheckValue.value) {
                              noteController.selectedCategory.value = "Work,Home";
                            } else if (noteController.isWorkCheckValue.value) {
                              noteController.selectedCategory.value = "Work";
                            } else if (noteController.isHomeCheckValue.value) {
                              noteController.selectedCategory.value = "Home";
                            }

                            final note = NotesModel(
                              id: widget.note?.id,
                              title: _titleController.text,
                              content: _contentController.text,
                              category: noteController.selectedCategory.value,
                              image: noteController.selectedImage.value?.path,
                              createdAt: widget.note == null ? DateTime.now().toString() : widget.note!.createdAt,
                            );

                            await noteController.updateNote(note, widget.index);
                            Get.offAll(() => const HomeScreen());

                        },
                        child: const Text("Save"),
                        backgroundColor: const Color(0xFF515156))),
                view.sizedBoxView(width: 10),
                Expanded(
                    child: view.elevatedButtonView(
                        onPressed: () {
                          Get.back();
                        },
                        child: const Text("Cancel"),
                        backgroundColor: Colors.redAccent.withOpacity(0.5))),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSelectImage() {
    return Center(
      child: GestureDetector(
        onTap: () => noteController.pickImage(),
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: const Color(0xFF515156), width: 5),
          ),
          child: noteController.selectedImage.value != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.file(
              noteController.selectedImage.value!,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
          )
              : const Center(
            child: Icon(
              Icons.add_a_photo,
              color: Colors.white54,
              size: 40,
            ),
          ),
        ),
      ),
    );
  }
}
