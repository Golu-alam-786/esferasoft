import 'package:esferasoft/views/screens/home/widgets/app_bar_widget.dart';
import 'package:esferasoft/views/screens/home/widgets/bottom_navigation_bar_widget.dart';
import 'package:esferasoft/views/screens/home/widgets/notes_grid_widget.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../../../controller/note_controller.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final NoteController noteController = Get.put(NoteController());

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this)
      ..addListener(() {
        if (_tabController.index == 0) {
          noteController.screenName.value = "All Notes";
        } else if (_tabController.index == 1) {
          noteController.screenName.value = "Work";
        } else {
          noteController.screenName.value = "Home";
        }

        noteController.updateNotesByCategory();
      });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      initialIndex: 0,
      child: Scaffold(
        backgroundColor: const Color(0xFF1E1E1E),
        appBar: appBarWidget(tabController: _tabController, noteController: noteController),
        body: buildTabBarView(),
        bottomNavigationBar: bottomNavigationBar(noteController: noteController),
      ),
    );
  }
  TabBarView buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        NotesGridWidget(noteController: noteController,),
        NotesGridWidget(noteController: noteController,),
        NotesGridWidget(noteController: noteController,),
      ],
    );
  }
}


