import 'package:chart_tuto/views/chart.dart';
import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
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
          //backgroundColor: Colors.green,
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
                              builder: (context) => ShowIngredients(
                                  library[index]['id'],
                                  library[index]['name'])));
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
                            _RecipeId(library[index]['id']),
                            Container(
                              height: 4,
                            ),
                            _RecipeState(library[index]['draft'])
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
        floatingActionButton: Stack(
          children: <Widget>[
            Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveRecipe()),
                  );
                },
              //icon: Icon(Icons.add),
              label: Text('New Recipe'),
              backgroundColor: Colors.green,
            ),
          ),
            /*Align(
              alignment: Alignment.bottomRight,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => SaveRecipe()),
                  );
                },
                child: Icon(Icons.add),
              ),
            ),*/
          ],
        ));
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

class _RecipeState extends StatelessWidget {
  final int _draft;

  _RecipeState(this._draft);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_draft',
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}


///
///
///

class ShowIngredients extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  ShowIngredients(this._recipeid, this._recipename);

  @override
  ShowIngredientsState createState() {
    return new ShowIngredientsState();
  }
}

class ShowIngredientsState extends State<ShowIngredients> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          //title: Text(widget._recipeid.toString()),
          title: Text(widget._recipename),
          //backgroundColor: Colors.green,
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
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
                    if (snapshot.connectionState == ConnectionState.done) {
                      childCount = snapshot.data.length;
                    }

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
                                      ingredients[index],
                                      widget._recipename)));
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
                    }, childCount: childCount));
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
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                child: Icon(Icons.delete),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 31),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FloatingActionButton(
                heroTag: null,
                onPressed: () {Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Analyse2(widget._recipeid,widget._recipename)),
                );

                },
                child: Icon(Icons.insert_chart),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: FloatingActionButton.extended(
              heroTag: null,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          Foodchoice(widget._recipeid, widget._recipename)),
                );
              },
              //icon: Icon(Icons.add),
              label: Text('Add'+"\n"+'ingredient',textAlign: TextAlign.center,),
              backgroundColor: Colors.green,
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
  double get maxExtent => 0;

  @override
  double get minExtent => 0;
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
