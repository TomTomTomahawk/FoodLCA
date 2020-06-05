import 'package:chart_tuto/views/charts/comparechartmanager.dart';
import 'package:flutter/material.dart';
import 'package:chart_tuto/providers/data_provider.dart';

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
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, bottom: 30, left: 13.0, right: 22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              _RecipeName(library[index]['name']),
                            ],
                          ),
                        ),
                      ),*/
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
