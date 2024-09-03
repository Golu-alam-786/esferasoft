import 'package:esferasoft/controller/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../add_notes/add_notes_screen.dart';

BottomAppBar bottomNavigationBar({required NoteController noteController}){
  return BottomAppBar(
    color: const Color(0xFF2C2C2E),
    shape: const CircularNotchedRectangle(),
    notchMargin: 8.0,

    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Obx(
              ()=> IconButton(
            style: noteController.selectedTabIndex == 0 ?  IconButton.styleFrom(backgroundColor: const Color(0xFF515156)) : null,
            icon: const Icon(Icons.home, color: Colors.white),
            onPressed: () {
              noteController.updateTabIndex(0);
            },
          ),
        ),
        const SizedBox(width: 20),
        FloatingActionButton(
          mini: true,
          backgroundColor: const Color(0xFF515156),
          onPressed: () {
            noteController.isWorkCheckValue.value = false;
            noteController.isHomeCheckValue.value = false;
            Get.to(() => AddNoteScreen());
          },
          shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        const SizedBox(width: 20),
        Obx(
              ()=> IconButton(
            style: noteController.selectedTabIndex == 2 ?  IconButton.styleFrom(backgroundColor: const Color(0xFF515156)) : null,
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {
              noteController.updateTabIndex(2);
            },
          ),
        ),
      ],
    ),
  );

}