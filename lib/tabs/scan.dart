import 'package:flutter/material.dart';

class Scan extends StatelessWidget {
  const Scan({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Scan"),
          backgroundColor: Colors.green,
        ),
        body: MyWidget());
  }
}

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: CustomScrollView(
      slivers: <Widget>[
        SliverPersistentHeader(
          pinned: true,
          delegate: MyDynamicHeader(),
        ),
        SliverList(delegate: SliverChildBuilderDelegate(
          (BuildContext context, int index) {
            return Container(
              height: 20,
              color: Colors.red,
            );
          },
        ))
      ],
    )));
  }
}

class MyDynamicHeader extends SliverPersistentHeaderDelegate {
  int index = 0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[index];

      //if (++index > Colors.primaries.length - 1) index = 0;

      return Container(
          decoration: BoxDecoration(color: Colors.blue),
          height: constraints.maxHeight,
          child: SafeArea(
            child: Center(
                child: TextField(
              decoration: InputDecoration(hintText: 'Recipe title'),
            )),
          ));
    });
  }

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate _) => true;

  @override
  double get maxExtent => 90.0;

  @override
  double get minExtent => 80.0;
}
