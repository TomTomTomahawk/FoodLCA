import 'package:chart_tuto/views/build_list.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';


class SaveRecipe extends StatefulWidget {

  @override
  SaveState createState() {
    return new SaveState();
  }
}

class SaveState extends State<SaveRecipe> {

  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save food'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(40.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                hintText: 'Recipe title'
              ),
            ),
            Container(height: 16.0,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _Button('Start adding ingredients', Colors.blue, () {
                  final recipename = _nameController.text;

                    DataProvider.insertRecipe({
                      'name': recipename,
                      'draft': 1,
                    });
                  
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuildList()),
                  );
                }),
                Container(height: 16.0,),
                _Button('Discard', Colors.grey, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuildList()),
                  );
                }),
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

