import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import '../model/note_model.dart';
import 'database_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class NoteController extends GetxController {
  RxInt _selectedTabIndex = 0.obs;
  int get selectedTabIndex => _selectedTabIndex.value;
  updateTabIndex(int index)=>_selectedTabIndex.value = index;
  var notes = <NotesModel>[].obs;
  var filteredNotes = <NotesModel>[].obs;
  RxString screenName = "All Notes".obs;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  var selectedCategory = ''.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  var completedStatus = false.obs;
  var completedStatus1 = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    final fetchedNotes = await DatabaseController.instance.readAllNotes();
    notes.assignAll(fetchedNotes);
    filteredNotes.addAll(fetchedNotes);
  }

  Future<void> updateNotesByCategory() async {
    if (screenName.value == "All Notes") {
      final fetchedNotes = await DatabaseController.instance.readAllNotes();
      notes.clear();
      filteredNotes.clear();
      notes.assignAll(fetchedNotes);
      filteredNotes.addAll(fetchedNotes);
    } else if (screenName.value == "Work") {
      filteredNotes.clear();
      filteredNotes.addAll(
          notes.where((element) => element.category?.contains("Work") == true).toList());
    } else {
      filteredNotes.clear();
      filteredNotes.addAll(
          notes.where((element) => element.category?.contains("Home") == true).toList());
    }
  }

  Future<void> addNote() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        selectedImage.value == null ||
        !(completedStatus.value || completedStatus1.value)) {
      Get.snackbar('Error', 'Please fill all fields and select an image',backgroundColor: Colors.red.withOpacity(0.5),colorText: Colors.white);
      return;
    }

    if (completedStatus.value && completedStatus1.value) {
      selectedCategory.value = "Work,Home";
    } else if (completedStatus.value) {
      selectedCategory.value = "Work";
    } else if (completedStatus1.value) {
      selectedCategory.value = "Home";
    }

    NotesModel newNote = NotesModel(
      title: titleController.text,
      content: contentController.text,
      category: selectedCategory.value,
      image: selectedImage.value?.path,
      createdAt: DateTime.now().toIso8601String(),
    );

    await DatabaseController.instance.create(newNote);
    updateNotesByCategory();
    titleController.clear();
    contentController.clear();
    selectedImage.value = null;
    selectedCategory.value = '';
    Get.back();
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      selectedImage.value = File(pickedFile.path);
    }
  }

  // Other CRUD operations
  Future<void> updateNote(NotesModel note, int index) async {

    await DatabaseController.instance.update(note);
    filteredNotes[index] = note;
    notes[index] = note;


  }

  Future<void> deleteNote(int id) async {
    await DatabaseController.instance.delete(id);
    updateNotesByCategory();
  }
}
