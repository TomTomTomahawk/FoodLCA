import 'package:foodlca/views/charts/comparechartmanager.dart';
import 'package:flutter/material.dart';
import 'package:foodlca/providers/data_provider.dart';

class CompareList extends StatefulWidget {
  final int _recipeid;
  final String _recipename;

  CompareList(this._recipeid, this._recipename);

  @override
  CompareListState createState() {
    return new CompareListState();
  }
}

class CompareListState extends State<CompareList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Compare ' + widget._recipename + ' with:'),
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
                  if (library[index]['id'] != widget._recipeid) {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CompareChartManager(
                                    widget._recipeid,
                                    widget._recipename,
                                    library[index]['id'],
                                    library[index]['name'])));
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
                                    width:
                                        MediaQuery.of(context).size.width * 0.75,
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
                        Text(
                            'You have no recipes to compare ' +
                                widget._recipename +
                                ' with.\nCreate at least one other recipe.',
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
        ' ' + _impact + ' g-CO2-eq / kcal',
        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
        overflow: TextOverflow.ellipsis,
      ),
    ]);
  }
}
