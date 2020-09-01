import 'package:flutter/material.dart';
import 'comparechartcalorie.dart';
import 'comparechartcarbon.dart';
import 'comparechartcarboncalorie.dart';

class CompareChartManager extends StatefulWidget {
  final int _recipeid;
  final String _recipename;
  final int _comparerrecipeid;
  final String _comparerrecipename;

  CompareChartManager(this._recipeid, this._recipename, this._comparerrecipeid, this._comparerrecipename);

  @override
  _CompareChartManagerState createState() => _CompareChartManagerState();
}

class _CompareChartManagerState extends State<CompareChartManager> {
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
          height: MediaQuery.of(context).size.height - AppBar().preferredSize.height,
          child: PageView(
            controller: pageController,
            onPageChanged: (index) {
              pageChanged(index);
            },
            children: <Widget>[
              CompareChartCarbon(widget._recipeid, widget._recipename,widget._comparerrecipeid, widget._comparerrecipename),
              CompareChartCalorie(widget._recipeid, widget._recipename,widget._comparerrecipeid, widget._comparerrecipename),
              CompareChartCarbonCalorie(widget._recipeid, widget._recipename,widget._comparerrecipeid, widget._comparerrecipename),
            ],
          )),
      Align(
          alignment: Alignment(0.02, 0.95),
          child: SizedBox(
              height: 15,
              width: 10,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _selectedIndex == 0 ? Colors.blue : Colors.grey)))),
      Align(
          alignment: Alignment(0.09, 0.95),
          child: SizedBox(
              height: 15,
              width: 10,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _selectedIndex == 1 ? Colors.blue : Colors.grey)))),
      Align(
          alignment: Alignment(0.16, 0.95),
          child: SizedBox(
              height: 15,
              width: 10,
              child: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: _selectedIndex == 2 ? Colors.blue : Colors.grey)))),
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

  String truncateWithDot(int cutoff, String myString) {
              return (myString.length <= cutoff)
                  ? myString
                  : '${myString.substring(0, cutoff)}.';
            }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Comparing ' + widget._recipename),
        backgroundColor: Color(0xFF162A49),
      ),
      body: buildPageView(),
    );
  }
}
