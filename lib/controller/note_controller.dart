import 'package:get/get.dart';
import '../model/note_model.dart';
import 'database_controller.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';

class NoteController extends GetxController {
  RxInt _selectedTabIndex = 0.obs;
  int get selectedTabIndex => _selectedTabIndex.value;
  updateTabIndex(int index) => _selectedTabIndex.value = index;

  var notes = <NotesModel>[].obs;
  var filteredNotes = <NotesModel>[].obs;
  RxString screenName = "All Notes".obs;

  final titleController = TextEditingController();
  final contentController = TextEditingController();
  var selectedCategory = ''.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  var isWorkCheckValue = false.obs;
  var isHomeCheckValue = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotes();
  }

  Future<void> fetchNotes() async {
    try {
      final fetchedNotes = await DatabaseController.instance.readAllNotes();
      notes.assignAll(fetchedNotes);
      filteredNotes.addAll(fetchedNotes);
    } catch (e) {
      Get.snackbar('Error', 'Failed to fetch notes: $e', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    }
  }

  Future<void> updateNotesByCategory() async {
    try {
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
    } catch (e) {
      Get.snackbar('Error', 'Failed to filter notes: $e', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    }
  }

  Future<void> addNote() async {
    if (titleController.text.isEmpty ||
        contentController.text.isEmpty ||
        selectedImage.value == null ||
        !(isWorkCheckValue.value || isHomeCheckValue.value)) {
      Get.snackbar('Error', 'Please fill all fields and select an image', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
      return;
    }

    try {
      if (isWorkCheckValue.value && isHomeCheckValue.value) {
        selectedCategory.value = "Work,Home";
      } else if (isWorkCheckValue.value) {
        selectedCategory.value = "Work";
      } else if (isHomeCheckValue.value) {
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
    } catch (e) {
      Get.snackbar('Error', 'Failed to add note: $e', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to pick image: $e', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    }
  }

  Future<void> updateNote(NotesModel note, int index) async {
    try {
      await DatabaseController.instance.update(note);
      filteredNotes[index] = note;
      notes[index] = note;
    } catch (e) {
      Get.snackbar('Error', 'Failed to update note: $e', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    }
  }

  Future<void> deleteNote(int id) async {
    try {
      await DatabaseController.instance.delete(id);
      updateNotesByCategory();
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete note: $e', backgroundColor: Colors.red.withOpacity(0.5), colorText: Colors.white);
    }
  }
}
