import 'package:flutter/material.dart';
import 'package:radio_undira/view/in_app_browser.dart';

import 'home_view.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({Key? key}) : super(key: key);

  @override
  _DashboardViewState createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  int _selectedIndex = 0;
  List<int> loadedPages = [
    0,
  ];
  List<Widget> _getListScreen() {
    return [
      const HomeView(),
      loadedPages.contains(1)
          ? const InAppWebViewExampleScreen(
              initialUrl: "https://www.undira.ac.id",
            )
          : const SizedBox(),
      loadedPages.contains(2)
          ? const Scaffold(
              body: Center(child: Text('Video')),
            )
          : const SizedBox(),
    ];
  }

  void _onItemTapped(int index) {
    if (!loadedPages.contains(index)) {
      loadedPages.add(index);
    }
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _listScreen = _getListScreen();
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _listScreen,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.web),
            label: 'UNDIRA',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.video_collection_rounded),
            label: 'Video',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
