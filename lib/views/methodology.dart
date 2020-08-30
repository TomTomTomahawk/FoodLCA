import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Methodology extends StatefulWidget {
  @override
  _MethodologyState createState() => _MethodologyState();
}

class _MethodologyState extends State<Methodology> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('foodLCA\'s methodology'),
        backgroundColor: Color(0xFF162A49),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _Title('Scope definition'),
              _Content(
                  'foodLCA uses the environmental life cycle assessment (LCA) methodology to quantify the environmental impacts of your recipes. The LCA is a methodology assessing environmental impacts associated with the various stages of production of a product, from material extraction all the way to disposal. The environmental performances described in foodLCA only include cradle-to-gate impact assessments, meaning the impacts of the food do not take into account the transportation from the place they were produced which usually accounts for around 10% of the food\'s carbon emissions (Boehm et al., 2018), nor does it account for the conservation of this food in stores or in households. The scores given by foodLCA are still relevant as most of the impacts of all foods come from production.'),
              _Title('Functional units'),
              _Content(
                  'Can a kg of beef be compared to a kg of lettuce? Of course not! Far more energy is contained in a kg of meat. This is why foodLCA compares food recipes in terms of their total environmental impacts but more importantly in terms of impacts per calorie contained in the food assessed. This allows a fair comparison. In the future, foodLCA might allow the assessment of the environmental impacts per gram of protein contained.'),
              _Title('Impact categories'),
              _Content(
                  'At the moment, the only impact category foodLCA will be investigating is the carbon-equivalent emissions using the kg-CO\u2082-eq as a unit. We use the term \'equivalent\' as carbon dioxide is not the only greenhouse gas emmitted in producing food, some being more potent such as methane. All these greenhouse gases are brought back to a single scale: the potency of carbon dioxide. In the future, other impact categories such as land transformation or water use could be assessed by foodLCA. Fortunately, a product which is innefficient in terms of carbon emissions is often innefficient in the other impact categories, as they are often linked. Therefore, the carbon-equivalent emissions scores given by foodLCA are a good indicator of the global warming potential as well as overall environmental friendliness of your recipes.'),
              _Title('Data sources'),
              _Content(
                  'The sources of all the ingredients\' global warming potentials as well as calorie intensities can be found in a spreadsheet* inside the Google Drive page of the app. Global warming potential scores coming from meta-analyses in scientific journals are preferred. The USDA (United States Department of Agriculture) is usually the source for calorie intensities.'),
              Padding(
                padding: EdgeInsets.fromLTRB(8.0,0,0,8.0),
                child: InkWell(
                    child: new Text(
                      '*Data sources',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue,
                          decoration: TextDecoration.underline),
                      maxLines: 100,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => launch(
                        'https://docs.google.com/spreadsheets/d/1_EVOzbPn55hi9Kd8z87m6z2EypdVhtQg/edit#gid=709204733')),
              ),
              _Title('Uncertainties'),
              _Content(
                  'foodLCA is aware that a food product will have a vastly different impact depending on the season it is grown, the method used to grow it, the climate where it was grown, etc. However, foodLCA believes the intrinsic differences in orders of magnitudes between different foods\' global warming potentials is so big that despite the uncertainties associated to each food product, the scores given are still relevant decision-making tools.'),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  final String _text;

  _Title(this._text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        _text,
        textAlign: TextAlign.left,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        maxLines: 5,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class _Content extends StatelessWidget {
  final String _text;

  _Content(this._text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        _text,
        textAlign: TextAlign.justify,
        style: TextStyle(fontSize: 16),
        maxLines: 100,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}
