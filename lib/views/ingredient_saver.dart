import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';

enum IngredientMode {
  Editing,
  Adding
}

class SaveIngredient extends StatefulWidget {

  final IngredientMode ingredientMode;
  final Map<String, dynamic> ingredient;

  SaveIngredient(this.ingredientMode, this.ingredient);

  @override
  IngredientState createState() {
    return new IngredientState();
  }
}

class IngredientState extends State<SaveIngredient> {

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _recipeidController = TextEditingController();
  
  List<Map<String, String>> get _ingredients => BuildInheritedWidget.of(context).ingredients;

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
        title: Text(
          widget.ingredientMode == IngredientMode.Adding ? 'Add ingredient' : 'Edit ingredient'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Ingredient name'
              ),
            ),
            Container(height: 8,),
            TextField(
              controller: _recipeidController,
              decoration: InputDecoration(
                hintText: 'Recipe id'
              ),
            ),
            Container(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _Button('Save', Colors.blue, () {
                  final name = _nameController.text;
                  final recipeid = _recipeidController.text;

                  if (widget?.ingredientMode == IngredientMode.Adding) {
                    DataProvider.insertIngredient({
                      'name': name,
                      'recipe_id': recipeid
                    });
                  } else if (widget?.ingredientMode == IngredientMode.Editing) {
                    DataProvider.updateIngredient({
                      'id': widget.ingredient['id'],
                      'name': _nameController.text,
                      'recipe_id': _recipeidController.text,
                    });
                  }
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
                Container(height: 16.0,),
                _Button('Discard', Colors.grey, () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                }),
                widget.ingredientMode == IngredientMode.Editing ?
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: _Button('Delete', Colors.red, () async {
                      await DataProvider.deleteIngredient(widget.ingredient['id']);
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

