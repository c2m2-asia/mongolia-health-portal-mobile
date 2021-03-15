import 'dart:collection';
import 'dart:io';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:oauth1/oauth1.dart' as oauth1;
import 'package:xml/xml.dart';

const OAUTH1_DOMAIN = 'https://www.openstreetmap.org/oauth/authorize';
const OAUTH1_CLIENT_ID = 'N78Z8LVZhNZfDdbiwdYA16N6JdkUxG0cQmlNU3Vb';
const OAUTH1_CLIENT_SECRET = "dv4Yxnuf6melHrJMYC2z8iZkJ0YScDLrPz0PFDei";
const OAUTH1_REDIRECT_URI = 'kll.c2m2mongolia://login-callback';
final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

final platform = new oauth1.Platform(
    'https://www.openstreetmap.org/oauth/request_token',
    // temporary credentials request
    'https://www.openstreetmap.org/oauth/authorize',
    // resource owner authorization
    'https://www.openstreetmap.org/oauth/access_token',
    // token credentials request
    oauth1.SignatureMethods.hmacSha1 // signature method
);

final clientCredentials = new oauth1.ClientCredentials(
    OAUTH1_CLIENT_ID, OAUTH1_CLIENT_SECRET);

class OSMClient {
  oauth1.Authorization _auth = new oauth1.Authorization(new oauth1.ClientCredentials(
      OAUTH1_CLIENT_ID, OAUTH1_CLIENT_SECRET), new oauth1.Platform(
      'https://www.openstreetmap.org/oauth/request_token',
      // temporary credentials request
      'https://www.openstreetmap.org/oauth/authorize',
      // resource owner authorization
      'https://www.openstreetmap.org/oauth/access_token',
      // token credentials request
      oauth1.SignatureMethods.hmacSha1 // signature method
  ));

  Future<oauth1.AuthorizationResponse> loginAction(FlutterWebviewPlugin _flutterWebviewPlugin) async {
    var clientCredentials = new oauth1.ClientCredentials(OAUTH1_CLIENT_ID, OAUTH1_CLIENT_SECRET);
// create Authorization object with client credentials and platform definition
    var auth = new oauth1.Authorization(clientCredentials, platform);
    oauth1.AuthorizationResponse authorizationResponse;
   await auth.requestTemporaryCredentials('oob').then((res) {
      // redirect to authorization page
      final url = auth.getResourceOwnerAuthorizationURI(res.credentials.token);
      _flutterWebviewPlugin.launch(url);
      authorizationResponse = res;
    });
    return authorizationResponse;
  }

  loadUser() async {
    String token = await secureStorage.read(key: "token");
    String tokenSecret = await secureStorage.read(key: "tokenSecret");
    oauth1.Credentials credentials = new oauth1.Credentials(token, tokenSecret);
    var client = new oauth1.Client(platform.signatureMethod, new oauth1.ClientCredentials(
        OAUTH1_CLIENT_ID, OAUTH1_CLIENT_SECRET), credentials);
    // now you can access to protected resources via client
    client.get('https://www.openstreetmap.org/api/0.6/user/details').then((res) {
      final document = XmlDocument.parse(res.body);
      final elementa = document.rootElement;
      final user = elementa.getElement('user').attributes;
      user.forEach((data) {
        if(data.name.toString() == 'id') {
          print(data.value);
        } else if (data.name.toString() == 'display_name') {
          print(data.value);
        }
      });
    });
  }
  Future<oauth1.Client> osmClient() async {
    String token = await secureStorage.read(key: "token");
    String tokenSecret = await secureStorage.read(key: "tokenSecret");
    oauth1.Credentials credentials = new oauth1.Credentials(token, tokenSecret);
    return new oauth1.Client(platform.signatureMethod, new oauth1.ClientCredentials(
        OAUTH1_CLIENT_ID, OAUTH1_CLIENT_SECRET), credentials); 
  }
  Future<XmlDocument> loadOsmFeature(String osmID) async {
    var client = await osmClient();
    XmlDocument xmlDocument;
    // now you can access to protected resources via client
    await client.get('https://www.openstreetmap.org/api/0.6/$osmID').then((res) async {
      xmlDocument = XmlDocument.parse(res.body);
      // print(xmlDocument.toXmlString(pretty: true, indent: '\t'));
    });
    return xmlDocument;
  }
  Future<OSMUser> saveCred(oauth1.AuthorizationResponse response, oauth1.ClientCredentials clientCredentials) async {
    String value = await secureStorage.read(key: "token");
    if (value != null) {
      await secureStorage.delete(key: "token");
      await secureStorage.delete(key: "tokenSecret");
      await secureStorage.delete(key: "userId");
      await secureStorage.delete(key: "userName");
    }
    await secureStorage.write(key: "token", value: response.credentials.token);
    await secureStorage.write(key: "tokenSecret", value: response.credentials.tokenSecret);

    var client = new oauth1.Client(platform.signatureMethod, clientCredentials, response.credentials);
    OSMUser userDetail;
    // now you can access to protected resources via client
    await client.get('https://www.openstreetmap.org/api/0.6/user/details').then((res) async {
      final document = XmlDocument.parse(res.body);
      final elementa = document.rootElement;
      final user = elementa.getElement('user').attributes;
      String userId, userName;
      await Future.forEach(user, (data) async {
        if(data.name.toString() == 'id') {
          secureStorage.write(key: "userId", value: data.value);
          userId = data.value;
        } else if (data.name.toString() == 'display_name') {
          secureStorage.write(key: "userName", value: data.value);
          userName = data.value;
        }
      });
      // await user.forEach((data) async {
      //
      // });
      userDetail = new OSMUser(userId, userName);
    });
    return userDetail;
  }

  String getChangeset(String comment){
    return "<osm>\n<changeset>\n"
    + "<tag k=\"created_by\" v=\"Mongolia Health Portal Mobile Application\"/>\n"
    + "<tag k=\"comment\" v=\"#c2m2mongolia-mobile #kll #ttkll ${comment}\"/>\n"
    + "</changeset>\n</osm>";
  }

  XmlDocument cleanseData(XmlDocument osmData, String type) {
    const deleteProps = ['changeset', 'timestamp', 'uid', 'user'];
    deleteProps.forEach((element) {
      osmData.rootElement.getElement(type).removeAttribute(element);
    });
    return osmData;
  }

  Future<String> requestChangeset(String comment) async {
    final client = await osmClient();
    String changeset;
    await client.put('https://www.openstreetmap.org/api/0.6/changeset/create',
    headers: <String, String>{
    'Content-Type': 'text/xml',
    },
        body: getChangeset(comment),
    ).then((value) {
      changeset = value.body;
    });
    return changeset;
  }

  XmlDocument appendChanges(XmlDocument editDocument, HashMap<String, List<String>> editValues, String changeset, String type) {
    // print(editDocument);
  // final vals = editDocument.rootElement.nodes;
    editDocument.rootElement.getElement(type).setAttribute("changeset", changeset);
    HashMap keyValuePlain = new HashMap<String, String>();
    for (var dict in editValues.entries) {
      if (dict.value.length > 0 && dict.value.first != null && dict.value.first != "unknown") {
          keyValuePlain[dict.key] = dict.value.join(";");
      }
      else {
        editDocument.rootElement
            .getElement(type)
            .children.removeWhere((element) => element.getAttribute('k') == dict.key);
      }
    }

    List<XmlNode> existingNode = [];
    List<XmlNode> newNode = [];
    print(keyValuePlain);
    keyValuePlain.forEach((key, value)  {
      var flag = true;
      final builder = new XmlBuilder();
      builder.element('tag', nest: (){
        builder.attribute("k", key);
        builder.attribute("v", value);
      });
      XmlNode xmlNode = builder.buildFragment();
      editDocument.rootElement.getElement(type).children.forEach((node) {
        if(node.getAttribute('k') == key) {
          existingNode.add(xmlNode);
          flag = false;
        }
      });
     if(flag)
       newNode.add(xmlNode);
    });

    existingNode.forEach((node) {
        int i = editDocument.rootElement
            .getElement(type)
            .children.indexOf(editDocument.rootElement
              .getElement(type)
              .children.firstWhere((element) => element.getAttribute('k') == node.firstElementChild.getAttribute('k'))
        );
        editDocument.rootElement.getElement(type).children.removeAt(i);
        editDocument.rootElement.getElement(type).children.insert(i,node);
    });
    newNode.forEach((element) {
      editDocument.rootElement.getElement(type).children.add(element);
    });
    // print(editDocument.toXmlString(pretty: true, indent: '\t'));
    return editDocument;
  }

  Future<String> requestEdit(XmlDocument xmlDocument, String type) async {
    final client = await osmClient();
    String res;
    await client.put('https://www.openstreetmap.org/api/0.6/$type',
      headers: <String, String>{
        'Content-Type': 'text/xml',
      },
      body: xmlDocument.toString(),
    ).then((response) {
      res = response.body;
    }).catchError( (error){
      res = error;
    });
    return res;
  }

}

class OSMUser {
  String userId;
  String userName;

  OSMUser(this.userId, this.userName);
}