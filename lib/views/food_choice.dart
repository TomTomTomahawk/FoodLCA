import 'package:chart_tuto/providers/data_provider.dart';
import 'package:flutter/material.dart';

import 'ingredient_saver.dart';

class Foodchoice extends StatelessWidget {
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
                    builder: (context) => Vegetables(),
                  ));
            },
          ),
          _Ingredientitem(
            'Meat and fish',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Meatandfish(),
                  ));
            },
          ),
          _Ingredientitem(
            'Fruit',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Fruit(),
                  ));
            },
          ),
          _Ingredientitem(
            'Dairy',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dairy(),
                  ));
            },
          ),
          _Ingredientitem(
            'Cereals',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cereals(),
                  ));
            },
          ),
          _Ingredientitem(
            'Others',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Others(),
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
                        {'name': 'vegetable 1', 'recipe_id': '10'},
                      )));
        })
      ]),
    );
  }
}

class Meatandfish extends StatelessWidget {
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
                        {'name': 'meat 1', 'recipe_id': '10'},
                      )));
        })
      ]),
    );
  }
}

class Fruit extends StatelessWidget {
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
                        {'name': 'fruit 1', 'recipe_id': '10'},
                      )));
        })
      ]),
    );
  }
}

class Dairy extends StatelessWidget {
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
                        {'name': 'dairy 1', 'recipe_id': '10'},
                      )));
        })
      ]),
    );
  }
}

class Cereals extends StatelessWidget {
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
                        {'name': 'cereal 1', 'recipe_id': '10'},
                      )));
        })
      ]),
    );
  }
}

class Others extends StatelessWidget {
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
                        {'name': 'other 1', 'recipe_id': '10'},
                      )));
        })
      ]),
    );
  }
}
