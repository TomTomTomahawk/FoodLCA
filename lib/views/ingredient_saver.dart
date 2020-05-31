import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';
import 'ingredient_list.dart';

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
            ? 'Add ingredient: ' + widget.ingredient['name']
            : 'Edit ingredient: ' + widget.ingredient['name']),
        backgroundColor: Colors.green[900],
      ),
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: FutureBuilder(
            future: DataProvider.getRecipeMax(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return ListView(children: <Widget>[
                  SizedBox(height: MediaQuery.of(context).size.height * 0.17),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: Text('Ingredient name:',
                                    style: TextStyle(fontSize: 17))),
                            Container(
                                width: MediaQuery.of(context).size.width * 0.46,
                                child: TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    hintText: 'Ingredient name',
                                    fillColor: Colors.white,
                                    filled: true,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.green),
                                    ),
                                  ),
                                )),
                          ]),
                      Container(
                        height: 8,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: Text('Carbon intensity:',
                                    style: TextStyle(fontSize: 17))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17,
                              child: TextField(
                                controller: _carbonintensityController,
                                decoration: InputDecoration(
                                  hintText: 'Carbon intensity',
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
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.03),
                            Text('kg-CO2-eq/kg',
                                style: TextStyle(fontSize: 17)),
                          ]),
                      Container(
                        height: 8,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: Text('Calorie intensity:',
                                    style: TextStyle(fontSize: 17))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17,
                              child: TextField(
                                controller: _calorieintensityController,
                                decoration: InputDecoration(
                                  hintText: 'Calorie intensity',
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
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.08),
                            Text('Calories/kg', style: TextStyle(fontSize: 17)),
                          ]),
                      Container(
                        height: 8,
                      ),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                                width: MediaQuery.of(context).size.width * 0.34,
                                child: Text('Quantity:',
                                    style: TextStyle(fontSize: 17))),
                            SizedBox(
                              width: MediaQuery.of(context).size.width * 0.17,
                              child: TextField(
                                controller: _quantityController,
                                decoration: InputDecoration(
                                  hintText: 'Quantity',
                                  fillColor: Colors.white,
                                  filled: true,
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[900]),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.red[900]),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.17),
                            Text('grams', style: TextStyle(fontSize: 17)),
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
                            final carbonintensity =
                                _carbonintensityController.text;
                            final calorieintensity =
                                _calorieintensityController.text;
                            final quantity = _quantityController.text;

                            if (widget?.ingredientMode ==
                                IngredientMode.Adding) {
                              DataProvider.insertIngredient({
                                'name': name,
                                'carbon_intensity': carbonintensity,
                                'calorie_intensity': calorieintensity,
                                'quantity': quantity,
                                'recipe_id': widget.ingredient['recipe_id']
                              });
                            } else if (widget?.ingredientMode ==
                                IngredientMode.Editing) {
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
                          _Button('Cancel', Colors.grey, () {
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
                                  child:
                                      _Button('Delete', Colors.red, () async {
                                    await DataProvider.deleteIngredient(
                                        widget.ingredient['id']);
                                    Navigator.pop(context);
                                  }),
                                )
                              : Container()
                        ],
                      )
                    ],
                  )
                ]);
              }
              return Container();
            }),
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
