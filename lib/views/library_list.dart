import 'package:chart_tuto/views/charts/chart.dart';
import 'package:chart_tuto/views/recipe_editer.dart';
import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/ingredient_saver.dart';
import 'food_choice.dart';
import 'ingredient_list.dart';

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
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
            title: Text('My recipes',
                style: TextStyle(color: Colors.white, fontSize: 22)),
            backgroundColor: Color(0xFF162A49)),
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
                      shape: ContinuousRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0),
                        side: BorderSide(
                          color: Colors.black,
                          width: 0.0,
                        ),
                      ),
                      color: Colors.white,
                      child: Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, bottom: 40, left: 13.0, right: 22.0),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(children: <Widget>[
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
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Container(
                height: 60.0,
                width: 60.0,
                child: FittedBox(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  //child: FloatingActionButton.extended(
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => SaveRecipe()),
                      );
                    },
                    //label: Text('New Recipe'),
                    child: Icon(Icons.add, size: 35),
                    backgroundColor: Color(0xFF162A49),
                    /*shape: CircleBorder(
                    side: BorderSide(color: Colors.white.withOpacity(0.7), width: 0.8)),*/
                  ),
                ))),
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
