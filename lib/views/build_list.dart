import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/ingredient_saver.dart';

import 'food_choice.dart';
/*

class BuildList extends StatefulWidget {
  @override
  BuildListState createState() {
    return new BuildListState();
  }
}

class BuildListState extends State<BuildList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Build'),
        ),
        body: FutureBuilder(
          future: DataProvider.getIngredientsList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final ingredients = snapshot.data;
              return ListView.builder(
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  SaveIngredient(IngredientMode.Editing, ingredients[index])));
                    },
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _IngredientName(ingredients[index]['name']),
                            Container(
                              height: 4,
                            ),
                            _IngredientRecipeid(ingredients[index]['recipe_id'])
                          ],
                        ),
                      ),
                    ),
                  );
                },
                itemCount: ingredients.length,
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SaveRecipe()),
                    );
                  },
                  child: Icon(Icons.save),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Foodchoice()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        )
        );
  }
}

*/

class BuildList extends StatefulWidget {

  //final String _recipename;

  //BuildList(this._recipename);


  @override
  BuildListState createState() {
    return new BuildListState();
  }
}

class BuildListState extends State<BuildList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Build"),
          backgroundColor: Colors.green,
        ),
        body: Scaffold(
            body: Container(
          child: CustomScrollView(
            slivers: <Widget>[
              SliverPersistentHeader(
                pinned: true,
                delegate: MyDynamicHeader('heya'),//widget._recipename
              ),

              FutureBuilder(
                  future: DataProvider.getIngredientsList(),
                  builder: (context, snapshot) {
                    //final ingredients = snapshot.data;

                    final ingredients = snapshot.data;
                    var childCount = 0;
                    if (snapshot.connectionState == ConnectionState.done)
                      childCount = snapshot.data.length;

                    return SliverList(
                        delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                      if (snapshot.connectionState != ConnectionState.done) {
                        return Center(child: CircularProgressIndicator());
                      }

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaveIngredient(
                                      IngredientMode.Editing,
                                      ingredients[index])));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _IngredientName(ingredients[index]['name']),
                                Container(
                                  height: 4,
                                ),
                                _IngredientRecipeid(
                                    ingredients[index]['recipe_id'])
                              ],
                            ),
                          ),
                        ),
                      );
                    }, childCount: childCount)); //ingredients.length
                  }), //
            ],
          ),
        )),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SaveRecipe()),
                    );
                  },
                  child: Icon(Icons.save),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Foodchoice()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),
          ],
        ));
  }
}

//

//

class MyDynamicHeader extends SliverPersistentHeaderDelegate {
  
  final String _recipename;

  MyDynamicHeader(this._recipename);
  
  int index = 0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[index];

      return Container(
          decoration: BoxDecoration(color: Colors.blue),
          height: constraints.maxHeight,
          child: SafeArea(
            child: Center(
                child: Text('$_recipename')),
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

class _IngredientName extends StatelessWidget {
  final String _name;

  _IngredientName(this._name);

  @override
  Widget build(BuildContext context) {
    return Text(
      _name,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}

class _IngredientRecipeid extends StatelessWidget {
  final int _recipeid;

  _IngredientRecipeid(this._recipeid);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_recipeid',
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

/*
class BuildList extends StatefulWidget {
  @override
  BuildListState createState() {
    return new BuildListState();
  }
}

class BuildListState extends State<BuildList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Build"),
          backgroundColor: Colors.green,
        ),
        body: Scaffold(
            body: Container(
                child: CustomScrollView(
          slivers: <Widget>[
            SliverPersistentHeader(
              pinned: true,
              delegate: MyDynamicHeader(),
            ),
            SliverList(delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FutureBuilder(
                  future: DataProvider.getIngredientsList(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      final ingredients = snapshot.data;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SaveIngredient(
                                      IngredientMode.Editing,
                                      ingredients[index])));
                        },
                        child: Card(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _IngredientName(ingredients[index]['name']),
                                Container(
                                  height: 4,
                                ),
                                _IngredientRecipeid(ingredients[index]['recipe_id'])
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );//
              },
              childCount: ingredients.length,
            ))
          ],
        ))));
  }
}

class MyDynamicHeader extends SliverPersistentHeaderDelegate {
  int index = 0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return LayoutBuilder(builder: (context, constraints) {
      final Color color = Colors.primaries[index];

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
*/
