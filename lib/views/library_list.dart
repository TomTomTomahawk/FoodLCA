import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/inherited_widgets/library_inherited_widget.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/ingredient_saver.dart';

import 'food_choice.dart';

class LibraryList extends StatefulWidget {
  @override
  LibraryListState createState() {
    return new LibraryListState();
  }
}

class LibraryListState extends State<LibraryList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library'),
      ),
      body: FutureBuilder(
        future: DataProvider.getLibraryList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final library = snapshot.data;
            return ListView.builder(
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                _ShowIngredients(library[index]['id'])));
                  },
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _RecipeName(library[index]['name']),
                          Container(
                            height: 4,
                          ),
                          _RecipeId(library[index]['id'])
                        ],
                      ),
                    ),
                  ),
                );
              },
              itemCount: library.length,
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class _RecipeName extends StatelessWidget {
  final String _name;

  _RecipeName(this._name);

  @override
  Widget build(BuildContext context) {
    return Text(
      _name,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}

class _RecipeId extends StatelessWidget {
  final int _id;

  _RecipeId(this._id);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_id',
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _ShowIngredients extends StatefulWidget {
  final int _recipeid;

  _ShowIngredients(this._recipeid);

  @override
  _ShowIngredientsState createState() {
    return new _ShowIngredientsState();
  }
}

class _ShowIngredientsState extends State<_ShowIngredients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Library"),
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

              FutureBuilder(
                  future:
                      DataProvider.getRecipeIngredientsList(widget._recipeid),
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
        floatingActionButton: Stack(children: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  DataProvider.deleteRecipe(widget._recipeid);
                  Navigator.pop(context);
                },
                child: Icon(Icons.delete),
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
        ]));
  }
}

//

//

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
