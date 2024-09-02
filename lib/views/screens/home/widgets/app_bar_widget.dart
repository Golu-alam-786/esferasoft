import 'package:esferasoft/controller/note_controller.dart';
import 'package:flutter/material.dart';

PreferredSizeWidget appBarWidget({required TabController tabController,required NoteController noteController}){
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
      controller: tabController,
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
