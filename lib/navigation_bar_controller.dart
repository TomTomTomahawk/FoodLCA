import 'package:flutter/material.dart';
import 'tabs/library.dart';
import 'tabs/analyse.dart';
import 'tabs/build.dart';
import 'tabs/scan.dart';
import 'tabs/search.dart';

class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  final List<Widget> pages = [
    Library(
      key: PageStorageKey('Library'),
    ),
    Analyse(
      key: PageStorageKey('Analyse'),
    ),
    Build(
      key: PageStorageKey('Build'),
    ),
    Scan(
      key: PageStorageKey('Scan'),
    ),
    Search(
      key: PageStorageKey('Search'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;



  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.local_library), title: Text('Library')),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), title: Text('Analyse')),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), title: Text('Build')),
          BottomNavigationBarItem(
              icon: Icon(Icons.scanner), title: Text('Scan')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: new Theme(
    data: Theme.of(context).copyWith(
        // sets the background color of the `BottomNavigationBar`
        canvasColor: Colors.brown[900],
        // sets the active color of the `BottomNavigationBar` if `Brightness` is light
        primaryColor: Colors.cyan,
        textTheme: Theme
            .of(context)
            .textTheme
            .copyWith(caption: new TextStyle(color: Colors.white))), // sets the inactive color of the `BottomNavigationBar`
    child: _bottomNavigationBar(_selectedIndex),
  ),
      
      //bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}