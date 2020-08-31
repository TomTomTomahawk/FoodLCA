import 'package:flutter/material.dart';
import 'package:foodlca/providers/data_provider.dart';
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
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Colors.transparent),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 2.0, color: Colors.blue),
                                ),
                              ),
                            ),
                            Container(
                              height: 20.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                    'name': recipename == ''
                                        ? 'unnamed recipe'
                                        : recipename,
                                    'draft': 1,
                                    'id': recipeid, //snapshot.data +1,
                                  });

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowIngredients(
                                            recipeid,
                                            recipename == ''
                                                ? 'unnamed recipe'
                                                : recipename)), //snapshot.data+1
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
    return WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.grey[100],
            appBar: AppBar(
              title: Text('My recipes', style: TextStyle(color: Colors.white)),
              backgroundColor: Color(0xFF162A49),
              leading: Padding(
                  padding: EdgeInsets.all(7),
                  child: Image.asset('assets/images/logo6.png')),
            ),
            body: FutureBuilder(
              future: Future.wait([
                DataProvider.getLibraryList(),
                DataProvider.getAllIngredients()
              ]),
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
                          }
                        }

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
                                border: Border(
                                    bottom: BorderSide(color: Colors.grey))),
                            child: Padding(
                                padding: EdgeInsets.only(
                                    top: 30,
                                    bottom: 30,
                                    left: MediaQuery.of(context).size.width *
                                        0.0852,
                                    right: MediaQuery.of(context).size.width *
                                        0.0365),
                                child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
                                        child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              //SizedBox(width: 20),
                                              _RecipeName(
                                                  library[index]['name']),
                                              _RecipeImpact(totalcalories == 0
                                                  ? '0.0'
                                                  : (totalcarbon /
                                                          totalcalories)
                                                      .toStringAsFixed(1))
                                            ]),
                                      ),
                                      Icon(Icons.arrow_forward_ios,
                                          color: Colors.grey[700], size: 17)
                                    ])),
                          ),
                        );
                      },
                      itemCount: library.length,
                    ),
                    library.length == 0
                        ? Center(
                            child: Column(
                            children: [
                              SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.4),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                      MediaQuery.of(context).size.width * 0.097,
                                      0,
                                      MediaQuery.of(context).size.width * 0.097,
                                      0),
                                  child: Text(
                                      'You have no recipes.\nTap the + button to add a new recipe.',
                                      style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey[600])))
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
            )));
  }
}

String truncateWithEllipsis(int cutoff, String myString) {
  return (myString.length <= cutoff)
      ? myString
      : '${myString.substring(0, cutoff)}...';
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
