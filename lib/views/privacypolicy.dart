import 'package:flutter/material.dart';

//privacypolicytemplate.net

class PrivacyPolicy extends StatefulWidget {
  @override
  _PrivacyPolicyState createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('foodLCA\'s privacy policy'),
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
              _Title('Privacy policy'),
              _Content(
                  'Thomas Le Varlet built the foodLCA app. This service is provided at no cost and is intended for use as is. This page is used to inform visitors regarding my policies with the collection, use, and disclosure of personal information if anyone decided to use the service. If you choose to use the service, then you agree to the collection and use of information in relation to this policy. The personal information that I collect is used for providing and improving the service. I will not use or share your information with anyone except as described in this privacy policy.'),
              _Title('Information collection and use'),
              _Content(
                  'For a better experience, while using this service, I may require you to provide certain personally identifiable information. The information will be retained on your device and is not collected by me in any way. The app does use third party services that may collect information used to identify you.'),
              _Title('Cookies'),
              _Content(
                  'Cookies are files with a small amount of data that are commonly used as anonymous unique identifiers. These are sent to your browser from the websites that you visit and are stored on your device\'s internal memory. foodLCA does not use these “cookies” explicitly. However, the app may use third party code and libraries that use “cookies” to collect information and improve their services. You have the option to either accept or refuse these cookies and know when a cookie is being sent to your device. If you choose to refuse our cookies, you may not be able to use some portions of this Service.'),
              _Title('Service providers'),
              _Content('I may employ third-party companies and individuals due to the following reasons:\n\n- To facilitate our service;\n- To provide the service on our behalf;\n- To perform service-related services; or\n- To assist us in analyzing how our service is used. \n\n I want to inform users of foodLCA that these third parties have access to your personal information. The reason is to perform the tasks assigned to them on our behalf. However, they are obligated not to disclose or use the information for any other purpose.'),
              _Title('Security'),
              _Content('I value your trust in providing us your personal information, thus we are striving to use commercially acceptable means of protecting it. However, no method of transmission over the internet, or method of electronic storage is 100% secure and reliable, and I cannot guarantee its absolute security.'),
              _Title('Links to other sites'),
              _Content('This Service may contain links to other sites. If you click on a third-party link, you will be directed to that site. Note that these external sites are not operated by me. Therefore, I strongly advise you to review the privacy policy of these websites. I have no control over and assume no responsibility for the content, privacy policies, or practices of any third-party sites or services.'),
              _Title('Children’s privacy'),
              _Content('These services do not address anyone under the age of 13. I do not knowingly collect personally identifiable information from children under 13. In the case I discover that a child under 13 has provided me with personal information, I immediately delete this from our servers. If you are a parent or guardian and you are aware that your child has provided us with personal information, please contact me so that I will be able to do necessary actions.'),
              _Title('Changes to this privacy policy'),
              _Content('This policy is effective as of 2020-08-20. I may update our privacy policy from time to time. Thus, you are advised to review this page periodically for any changes.'),
              _Title('Contact us'),
              _Content('If you have any questions or suggestions about our privacy policy, do not hesitate to contact me at thomaslevarlet@hotmail.com.'),
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
