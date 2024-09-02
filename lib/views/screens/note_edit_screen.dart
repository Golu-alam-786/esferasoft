import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/note_controller.dart';
import '../../model/note_model.dart';

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
  late TextEditingController _categoryController;
  File? _selectedImage;
  bool completedStatus = false;
  bool completedStatus1 = false;


  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.note?.title ?? '');
    _contentController = TextEditingController(text: widget.note?.content ?? '');
    _categoryController = TextEditingController(text: widget.note?.category ?? '');
    _selectedImage = widget.note?.image != null ? File(widget.note!.image!) : null;
    completedStatus = widget.note?.category?.contains("Work") == true;
    completedStatus1 = widget.note?.category?.contains("Home") == true;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    _categoryController.dispose();
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
            buildSelectImage(),
            const SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Content',
                labelStyle: TextStyle(color: Colors.white70),
                border: OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white70),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white30),
                ),
              ),
              maxLines: 5,
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
          const Text("Please Select category",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
          CheckboxListTile(
            title: const Text(
              "Work",
              style: TextStyle(color: Colors.white),
            ),
            autofocus: false,
            selected: completedStatus,
            value: completedStatus,
            onChanged: (bool? value) {
              completedStatus = value ?? false;
              setState(() {});
            },
          ),
          CheckboxListTile(
            title: const Text(
              "Home",
              style: TextStyle(color: Colors.white),
            ),
            autofocus: false,
            selected: completedStatus1,
            value: completedStatus1,
            onChanged: (bool? value) {
              completedStatus1 = value ?? false;
              setState(() {});
            },
          ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final note = NotesModel(
                        id: widget.note?.id,
                        title: _titleController.text,
                        content: _contentController.text,
                        category: _categoryController.text,
                        image: _selectedImage?.path,
                        createdAt: widget.note == null
                            ? DateTime.now().toString()
                            : widget.note!.createdAt,
                      );
                      await noteController.updateNote(note, widget.index);
                      Get.back();
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: const Color(0xFF515156),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Save'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Get.back(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.redAccent.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Widget buildSelectImage() {
    return Center(
      child: GestureDetector(
        onTap: _pickImage,
        child: Container(
          height: 150,
          width: 150,
          decoration: BoxDecoration(
            color: Colors.grey[800],
            borderRadius: BorderRadius.circular(150),
            border: Border.all(color: const Color(0xFF515156),width: 5),
          ),
          child: _selectedImage != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(150),
            child: Image.file(
              _selectedImage!,
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
