import 'package:chart_tuto/providers/data_provider.dart';
import 'package:flutter/material.dart';

import 'ingredient_saver.dart';

class Foodchoice extends StatelessWidget {

  final int _recipeid;
  final String _recipename;

  Foodchoice(this._recipeid,this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select food type"),
      ),
      body: ListView(
        children: <Widget>[
          _Ingredientitem(
            'Vegetables',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Vegetables(_recipeid,_recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Meat and fish',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Meatandfish(_recipeid,_recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Fruit',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Fruit(_recipeid,_recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Dairy',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dairy(_recipeid,_recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Cereals',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cereals(_recipeid,_recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Others',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Others(_recipeid,_recipename),
                  ));
            },
          ),
        ],
      ),
    );
  }
}

class _Ingredientitem extends StatelessWidget {
  final String _text;
  final Function _onTap;

  _Ingredientitem(this._text, this._onTap);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 40.0, bottom: 40, left: 13.0, right: 22.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                _text,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Vegetables extends StatelessWidget {

  final int _recipeid;
  final String _recipename;

  Vegetables(this._recipeid,this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select vegetable"),
      ),
      body: ListView(children: <Widget>[
        _Ingredientitem('Vegetable 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {'name': 'vegetable 1', 'recipe_id': _recipeid.toString()},_recipename,
                      )));
        })
      ]),
    );
  }
}

class Meatandfish extends StatelessWidget {

  final int _recipeid;
  final String _recipename;

  Meatandfish(this._recipeid,this._recipename);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Meat or fish"),
      ),
      body: ListView(children: <Widget>[
        _Ingredientitem('Meat 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {'name': 'meat 1', 'recipe_id': _recipeid.toString()}, _recipename,
                      )));
        })
      ]),
    );
  }
}

class Fruit extends StatelessWidget {

  final int _recipeid;
  final String _recipename;

  Fruit(this._recipeid,this._recipename);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select fruit"),
      ),
      body: ListView(children: <Widget>[
        _Ingredientitem('Fruit 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {'name': 'fruit 1', 'recipe_id': _recipeid.toString()},_recipename,
                      )));
        })
      ]),
    );
  }
}

class Dairy extends StatelessWidget {

  final int _recipeid;
  final String _recipename;

  Dairy(this._recipeid,this._recipename);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Dairy product"),
      ),
      body: ListView(children: <Widget>[
        _Ingredientitem('Dairy 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {'name': 'dairy 1', 'recipe_id': _recipeid.toString()},_recipename,
                      )));
        })
      ]),
    );
  }
}

class Cereals extends StatelessWidget {

  final int _recipeid;
  final String _recipename;

  Cereals(this._recipeid,this._recipename);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select cereal"),
      ),
      body: ListView(children: <Widget>[
        _Ingredientitem('Cereal 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {'name': 'cereal 1', 'recipe_id': _recipeid.toString()},_recipename,
                      )));
        })
      ]),
    );
  }
}

class Others extends StatelessWidget {

  final int _recipeid;
  final String _recipename;
  Others(this._recipeid,this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select other"),
      ),
      body: ListView(children: <Widget>[
        _Ingredientitem('Other 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {'name': 'other 1', 'recipe_id': _recipeid.toString()},_recipename,
                      )));
        })
      ]),
    );
  }
}
