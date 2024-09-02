import 'package:esferasoft/controller/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../note_view_details/note_view_screen.dart';
import 'note_card_widget.dart';

class NotesGridWidget extends StatelessWidget {
  final NoteController noteController;
  const NotesGridWidget({super.key, required this.noteController});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (noteController.filteredNotes.isEmpty) {
        return const Center(
          child: Text(
            'No notes available.',
            style: TextStyle(color: Colors.white54),
          ),
        );
      }
      return Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 0.85,
          ),
          itemCount: noteController.filteredNotes.length,
          itemBuilder: (context, index) {
            final note = noteController.filteredNotes[index];
            return GestureDetector(
              onTap: () {
                Get.to(() => NoteViewScreen(
                  note: note,
                  index: index,
                ));
              },
              child: NoteCardWidget(note: note),
            );
          },
        ),
      );
    },
    );

  }
}
