import 'package:flutter/material.dart';

import 'package:chart_tuto/inherited_widgets/note_inherited_widget.dart';
import 'package:chart_tuto/views/note_list.dart';


class Build extends StatelessWidget {
  const Build({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NoteInheritedWidget(
      MaterialApp(
        title: 'Build',
        home: NoteList(),
      ),
    );
  }
}

/*

class Build extends StatelessWidget {
  const Build({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Build a new product"),
          backgroundColor: Colors.green,
        ),
        body: ListView(children: <Widget>[
          Text('Product name', style: TextStyle(fontSize: 25.0)),
          TextField(decoration: InputDecoration(hintText: 'Enter a name')),
          Text('Description', style: TextStyle(fontSize: 25.0)),
          TextField(
              decoration:
                  InputDecoration(hintText: 'Enter a description (optional)')),
          SizedBox(height: 30),
          Text('Resources', style: TextStyle(fontSize: 25.0)),
          RaisedButton(
            child: Text('Add ingredient'),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Foodchoice()),
              );
            },
          ),
        ]));
  }
}

class Foodchoice extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select food type"),
      ),
      body: ListView(children: <Widget>[
        RaisedButton(
          child: Text('Vegetables'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Vegetables()),
            );
          },
        ),
        RaisedButton(
          child: Text('Meat and fish'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Meatandfish()),
            );
          },
        ),
        RaisedButton(
          child: Text('Fruit'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Fruit()),
            );
          },
        ),
        RaisedButton(
          child: Text('Dairy'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Dairy()),
            );
          },
        ),
        RaisedButton(
          child: Text('Cereal'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Cereal()),
            );
          },
        ),
        RaisedButton(
          child: Text('Others'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Others()),
            );
          },
        ),
      ]),
    );
  }
}

class Vegetables extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select vegetable"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }
}

class Meatandfish extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select meat or fish"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }
}

class Fruit extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select fruit"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }
}

class Dairy extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select dairy"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }
}

class Cereal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select cereal"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }
}

class Others extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select others"),
      ),
      body: RaisedButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Text('Go back!'),
      ),
    );
  }
}
*/