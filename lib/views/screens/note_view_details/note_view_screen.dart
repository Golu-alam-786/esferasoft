import 'package:esferasoft/views/screens/note_view_details/widgets/get_content_and_title_widget.dart';
import 'package:esferasoft/views/screens/note_view_details/widgets/get_image_widget.dart';
import 'package:esferasoft/views/utils/app_widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controller/note_controller.dart';
import '../../../model/note_model.dart';
import '../note_edit/note_edit_screen.dart';

class NoteViewScreen extends StatelessWidget {
  final NotesModel note;
  final int index;
  final NoteController noteController = Get.find();

  NoteViewScreen({required this.note, required this.index});

  @override
  Widget build(BuildContext context) {
    const String defaultImage = 'assets/image/boy_image.png';
    var view = AppWidgets();
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
            GetImageWidget(note: note),
            GetContentAndTitleWidget(title: "Title", data: note.title ?? "",),
            const SizedBox(height: 8.0),
            GetContentAndTitleWidget(title: "Content", data: note.content ?? "",),
            const SizedBox(height: 8.0),
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Text(
                'Category :   ${note.category?.isNotEmpty == true ? note.category! : "Not selected"}',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  view.elevatedButtonView(onPressed: (){
                    if(note.category?.contains("Work") == true){
                      noteController.isWorkCheckValue.value = true;
                    }else{
                      noteController.isWorkCheckValue.value = false;
                    }
                    if(note.category?.contains("Home") == true){
                      noteController.isHomeCheckValue.value = true;
                    }else{
                      noteController.isHomeCheckValue.value = false;
                    }
                    Get.to(() => NoteEditScreen(
                      note: note,
                      index: index,
                    ));
                  }, child: const Text('Edit',style: TextStyle(color: Colors.white)),backgroundColor: const Color(0xFF515156)
                  ),
                  view.sizedBoxView(width: 12.0),
                  view.elevatedButtonView(onPressed: (){
                    noteController.deleteNote(note.id!);
                    Get.back();
                  }, child: const Text("Delete",style: TextStyle(color: Colors.white),),backgroundColor: Colors.redAccent.withOpacity(0.5))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
