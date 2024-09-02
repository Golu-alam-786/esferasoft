// import 'package:esferasoft/model/note_model.dart';
// import 'package:esferasoft/views/utils/app_widgets.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'dart:io';
// import '../../controller/database_controller.dart';
//
// class AddNoteScreen extends StatefulWidget {
//   @override
//   _AddNoteScreenState createState() => _AddNoteScreenState();
// }
//
// class _AddNoteScreenState extends State<AddNoteScreen> {
//   final _titleController = TextEditingController();
//   final _contentController = TextEditingController();
//   String? _selectedCategory;
//   File? _selectedImage;
//   var view = AppWidgets();
//   bool completedStatus = false;
//   bool completedStatus1 = false;
//
//
//   final List<String> _categories = ['Work', 'Home'];
//   Future<void> _pickImage() async {
//     final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
//
//     if (pickedFile != null) {
//       setState(() {
//         _selectedImage = File(pickedFile.path);
//       });
//     }
//   }
//
//   Future<void> _addNote() async {
//     if (_titleController.text.isEmpty || _contentController.text.isEmpty || (completedStatus || completedStatus1)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please fill all fields and select an image')),
//       );
//       return;
//     }
//
//     if(completedStatus && completedStatus1){
//       _selectedCategory = "Work,Home";
//     }else if(completedStatus){
//       _selectedCategory ="Work";
//
//     }else if(completedStatus1){
//       _selectedCategory = "Home";
//     }
//
//     NotesModel newNote = NotesModel(
//       title: _titleController.text,
//       content: _contentController.text,
//       category: _selectedCategory,
//       image: _selectedImage?.path,
//       createdAt: DateTime.now().toIso8601String(),
//     );
//
//     await DatabaseService.instance.create(newNote);
//     print("Note added successfully!");
//
//     _titleController.clear();
//     _contentController.clear();
//     setState(() {
//       _selectedCategory = null;
//       _selectedImage = null;
//     });
//     Navigator.pop(context);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1E1E1E),
//       appBar: AppBar(
//         title: const Text('Add Note',style: TextStyle(color: Colors.white),),
//         backgroundColor: const Color(0xFF1E1E1E),
//         iconTheme: const IconThemeData(color: Colors.white),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               buildSelectImage(),
//               const SizedBox(height: 20),
//               view.textFormFieldView(controller: _titleController, hintText: 'Title'),
//               const SizedBox(height: 10),
//               view.textFormFieldView(controller: _contentController, hintText: 'Content',maxLines: 5),
//               const SizedBox(height: 10),
//               // buildDropdownButtonFormField(),
//               Text("Please Select category",style: TextStyle(color: Colors.white),),
//
//               CheckboxListTile(
//               title: Text(
//                 "Work",style: TextStyle(color: Colors.white)
//               ),
//               selected:completedStatus,
//               value: completedStatus,
//               onChanged: (bool? value) {
//                 completedStatus = value ?? false;
//                 setState(() {});
//               },
//             ),
//               CheckboxListTile(
//                 title: Text(
//                   "Home",style: TextStyle(color: Colors.white)
//                 ),
//                 selected:completedStatus1,
//                 value: completedStatus1,
//                 onChanged: (bool? value) {
//                   completedStatus1 = value ?? false;
//                   setState(() {});
//                 },
//               ),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _addNote,
//                 child: const Text('Save Note'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
//
//   Padding buildDropdownButtonFormField() {
//     return Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: DropdownButtonFormField<String>(
//                 value: _selectedCategory,
//                 decoration: const InputDecoration(
//                   labelText: 'Category',
//                   labelStyle: TextStyle(color: Colors.white),
//                   border: OutlineInputBorder(),
//                 ),
//                 items: _categories.map((category) {
//                   return DropdownMenuItem(
//                     value: category,
//                     child: Text(
//                       category,
//                       style: const TextStyle(color: Colors.white),
//                     ),
//                   );
//                 }).toList(),
//                 onChanged: (value) {
//                   setState(() {
//                     _selectedCategory = value;
//                   });
//                 },
//                 style: const TextStyle(color: Colors.white),
//                 dropdownColor: Colors.black,
//               ),
//             );
//   }
//   Container buildSelectImage() {
//     return Container(
//               height: 150,
//               width: 150,
//               decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(100, ),
//                   color: Colors.red,
//               ),
//               child: _selectedImage != null
//                   ? ClipRRect(
//                 borderRadius: BorderRadius.circular(100),
//                   child: Image.file(_selectedImage!,fit: BoxFit.cover,))
//                   : IconButton(onPressed: (){_pickImage();}, icon: const Icon(Icons.image))
//             );
//   }
// }
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/note_controller.dart';
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
              buildSelectImage(),
              const SizedBox(height: 20),
              view.textFormFieldView(controller: noteController.titleController, hintText: 'Title'),
              const SizedBox(height: 10),
              view.textFormFieldView(
                  controller: noteController.contentController,
                  hintText: 'Content',
                  maxLines: 5),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align( alignment: Alignment.topLeft,child: const Text("Please Select category", style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16))),
              ),
              Obx(() => CheckboxListTile(

                title: const Text("Work", style: TextStyle(color: Colors.white)),
                value: noteController.completedStatus.value,
                onChanged: (bool? value) {
                  noteController.completedStatus.value = value ?? false;
                },
              )),
              Obx(() => CheckboxListTile(
                title: const Text("Home", style: TextStyle(color: Colors.white)),
                value: noteController.completedStatus1.value,
                onChanged: (bool? value) {
                  noteController.completedStatus1.value = value ?? false;
                },
              )),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF515156),fixedSize: Size(280, 50),shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: noteController.addNote,
                child: const Text('Save Note',style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildSelectImage() {
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
          child: Image.file(noteController.selectedImage.value!, fit: BoxFit.cover))
          : IconButton(
        onPressed: noteController.pickImage,
        icon: const Icon(Icons.image,color: Colors.white,size: 70,),
      ),
    ));
  }
}
