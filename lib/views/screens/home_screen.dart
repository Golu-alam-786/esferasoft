import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:esferasoft/model/note_model.dart';
import 'package:esferasoft/views/screens/add_notes_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import '../../controller/note_controller.dart';
import 'note_view_screen.dart';

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
        appBar: buildAppBar(),
        body: buildTabBarView(),
        bottomNavigationBar: buildBottomAppBar(),
      ),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF1E1E1E),
      elevation: 0,
      toolbarHeight: 170,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Good Morning,\n Dimitar!',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                CircleAvatar(
                  radius: 22,
                  backgroundColor: Colors.white,
                  child: Padding(
                    padding: EdgeInsets.all(6.0),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: AssetImage('assets/image/boy_image.png'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF2C2C2E),
                hintText: 'Search',
                hintStyle: const TextStyle(color: Colors.white),
                prefixIcon: const Icon(Icons.search, color: Colors.white),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 10.0),
              ),
            ),
          ],
        ),
      ),
      bottom: TabBar(
        controller: _tabController,
        onTap: (tabIndex) {
          if (tabIndex == 0) {
            noteController.screenName.value = "All Notes";
          } else if (tabIndex == 1) {
            noteController.screenName.value = "Work";
          } else {
            noteController.screenName.value = "Home";
          }

          noteController.updateNotesByCategory();
        },
        labelColor: Colors.white,
        unselectedLabelColor: Colors.grey,
        indicatorColor: Colors.yellowAccent,
        indicatorSize: TabBarIndicatorSize.tab,
        dividerColor: Colors.transparent,
        indicatorWeight: 3,
        tabs: const [
          Tab(
            text: 'All Notes',
          ),
          Tab(text: 'Work'),
          Tab(text: 'Home'),
        ],
      ),
    );
  }

  TabBarView buildTabBarView() {
    return TabBarView(
      controller: _tabController,
      children: [
        buildNotesGrid(),
        buildNotesGrid(),
        buildNotesGrid(),
      ],
    );
  }

  BottomAppBar buildBottomAppBar() {
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
              noteController.completedStatus.value = false;
              noteController.completedStatus1.value = false;
              Get.to(() => AddNoteScreen());
            },
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(150)),
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 20), // Space for the FAB
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

  Widget buildNotesGrid() {
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
              child: buildNoteCard(note: note),
            );
          },
        ),
      );
    });
  }

}

const String defaultImage = 'assets/image/boy_image.png';

Container buildNoteCard({required NotesModel note}) {
  return Container(
    decoration: BoxDecoration(
      color: note.category == 'Work'
          ? Color(0xffd6db3e)
          : const Color(0xFFD5D4D4),
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.2),
          blurRadius: 5,
          offset: const Offset(2, 2),
        ),
      ],
    ),
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            note.title ?? "No Title",
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 10),
          Text(
            formatDate(note.createdAt),
            style: const TextStyle(
                color: Colors.black54,
                fontSize: 12,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          PhysicalModel(
            color: Colors.white,
            shape: BoxShape.circle,
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(150),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: note.image != null && note.image!.startsWith('http')
                      ? CachedNetworkImage(
                          imageUrl: note.image!,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CupertinoActivityIndicator(),
                          errorWidget: (context, url, error) =>
                              Image.asset(defaultImage, fit: BoxFit.cover),
                        )
                      : (note.image != null && File(note.image!).existsSync()
                          ? Image.file(
                              File(note.image!),
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(defaultImage, fit: BoxFit.cover),
                            )
                          : Image.asset(defaultImage, fit: BoxFit.cover)),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

String formatDate(String? dateString) {
  try {
    if (dateString == null) return "Unknown date";
    DateTime date = DateTime.parse(dateString);
    return DateFormat('MMM dd yyyy').format(date);
  } catch (e) {
    return "Invalid date";
  }
}
