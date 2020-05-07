import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';

enum IngredientMode { Editing, Adding }

class SaveIngredient extends StatefulWidget {
  final IngredientMode ingredientMode;
  final Map<String, dynamic> ingredient;
  final String _recipename;

  SaveIngredient(this.ingredientMode, this.ingredient, this._recipename);

  @override
  IngredientState createState() {
    return new IngredientState();
  }
}

class IngredientState extends State<SaveIngredient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _carbonintensityController =
      TextEditingController();
  final TextEditingController _calorieintensityController =
      TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  //final TextEditingController _unitController = TextEditingController();

  List<Map<String, String>> get _ingredients =>
      BuildInheritedWidget.of(context).ingredients;

  @override
  void didChangeDependencies() {
    _nameController.text = widget.ingredient['name'];
    _carbonintensityController.text =
        widget.ingredient['carbon_intensity'].toString();
    _calorieintensityController.text =
        widget.ingredient['calorie_intensity'].toString();
    _quantityController.text = widget.ingredient['quantity'].toString();
    //_unitController.text = widget.ingredient['unit'];

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingredientMode == IngredientMode.Adding
            ? 'Add ingredient'
            : 'Edit ingredient'),
        backgroundColor: Colors.brown[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Ingredient name:'),
                  Container(
                      width: 200,
                      child: TextField(
                        controller: _nameController,
                        decoration:
                            InputDecoration(hintText: 'Ingredient name'),
                      )),
                ]),
            Container(
              height: 8,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Carbon intensity:'),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _carbonintensityController,
                      decoration: InputDecoration(hintText: 'Carbon intensity'),
                    ),
                  ),
                  Text('kg-CO2-eq/kg'),
                ]),
            Container(
              height: 8,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Calorie intensity:'),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _calorieintensityController,
                      decoration:
                          InputDecoration(hintText: 'Calorie intensity'),
                    ),
                  ),
                  Text('Calories/kg'),
                ]),
            Container(
              height: 8,
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Insert quantity:'),
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _quantityController,
                      decoration: InputDecoration(hintText: 'Quantity'),
                    ),
                  ),
                  Text('grams'),
                  /*
                  Container(
                    width: 50,
                    child: TextField(
                      controller: _unitController,
                      decoration: InputDecoration(hintText: 'Unit'),
                    ),
                  ),*/
                ]),
            Container(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _Button('Save', Colors.green[900], () {
                  final name = _nameController.text;
                  final carbonintensity = _carbonintensityController.text;
                  final calorieintensity = _calorieintensityController.text;
                  final quantity = _quantityController.text;

                  if (widget?.ingredientMode == IngredientMode.Adding) {
                    DataProvider.insertIngredient({
                      'name': name,
                      'carbon_intensity': carbonintensity,
                      'calorie_intensity': calorieintensity,
                      'quantity': quantity,
                      'recipe_id': widget.ingredient['recipe_id']
                    });
                  } else if (widget?.ingredientMode == IngredientMode.Editing) {
                    DataProvider.updateIngredient({
                      'id': widget.ingredient['id'],
                      'name': _nameController.text,
                      'carbon_intensity': carbonintensity,
                      'calorie_intensity': calorieintensity,
                      'quantity': quantity,
                      'recipe_id': widget.ingredient['recipe_id'],
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowIngredients(
                            widget.ingredient['recipe_id'],
                            widget._recipename)),
                  );
                }),
                Container(
                  height: 16.0,
                ),
                _Button('Discard', Colors.grey, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ShowIngredients(
                            widget.ingredient['recipe_id'],
                            widget._recipename)),
                  );
                }),
                widget.ingredientMode == IngredientMode.Editing
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _Button('Delete', Colors.red, () async {
                          await DataProvider.deleteIngredient(
                              widget.ingredient['id']);
                          Navigator.pop(context);
                        }),
                      )
                    : Container()
              ],
            )
          ],
        ),
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

/*
import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';

enum IngredientMode { Editing, Adding }

class SaveIngredient extends StatefulWidget {
  final IngredientMode ingredientMode;
  final Map<String, dynamic> ingredient;
  final String _recipename;

  SaveIngredient(this.ingredientMode, this.ingredient, this._recipename);

  @override
  IngredientState createState() {
    return new IngredientState();
  }
}

class IngredientState extends State<SaveIngredient> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _recipeidController = TextEditingController();

  List<Map<String, String>> get _ingredients =>
      BuildInheritedWidget.of(context).ingredients;
  
  @override
  void didChangeDependencies() {
    //if (widget.ingredientMode == IngredientMode.Editing) {
    _nameController.text = widget.ingredient['name'];
    _recipeidController.text = widget.ingredient['recipe_id'].toString();
    //}
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.ingredientMode == IngredientMode.Adding
            ? 'Add ingredient'
            : 'Edit ingredient'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: 'Ingredient name'),
            ),
            Container(
              height: 8,
            ),
            TextField(
              controller: _recipeidController,
              decoration: InputDecoration(hintText: 'Recipe id'),
            ),
            Container(
              height: 16.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _Button('Save', Colors.blue, () {
                  final name = _nameController.text;
                  final recipeid = _recipeidController.text;

                  if (widget?.ingredientMode == IngredientMode.Adding) {
                    DataProvider.insertIngredient(
                        {'name': name, 'recipe_id': recipeid});
                  } else if (widget?.ingredientMode == IngredientMode.Editing) {
                    DataProvider.updateIngredient({
                      'id': widget.ingredient['id'],
                      'name': _nameController.text,
                      'recipe_id': _recipeidController.text,
                    });
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowIngredients(int.parse(recipeid),widget._recipename)),
                  );
                }),
                Container(
                  height: 16.0,
                ),
                _Button('Discard', Colors.grey, () {
                  final recipeid = _recipeidController.text;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ShowIngredients(int.parse(recipeid),widget._recipename)),
                  );
                }),
                widget.ingredientMode == IngredientMode.Editing
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: _Button('Delete', Colors.red, () async {
                          await DataProvider.deleteIngredient(
                              widget.ingredient['id']);
                          Navigator.pop(context);
                        }),
                      )
                    : Container()
              ],
            )
          ],
        ),
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

*/
