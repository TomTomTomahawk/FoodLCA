import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';
import 'ingredient_list.dart';

//https://www.pexels.com/photo/fruits-eating-food-on-wood-326268/

class LibraryList extends StatefulWidget {
  @override
  LibraryListState createState() {
    return new LibraryListState();
  }
}

class LibraryListState extends State<LibraryList> {
  final TextEditingController _nameController = TextEditingController();

  void initState() {
    _nameController.text = '';

    super.initState();
  }

  Future<void> _saveDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(15))),
          backgroundColor: Color(0xFF162A49),
          title: Text('Enter new recipe name',
              style: TextStyle(color: Colors.white)),
          content: SingleChildScrollView(
              child: Padding(
            padding: const EdgeInsets.all(0.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                FutureBuilder(
                  future: DataProvider.getRecipeMax(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      //return Text('Number Of completed : ${snapshot.data}');
                      return Padding(
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
                                _Button('Ok', Colors.green[900], () {
                                  final recipename = _nameController.text;
                                  var recipeid;
                                  if (snapshot.data == null) {
                                    recipeid = 1;
                                  } else {
                                    recipeid = snapshot.data + 1;
                                  }
                                  DataProvider.insertRecipe({
                                    'name': recipename,
                                    'draft': 1,
                                    'id': recipeid, //snapshot.data +1,
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowIngredients(
                                            recipeid,
                                            recipename)), //snapshot.data+1
                                  );
                                }),
                                Container(
                                  width: 10.0,
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
                )
              ],
            ),
          )),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        appBar: AppBar(
          title: Text('My recipes',
              style: TextStyle(color: Colors.white, fontSize: 22)),
          backgroundColor: Color(0xFF162A49),
          leading: Container(),
        ),
        body: FutureBuilder(
          future: DataProvider.getLibraryList(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              final library = snapshot.data;
              return ListView(children: <Widget>[
                ListView.builder(
                  shrinkWrap: true,
                  reverse: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ShowIngredients(
                                    library[index]['id'],
                                    library[index]['name'])));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border:
                                Border(bottom: BorderSide(color: Colors.grey))),
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40, bottom: 40, left: 35.0, right: 15),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    SizedBox(width: 20),
                                    _RecipeName(library[index]['name'])
                                  ]),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey)
                                ])),
                      ),

                      /*Card(
                        shape: ContinuousRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: BorderSide(
                            color: Colors.black,
                            width: 0.0,
                          ),
                        ),
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.only(
                                top: 40.0, bottom: 40, left: 13.0, right: 22.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Row(children: <Widget>[
                                    SizedBox(width: 20),
                                    _RecipeName(library[index]['name'])
                                  ]),
                                  Icon(Icons.arrow_forward_ios,
                                      color: Colors.grey)
                                ])),
                      ),*/
                    );
                  },
                  itemCount: library.length,
                ),
                library.length == 0
                    ? Center(
                        child: Column(
                        children: [
                          SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4),
                          Text(
                              'You have no recipes.\nTap the + button to add a new recipe.',
                              style: TextStyle(
                                  fontSize: 18, color: Colors.grey[600]))
                        ],
                      ))
                    : Container()
              ]);
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
        floatingActionButton: Stack(
          children: <Widget>[
            Container(
                height: 60.0,
                width: 60.0,
                child: FittedBox(
                    child: Align(
                  alignment: Alignment.bottomRight,
                  //child: FloatingActionButton.extended(
                  child: FloatingActionButton(
                    heroTag: null,
                    onPressed: () {
                      _saveDialog();
                    },
                    //label: Text('New Recipe'),
                    child: Icon(Icons.add, size: 35),
                    backgroundColor: Color(0xFF162A49),
                    /*shape: CircleBorder(
                    side: BorderSide(color: Colors.white.withOpacity(0.7), width: 0.8)),*/
                  ),
                ))),
          ],
        ));
  }
}

class _RecipeName extends StatelessWidget {
  final String _name;

  _RecipeName(this._name);

  @override
  Widget build(BuildContext context) {
    return Text(
      _name,
      style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
    );
  }
}

class _RecipeId extends StatelessWidget {
  final int _id;

  _RecipeId(this._id);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_id',
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _RecipeState extends StatelessWidget {
  final int _draft;

  _RecipeState(this._draft);

  @override
  Widget build(BuildContext context) {
    return Text(
      '$_draft',
      style: TextStyle(color: Colors.grey.shade600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
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
