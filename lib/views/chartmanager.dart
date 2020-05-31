import 'package:chart_tuto/views/charts/chartcalorie.dart';
import 'package:chart_tuto/views/charts/chartcarbon.dart';
import 'package:chart_tuto/views/charts/chartcarboncalorie.dart';
import 'package:flutter/material.dart';

import 'package:chart_tuto/views/compare_list.dart';

class ChartManager extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  ChartManager(this._recipeid, this._recipename);

  @override
  _ChartManagerState createState() => _ChartManagerState();
}

class _ChartManagerState extends State<ChartManager> {
  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.cloud_circle), title: Text('Carbon')),
          BottomNavigationBarItem(
              icon: Icon(Icons.compare_arrows), title: Text('Calorie')),
          BottomNavigationBarItem(
              icon: Icon(Icons.build), title: Text('CarbCal')),
        ],
      );

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  Widget buildPageView() {
    return Stack(children: <Widget>[
      SizedBox(
          height: 595,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              pageChanged(index);
            },
            children: <Widget>[
              ChartCarbon(widget._recipeid, widget._recipename),
              ChartCalorie(widget._recipeid, widget._recipename),
              ChartCarbonCalorie(widget._recipeid, widget._recipename),
            ],
          )),
      Align(
          alignment: Alignment(0.02, 0.95),
          child: SizedBox(
              height: 15,
              width: 10,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _selectedIndex == 0 ? Colors.black : Colors.grey)))),
      Align(
          alignment: Alignment(0.09, 0.95),
          child: SizedBox(
              height: 15,
              width: 10,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _selectedIndex == 1 ? Colors.black : Colors.grey)))),
      Align(
          alignment: Alignment(0.16, 0.95),
          child: SizedBox(
              height: 15,
              width: 10,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _selectedIndex == 2 ? Colors.black : Colors.grey)))),
    ]);
  }

//color: _selectedIndex == 0 ? Colors.blue : Colors.red
  @override
  void initState() {
    super.initState();
  }

  void pageChanged(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void bottomTapped(int index) {
    setState(() {
      _selectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysing ' + widget._recipename),
        backgroundColor: Colors.green[900],
      ),
      body: buildPageView(),
      floatingActionButton: Stack(
          children: <Widget>[
            Align(
              alignment: Alignment.bottomRight,
              child: SizedBox(
                  height: 60,
                  width: 60,
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CompareList(
                                  widget._recipeid, widget._recipename)));
                    },
                    child: Icon(Icons.compare_arrows, size: 32),
                    backgroundColor: Colors.black,
                  )),
            ),
          ],
        )
    );
  }
}
