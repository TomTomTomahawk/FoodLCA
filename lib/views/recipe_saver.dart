import 'package:chart_tuto/views/build_list.dart';
import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';

class SaveRecipe extends StatefulWidget {
  @override
  SaveState createState() {
    return new SaveState();
  }
}

/*
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
                    MaterialPageRoute(builder: (context) => ShowIngredients(11)),
                  );
                }),
                Container(height: 16.0,),
                _Button('Discard', Colors.grey, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LibraryList()),
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
*/

class SaveState extends State<SaveRecipe> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Name your new recipe'),
                    backgroundColor: Colors.brown[900],

        ),
        body: FutureBuilder(
          future: DataProvider.getRecipeMax(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              //return Text('Number Of completed : ${snapshot.data}');
              return Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    TextField(
                      controller: _nameController,
                      decoration: InputDecoration(hintText: 'Recipe name'),
                    ),
                    Container(
                      height: 16.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        _Button('Start adding ingredients', Colors.green[900], () {
                          final recipename = _nameController.text;
                          var recipeid;
                          if (snapshot.data==null){recipeid=1;} else {recipeid=snapshot.data +1;}
                          DataProvider.insertRecipe({
                            'name': recipename,
                            'draft': 1,
                            'id': recipeid,//snapshot.data +1,
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ShowIngredients(recipeid,recipename)),//snapshot.data+1
                          );
                        }),
                        Container(
                          height: 16.0,
                        ),
                        _Button('Discard', Colors.grey, () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LibraryList()),
                          );
                        }),
                      ],
                    )
                  ],
                ),
              );
            }
            return Container();
          },
        ));
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
