import 'dart:math';

import 'package:flutter/material.dart';
import 'package:foodlca/providers/data_provider.dart';
import 'ingredient_saver.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Foodchoice extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Foodchoice(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select food type"),
        backgroundColor: Color(0xFF162A49),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(
        children: <Widget>[
          _Ingredientitem(
            'Fruits',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Fruit(_recipeid, _recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Vegetables',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Vegetables(_recipeid, _recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Meat and seafood',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Meatandfish(_recipeid, _recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Dairy and eggs',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dairy(_recipeid, _recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Cereals and bread',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Cereals(_recipeid, _recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'Nuts, seeds, oils and others',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Others(_recipeid, _recipename),
                  ));
            },
          ),
          _Ingredientitem(
            'My recipes',
            () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyRecipes(_recipeid, _recipename),
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
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Padding(
            padding: EdgeInsets.only(
                top: 40,
                bottom: 40,
                left: MediaQuery.of(context).size.width * 0.0852,
                right: MediaQuery.of(context).size.width * 0.0365),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //SizedBox(width: 20),
                            Text(
                              _text,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                          ]),
                    ),
                  ]),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey)
                ])),
      ),
    );
  }
}

class _Ingredientitem2 extends StatelessWidget {
  final String _text;
  final Function _onTap;
  final double _intensity;

  _Ingredientitem2(this._text, this._onTap, this._intensity);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.grey))),
        child: Padding(
            padding: EdgeInsets.only(
                top: 30,
                bottom: 30,
                left: MediaQuery.of(context).size.width * 0.0852,
                right: MediaQuery.of(context).size.width * 0.0365),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(children: <Widget>[
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            //SizedBox(width: 20),
                            Text(
                              _text,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold),
                            ),
                            _RecipeImpact(_intensity.toStringAsFixed(1)),
                          ]),
                    ),
                  ]),
                  Icon(Icons.arrow_forward_ios, color: Colors.grey)
                ])),
      ),
    );
  }
}

class _RecipeImpact extends StatelessWidget {
  final String _impact;

  _RecipeImpact(this._impact);

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(
          height: 15,
          width: 10,
          child: Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _impact == '0'
                      ? Colors.grey[600]
                      : double.parse(_impact) == 0
                          ? Colors.grey[600]
                          : double.parse(_impact) < 4
                              ? Colors.green[600]
                              : (double.parse(_impact) >= 4 &&
                                      double.parse(_impact) < 6)
                                  ? Colors.orange[600]
                                  : Colors.red[600]))),
      Text(
        ' ' + _impact + ' g-CO\u2082-eq / kcal',
        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        overflow: TextOverflow.ellipsis,
      ),
    ]);
  }
}

class Vegetables extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Vegetables(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select vegetable"),
          backgroundColor: Color(0xFF162A49),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: Firestore.instance.collection('vegetables').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final List vegetables_sorted = [];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                vegetables_sorted.add({
                  'name': snapshot.data.documents[i]['name'],
                  'carbonintensity': snapshot.data.documents[i]
                      ['carbonintensity'],
                  'calorieintensity': snapshot.data.documents[i]
                      ['calorieintensity'],
                });
              }

              vegetables_sorted.sort((a, b) {
                return a['name']
                    .toLowerCase()
                    .compareTo(b['name'].toLowerCase());
              });

              return ListView.builder(
                  //itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    /*Text(snapshot.data.documents[index]['name'])*/
                    return _Ingredientitem2(vegetables_sorted[index]['name'],
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveIngredient(
                                    IngredientMode.Adding,
                                    {
                                      'name': vegetables_sorted[index]['name'],
                                      'carbon_intensity':
                                          vegetables_sorted[index]
                                              ['carbonintensity'],
                                      'calorie_intensity':
                                          vegetables_sorted[index]
                                              ['calorieintensity'],
                                      'quantity': '',
                                      'unit': 'g',
                                      'recipe_id': _recipeid
                                    },
                                    _recipename,
                                  )));
                    },
                        vegetables_sorted[index]['carbonintensity'] *
                            1000 /
                            vegetables_sorted[index]['calorieintensity']);
                  });
            }));
  }
}

class Meatandfish extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Meatandfish(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select meat or seafood"),
          backgroundColor: Color(0xFF162A49),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: Firestore.instance.collection('meatandfish').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final List meatandfish_sorted = [];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                meatandfish_sorted.add({
                  'name': snapshot.data.documents[i]['name'],
                  'carbonintensity': snapshot.data.documents[i]
                      ['carbonintensity'],
                  'calorieintensity': snapshot.data.documents[i]
                      ['calorieintensity'],
                });
              }

              meatandfish_sorted.sort((a, b) {
                return a['name']
                    .toLowerCase()
                    .compareTo(b['name'].toLowerCase());
              });
              return ListView.builder(
                  //itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    /*Text(snapshot.data.documents[index]['name'])*/
                    return _Ingredientitem2(meatandfish_sorted[index]['name'],
                        () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveIngredient(
                                    IngredientMode.Adding,
                                    {
                                      'name': meatandfish_sorted[index]['name'],
                                      'carbon_intensity':
                                          meatandfish_sorted[index]
                                              ['carbonintensity'],
                                      'calorie_intensity':
                                          meatandfish_sorted[index]
                                              ['calorieintensity'],
                                      'quantity': '',
                                      'unit': 'g',
                                      'recipe_id': _recipeid
                                    },
                                    _recipename,
                                  )));
                    },
                        meatandfish_sorted[index]['carbonintensity'] *
                            1000 /
                            meatandfish_sorted[index]['calorieintensity']);
                  });
            }));
  }
}

class Fruit extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Fruit(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select fruit"),
          backgroundColor: Color(0xFF162A49),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: Firestore.instance.collection('fruits').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final List fruit_sorted = [];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                fruit_sorted.add({
                  'name': snapshot.data.documents[i]['name'],
                  'carbonintensity': snapshot.data.documents[i]
                      ['carbonintensity'],
                  'calorieintensity': snapshot.data.documents[i]
                      ['calorieintensity'],
                });
              }

              fruit_sorted.sort((a, b) {
                return a['name']
                    .toLowerCase()
                    .compareTo(b['name'].toLowerCase());
              });
              return ListView.builder(
                  //itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    /*Text(snapshot.data.documents[index]['name'])*/
                    return _Ingredientitem2(fruit_sorted[index]['name'], () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveIngredient(
                                    IngredientMode.Adding,
                                    {
                                      'name': fruit_sorted[index]['name'],
                                      'carbon_intensity': fruit_sorted[index]
                                          ['carbonintensity'],
                                      'calorie_intensity': fruit_sorted[index]
                                          ['calorieintensity'],
                                      'quantity': '',
                                      'unit': 'g',
                                      'recipe_id': _recipeid
                                    },
                                    _recipename,
                                  )));
                    },
                        fruit_sorted[index]['carbonintensity'] *
                            1000 /
                            fruit_sorted[index]['calorieintensity']);
                  });
            }));
  }
}

class Dairy extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Dairy(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select dairy product"),
          backgroundColor: Color(0xFF162A49),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: Firestore.instance.collection('dairy').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final List dairy_sorted = [];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                dairy_sorted.add({
                  'name': snapshot.data.documents[i]['name'],
                  'carbonintensity': snapshot.data.documents[i]
                      ['carbonintensity'],
                  'calorieintensity': snapshot.data.documents[i]
                      ['calorieintensity'],
                });
              }

              dairy_sorted.sort((a, b) {
                return a['name']
                    .toLowerCase()
                    .compareTo(b['name'].toLowerCase());
              });
              return ListView.builder(
                  //itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    /*Text(snapshot.data.documents[index]['name'])*/
                    return _Ingredientitem2(dairy_sorted[index]['name'], () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveIngredient(
                                    IngredientMode.Adding,
                                    {
                                      'name': dairy_sorted[index]['name'],
                                      'carbon_intensity': dairy_sorted[index]
                                          ['carbonintensity'],
                                      'calorie_intensity': dairy_sorted[index]
                                          ['calorieintensity'],
                                      'quantity': '',
                                      'unit': 'g',
                                      'recipe_id': _recipeid
                                    },
                                    _recipename,
                                  )));
                    },
                        dairy_sorted[index]['carbonintensity'] *
                            1000 /
                            dairy_sorted[index]['calorieintensity']);
                  });
            }));
  }
}

class Cereals extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Cereals(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select cereal product"),
          backgroundColor: Color(0xFF162A49),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: Firestore.instance.collection('cereals').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final List cereals_sorted = [];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                cereals_sorted.add({
                  'name': snapshot.data.documents[i]['name'],
                  'carbonintensity': snapshot.data.documents[i]
                      ['carbonintensity'],
                  'calorieintensity': snapshot.data.documents[i]
                      ['calorieintensity'],
                });
              }

              cereals_sorted.sort((a, b) {
                return a['name']
                    .toLowerCase()
                    .compareTo(b['name'].toLowerCase());
              });
              return ListView.builder(
                  //itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    /*Text(snapshot.data.documents[index]['name'])*/
                    return _Ingredientitem2(cereals_sorted[index]['name'], () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveIngredient(
                                    IngredientMode.Adding,
                                    {
                                      'name': cereals_sorted[index]['name'],
                                      'carbon_intensity': cereals_sorted[index]
                                          ['carbonintensity'],
                                      'calorie_intensity': cereals_sorted[index]
                                          ['calorieintensity'],
                                      'quantity': '',
                                      'unit': 'g',
                                      'recipe_id': _recipeid
                                    },
                                    _recipename,
                                  )));
                    },
                        cereals_sorted[index]['carbonintensity'] *
                            1000 /
                            cereals_sorted[index]['calorieintensity']);
                  });
            }));
  }
}

/*
class Others extends StatelessWidget {
  final int _recipeid;
  final String _recipename;
  Others(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select other"),
        backgroundColor: Color(0xFF162A49),
      ),
      backgroundColor: Colors.grey[100],
      body: ListView(children: <Widget>[
        _Ingredientitem('Other 1', () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => SaveIngredient(
                        IngredientMode.Adding,
                        {
                          'name': 'other 1',
                          'carbon_intensity': 5,
                          'calorie_intensity': 2000,
                          'quantity': '',
                          'unit': 'g',
                          'recipe_id': _recipeid
                        },
                        _recipename,
                      )));
        })
      ]),
    );
  }
}
*/

class Others extends StatelessWidget {
  final int _recipeid;
  final String _recipename;

  Others(this._recipeid, this._recipename);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Select nut, seed or oil"),
          backgroundColor: Color(0xFF162A49),
        ),
        backgroundColor: Colors.grey[100],
        body: StreamBuilder(
            stream: Firestore.instance.collection('others').snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());

              final List others_sorted = [];
              for (var i = 0; i < snapshot.data.documents.length; i++) {
                others_sorted.add({
                  'name': snapshot.data.documents[i]['name'],
                  'carbonintensity': snapshot.data.documents[i]
                      ['carbonintensity'],
                  'calorieintensity': snapshot.data.documents[i]
                      ['calorieintensity'],
                });
              }

              others_sorted.sort((a, b) {
                return a['name']
                    .toLowerCase()
                    .compareTo(b['name'].toLowerCase());
              });
              return ListView.builder(
                  //itemExtent: 80.0,
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (context, index) {
                    /*Text(snapshot.data.documents[index]['name'])*/
                    return _Ingredientitem2(others_sorted[index]['name'], () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SaveIngredient(
                                    IngredientMode.Adding,
                                    {
                                      'name': others_sorted[index]['name'],
                                      'carbon_intensity': others_sorted[index]
                                          ['carbonintensity'],
                                      'calorie_intensity': others_sorted[index]
                                          ['calorieintensity'],
                                      'quantity': '',
                                      'unit': 'g',
                                      'recipe_id': _recipeid
                                    },
                                    _recipename,
                                  )));
                    },
                        others_sorted[index]['carbonintensity'] *
                            1000 /
                            others_sorted[index]['calorieintensity']);
                  });
            }));
  }
}

class MyRecipes extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  MyRecipes(this._recipeid, this._recipename);

  @override
  MyRecipesState createState() {
    return new MyRecipesState();
  }
}

class MyRecipesState extends State<MyRecipes> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select one of your recipes'),
        backgroundColor: Color(0xFF162A49),
      ),
      backgroundColor: Colors.grey[100],
      body: FutureBuilder(
        future: Future.wait(
            [DataProvider.getLibraryList(), DataProvider.getAllIngredients()]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            final library = snapshot.data[0];
            final allingredients = snapshot.data[1];

            return ListView(children: <Widget>[
              ListView.builder(
                shrinkWrap: true,
                reverse: true,
                physics: ScrollPhysics(),
                itemBuilder: (context, index) {
                  var totalcarbon = 0.0;
                  var totalcalories = 0.0;
                  var totalmass = 0.0;
                  for (var i = 0; i < allingredients.length; i++) {
                    if (allingredients[i]['recipe_id'] ==
                        library[index]['id']) {
                      totalcarbon = totalcarbon +
                          allingredients[i]['quantity'] *
                              allingredients[i]['carbon_intensity'];
                      totalcalories = totalcalories +
                          allingredients[i]['quantity'] *
                              allingredients[i]['calorie_intensity'] /
                              1000;
                      totalmass = totalmass + allingredients[i]['quantity'];
                    }
                  }
                  if (library[index]['id'] != widget._recipeid) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SaveIngredient(
                                      IngredientMode.Adding,
                                      {
                                        'name': library[index]['name'],
                                        'carbon_intensity': roundDouble(
                                            totalcarbon / totalmass, 2),
                                        'calorie_intensity': roundDouble(
                                            (totalcalories / totalmass) * 1000,
                                            2),
                                        'quantity': totalmass.toString(),
                                        'unit': 'g',
                                        'recipe_id': widget._recipeid
                                      },
                                      widget._recipename,
                                    )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Padding(
                            padding: EdgeInsets.only(
                                top: 30,
                                bottom: 30,
                                left:
                                    MediaQuery.of(context).size.width * 0.0852,
                                right:
                                    MediaQuery.of(context).size.width * 0.0365),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.75,
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          _RecipeName(library[index]['name']),
                                          _RecipeImpact(totalcalories == 0
                                              ? '0.0'
                                              : (totalcarbon / totalcalories)
                                                  .toStringAsFixed(1))
                                        ]),
                                  ),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey)
                                ])),
                      ),
                    );
                  }
                  return Container();
                },
                itemCount: library.length,
              ),
              library.length == 1
                  ? Center(
                      child: Column(
                      children: [
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.4),
                        Text('You have no other recipes',
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey[600]))
                      ],
                    ))
                  : Container(),
            ]);
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
      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      overflow: TextOverflow.ellipsis,
    );
  }
}

double roundDouble(double value, int places) {
  double mod = pow(10.0, places);
  return ((value * mod).round().toDouble() / mod);
}
