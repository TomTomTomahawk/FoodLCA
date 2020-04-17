import 'package:flutter/material.dart';

import 'note.dart';

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
                  builder: (context) => Note(
                        NoteMode.Adding,
                        {'title': 'vegetable 1', 'text': '123'},
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
                  builder: (context) => Note(
                        NoteMode.Adding,
                        {'title': 'meat 1', 'text': '123'},
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
                  builder: (context) => Note(
                        NoteMode.Adding,
                        {'title': 'fruit 1', 'text': '123'},
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
                  builder: (context) => Note(
                        NoteMode.Adding,
                        {'title': 'dairy 1', 'text': '123'},
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
                  builder: (context) => Note(
                        NoteMode.Adding,
                        {'title': 'cereal 1', 'text': '123'},
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
                  builder: (context) => Note(
                        NoteMode.Adding,
                        {'title': 'other 1', 'text': '123'},
                      )));
        })
      ]),
    );
  }
}
