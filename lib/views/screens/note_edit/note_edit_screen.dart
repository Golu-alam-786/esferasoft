import 'dart:io';
import 'package:esferasoft/views/screens/home/home_screen.dart';
import 'package:esferasoft/views/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
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
  late TextEditingController _categoryController;
  File? _selectedImage;
  bool completedStatus = false;
  bool completedStatus1 = false;
  var selectedCategory = '';
  var view = AppWidgets();


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
            view.sizedBoxView(height: 16),
            view.textFormFieldView(controller: _titleController,labelText: 'Title'),
            view.sizedBoxView(height: 16),
            view.textFormFieldView(controller: _contentController,labelText: 'Content'),
            view.sizedBoxView(height: 16),
            const Text("Please Select category",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),),
            view.checkBoxListTile(title: "Work", value: completedStatus, onChanged: (value) {
              completedStatus = value ?? false;
              setState(() {});
            },),
            view.checkBoxListTile(title: "Home", value: completedStatus1, onChanged: (value) {
              completedStatus1 = value ?? false;
              setState(() {});
            },),
            view.sizedBoxView(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: view.elevatedButtonView(onPressed: ()async{
                    if (completedStatus && completedStatus1) {
                      selectedCategory = "Work,Home";
                    } else if (completedStatus) {
                      selectedCategory = "Work";
                    } else if (completedStatus1) {
                      selectedCategory = "Home";
                    }
                    final note = NotesModel(
                      id: widget.note?.id,
                      title: _titleController.text,
                      content: _contentController.text,
                      category: selectedCategory,
                      image: _selectedImage?.path,
                      createdAt: widget.note == null
                          ? DateTime.now().toString()
                          : widget.note!.createdAt,
                    );
                    await noteController.updateNote(note, widget.index);
                    Get.offAll(()=>const HomeScreen());
                  }, child: const Text("Save"),backgroundColor: const Color(0xFF515156))
                ),
                // const SizedBox(width: 10),
                view.sizedBoxView(width: 10),
                Expanded(
                  child:view.elevatedButtonView(onPressed: (){
                    Get.back();
                  }, child: const Text("Cancel"),backgroundColor: Colors.redAccent.withOpacity(0.5))
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
    return
      Center(
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
