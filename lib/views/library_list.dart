import 'package:chart_tuto/views/chart.dart';
import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/ingredient_saver.dart';
import 'food_choice.dart';

//https://www.pexels.com/photo/fruits-eating-food-on-wood-326268/

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
          backgroundColor: Colors.brown[900],
        ),
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage("images/board6.jpg"), fit: BoxFit.cover)),
            child: FutureBuilder(
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
                                  top: 30.0,
                                  bottom: 30,
                                  left: 13.0,
                                  right: 22.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Row(children: <Widget>[
                                      GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              DataProvider.deleteRecipe(
                                                  library[index]['id']);
                                            });
                                          },
                                          child: Icon(Icons.delete,
                                              color: Colors.red[900])),
                                      SizedBox(width: 20),
                                      _RecipeName(library[index]['name'])
                                    ]),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey)
                                  ])),
                        ),
                      );
                    },
                    itemCount: library.length,
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            )),
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
                label: Text('New Recipe'),
                backgroundColor: Colors.green[900],
              ),
            ),
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
          backgroundColor: Colors.brown[900],
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
                                  top: 30.0,
                                  bottom: 30,
                                  left: 13.0,
                                  right: 22.0),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        _IngredientName(
                                            ingredients[index]['name']),
                                        Container(
                                          height: 4,
                                        ),
                                        _IngredientQuantity(ingredients[index]
                                                ['quantity']
                                            .round())
                                      ],
                                    ),
                                    Icon(Icons.arrow_forward_ios,
                                        color: Colors.grey)
                                  ])),
                        ),
                      );
                    }, childCount: childCount));
                  }),
            ],
          ),
        )),
        floatingActionButton: Stack(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 31),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: FloatingActionButton.extended(
                  heroTag: null,
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Analyse2(widget._recipeid, widget._recipename)),
                    );
                  },
                  label: Text(
                    'Visualize' + "\n" + 'Impacts',
                    textAlign: TextAlign.center,
                  ),
                  backgroundColor: Colors.black,
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.only(left: 31),
                child: Align(
                  alignment: Alignment.bottomRight,
                  child: FloatingActionButton.extended(
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Foodchoice(
                                widget._recipeid, widget._recipename)),
                      );
                    },
                    //icon: Icon(Icons.add),
                    label: Text(
                      'Add' + "\n" + 'ingredient',
                      textAlign: TextAlign.center,
                    ),
                    backgroundColor: Colors.green[900],
                  ),
                )),
          ],
        ));
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

class _IngredientQuantity extends StatelessWidget {
  final int _recipeid;

  _IngredientQuantity(this._recipeid);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_recipeid' + ' grams',
      style: TextStyle(color: Colors.grey[800], fontSize: 16),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}
