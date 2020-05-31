import 'package:chart_tuto/views/library_list.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

import 'package:chart_tuto/inherited_widgets/build_inherited_widget.dart';

import 'ingredient_list.dart';

class EditRecipe extends StatefulWidget {
  final int _recipeid;
  final String _recipename;
  EditRecipe(this._recipeid, this._recipename);

  @override
  EditState createState() {
    return new EditState();
  }
}

class EditState extends State<EditRecipe> {
  final TextEditingController _nameController = TextEditingController();

  void didChangeDependencies() {
    _nameController.text = widget._recipename;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit ' + widget._recipename),
          backgroundColor: Colors.green[900],
        ),
        backgroundColor: Colors.grey[100],
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
                        }),
                        Container(
                          height: 16.0,
                        ),
                        _Button('Delete', Colors.red[900], () {
                          DataProvider.deleteRecipe(widget._recipeid);

                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        }),
                        Container(
                          height: 16.0,
                        ),
                        _Button('Discard', Colors.grey, () {
                          Navigator.pop(context);
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
