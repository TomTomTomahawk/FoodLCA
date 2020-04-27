import 'package:chart_tuto/views/chart.dart';
import 'package:chart_tuto/views/compare_chart.dart';
import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/ingredient_saver.dart';

import 'food_choice.dart';

class CompareList extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  CompareList(this._recipeid,this._recipename);

  @override
  CompareListState createState() {
    return new CompareListState();
  }
}

class CompareListState extends State<CompareList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose a recipe to compare with'),
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
                            builder: (context) =>
                                CompareAnalyse2(widget._recipeid,widget._recipename,library[index]['id'],library[index]['name'])));
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
