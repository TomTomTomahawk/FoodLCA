import 'package:chart_tuto/views/charts/chart.dart';
import 'package:chart_tuto/views/charts/chartcalorie.dart';
import 'package:chart_tuto/views/charts/chartcarbon.dart';
import 'package:chart_tuto/views/charts/chartmanager.dart';
import 'package:chart_tuto/views/recipe_editer.dart';
import 'package:chart_tuto/views/recipe_saver.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/views/ingredient_saver.dart';
import 'package:flutter/scheduler.dart';
import 'charts/chartcarboncalorie.dart';
import 'compare_list.dart';
import 'food_choice.dart';
import 'package:flutter/cupertino.dart';

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
  final TextEditingController _nameController = TextEditingController();

  void initState() {
    _nameController.text = widget._recipename;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Future<void> _editDialog() async {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Color(0xFF162A49),
            title:
                Text('Edit recipe name', style: TextStyle(color: Colors.white)),
            content: SingleChildScrollView(
                child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: 'Recipe name',
                      fillColor: Colors.white,
                      filled: true,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.green),
                      ),
                    ),
                  ),
                  Container(
                    height: 16.0,
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _Button('Save', Colors.green[900], () {
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            DataProvider.updateRecipe({
                              'id': widget._recipeid,
                              'name': _nameController.text,
                            });
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShowIngredients(
                                      widget._recipeid, _nameController.text)),
                            );
                          });
                        }),
                        SizedBox(width: 10),
                        _Button('Cancel', Colors.grey, () {
                          Navigator.pop(context);
                        }),
                      ])
                ],
              ),
            )),
          );
        },
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(widget._recipename),
          //elevation: 0.0,
          backgroundColor: Color(0xFF162A49),
          leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () =>
                Navigator.of(context).popUntil((route) => route.isFirst),
          ),
        ),
        body: FutureBuilder(
          future: DataProvider.getRecipeIngredientsList(widget._recipeid),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final ingredients = snapshot.data;
              var totalcarbon = 0.0;
              for (var i = 0; i < ingredients.length; i++) {
                totalcarbon = totalcarbon +
                    ingredients[i]['quantity'] *
                        ingredients[i]['carbon_intensity'];
              }

              var totalcalories = 0.0;
              for (var i = 0; i < ingredients.length; i++) {
                totalcalories = totalcalories +
                    ingredients[i]['quantity'] *
                        ingredients[i]['calorie_intensity'] /
                        1000;
              }
              return ListView(
                children: <Widget>[
                  Container(
                    height: 10,
                  ),
                  Text(
                    '  Impact assessment',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 10,
                  ),
                  _SummaryTile(
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.white,
                          child: ChartCarbon(
                              widget._recipeid, widget._recipename)),
                      'Carbon impact',
                      ingredients.length > 0
                          ? totalcarbon.toStringAsFixed(0)
                          : '0',
                      'g-CO2-eq'),
                  _SummaryTile(
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.white,
                          child: ChartCalorie(
                              widget._recipeid, widget._recipename)),
                      'Calories',
                      ingredients.length > 0
                          ? totalcalories.toStringAsFixed(0)
                          : '0',
                      'kcal'),
                  _SummaryTile(
                      Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height * 0.8,
                          color: Colors.white,
                          child: ChartCarbonCalorie(
                              widget._recipeid, widget._recipename)),
                      'Carbon impact per calorie',
                      ingredients.length > 0
                          ? (totalcarbon / totalcalories).toStringAsFixed(2)
                          : '0',
                      'g-CO2-eq/kcal'),
                  Container(height: MediaQuery.of(context).size.height * 0.04),
                  Text(
                    '  Ingredients',
                    textAlign: TextAlign.left,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Container(
                    height: 10,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
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
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border(
                                  bottom: BorderSide(color: Colors.grey))),
                          child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 15, bottom: 15, left: 35.0, right: 0),
                              child: Row(
                                children: <Widget>[
                                  SizedBox(
                                      width: 220,
                                      child: _IngredientName(
                                          ingredients[index]['name'])),
                                  SizedBox(
                                      width: 75,
                                      child: _IngredientQuantity(
                                          ingredients[index]['quantity']
                                              .round())),
                                  SizedBox(
                                    width: 35,
                                  ),
                                  SizedBox(
                                      width: 40,
                                      child: Icon(Icons.arrow_forward_ios,
                                          color: Colors.grey))
                                ],
                              )),
                        ),
                      );
                    },
                    itemCount: ingredients.length,
                  ),
                  ingredients.length == 0
                      ? Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 15, left: 35.0, right: 15.0),
                          child: Text(
                              'The recipe has no ingredients.\nTap the + button to add an ingredient.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600])))
                      : Container(),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.04,
                      color: Colors.grey[300]),
                  Container(
                    color: Colors.grey[300],
                    child: Text(
                      '  Options',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.grey[300]),
                  _OptionButton(Colors.grey, 15.0, 0.0, 'Add ingredient',
                      Icon(Icons.add, size: 30), () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              Foodchoice(widget._recipeid, widget._recipename)),
                    );
                  }),
                  _OptionButton(Colors.transparent, 0.0, 15.0, 'Compare recipe',
                      Icon(Icons.compare_arrows, size: 30), () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CompareList(
                                widget._recipeid, widget._recipename)));
                  }),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.02,
                      color: Colors.grey[300]),
                  _OptionButton(
                    Colors.grey,
                    15.0,
                    0.0,
                    'Edit recipe name',
                    Icon(Icons.edit, size: 30),
                    () {
                      _editDialog();
                    },
                  ),
                  _OptionButton(Colors.transparent, 0.0, 15.0, 'Delete recipe',
                      Icon(Icons.delete, size: 30), () {
                    showCupertinoModalPopup(
                      context: context,
                      builder: (BuildContext context) => CupertinoActionSheet(
                          title: Text(
                              'Are you sure you want to delete ' +
                                  widget._recipename +
                                  '?',
                              style: TextStyle(fontSize: 18)),
                          actions: <Widget>[
                            CupertinoActionSheetAction(
                              child: const Text('Delete',
                                  style: TextStyle(color: Colors.red)),
                              onPressed: () {
                                DataProvider.deleteRecipe(widget._recipeid);

                                Navigator.of(context)
                                    .popUntil((route) => route.isFirst);
                                ;
                              },
                            ),
                          ],
                          cancelButton: CupertinoActionSheetAction(
                            child: const Text('Cancel'),
                            isDefaultAction: true,
                            onPressed: () {
                              Navigator.pop(context, 'Cancel');
                            },
                          )),
                    );
                  }),
                  Container(
                      height: MediaQuery.of(context).size.height * 0.12,
                      color: Colors.grey[300]),
                ],
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
                  alignment: Alignment.bottomRight,
                  child: SizedBox(
                      width: 60,
                      height: 60,
                      child: FloatingActionButton(
                        heroTag: null,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Foodchoice(
                                    widget._recipeid, widget._recipename)),
                          );
                        },
                        child: Icon(Icons.add, size: 35),
                        backgroundColor: Color(0xFF162A49),
                      )),
                )),
          ],
        ));
  }
}

class _IngredientName extends StatelessWidget {
  final String _name;

  _IngredientName(this._name);

  @override
  Widget build(BuildContext context) {
    return Text(
      _name,
      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}

class _IngredientQuantity extends StatelessWidget {
  final int _recipeid;

  _IngredientQuantity(this._recipeid);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_recipeid' + ' g',
      textAlign: TextAlign.right,
      style: TextStyle(color: Colors.grey[800], fontSize: 16),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _SummaryTile extends StatelessWidget {
  final Widget _chart;
  final String _component;
  final String _value;
  final String _unit;

  _SummaryTile(this._chart, this._component, this._value, this._unit);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).copyWith(dividerColor: Colors.transparent);
    return Theme(
        data: theme,
        child: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey))),
            child: Padding(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, left: 15.0, right: 0),
                child: ExpansionTile(
                    title: Text(_component,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.black,
                            fontWeight: FontWeight.bold)),
                    subtitle: Text(_value.toString() + ' ' + _unit,
                        style:
                            TextStyle(fontSize: 18, color: Colors.grey[600])),
                    children: <Widget>[_chart]))));
  }
}

class _OptionButton extends StatelessWidget {
  final Color _bottomborder;
  final double _topinset;
  final double _bottominset;
  final String _text;
  final Icon _icon;
  final Function _onpressed;

  _OptionButton(this._bottomborder, this._topinset, this._bottominset,
      this._text, this._icon, this._onpressed);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      width: MediaQuery.of(context).size.width * 0.5,
      color: Colors.grey[300],
      child: Padding(
        padding: const EdgeInsets.only(top: 0, bottom: 0, left: 20, right: 20),
        child: Container(
            decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: _bottomborder))),
            child: FlatButton(
                onPressed: _onpressed,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(_topinset),
                        topRight: Radius.circular(_topinset),
                        bottomLeft: Radius.circular(_bottominset),
                        bottomRight: Radius.circular(_bottominset))),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(_text,
                          style: TextStyle(fontSize: 20, color: Colors.black)),
                      _icon,
                    ]))),
      ),
    );
  }
}

class _Button extends StatelessWidget {
  final String _text;
  final Color _color;
  final Function _onPressed;

  _Button(this._text, this._color, this._onPressed);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: _onPressed,
      child: Text(
        _text,
        style: TextStyle(color: Colors.white),
      ),
      height: 40,
      minWidth: 100,
      color: _color,
    );
  }
}