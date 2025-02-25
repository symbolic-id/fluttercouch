import 'package:flutter/services.dart';
import 'package:fluttercouch/document.dart';
import 'package:fluttercouch/fluttercouch.dart';
import 'package:fluttercouch/mutable_document.dart';
import 'package:fluttercouch/query/query.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:uuid/uuid.dart';

class AppModel extends Model with Fluttercouch {
  String _databaseName;
  Document docExample;
  Query query;

  AppModel() {
    initPlatformState();
  }

  initPlatformState() async {
    try {
      _databaseName = await initDatabaseWithName("kalpataru_dev");
      setReplicatorEndpoint("ws://192.168.0.115:4984/kalpataru_dev");
      setReplicatorType("PUSH_AND_PULL");
      setReplicatorBasicAuthentication(<String, String>{
        "username": "admin",
        "password": "qweasdzxc"
      });
      setReplicatorContinuous(true);
      initReplicator();
      startReplicator();
      docExample = await getDocumentWithId("card_1");
      notifyListeners();
      MutableDocument mutableDoc = MutableDocument();
      mutableDoc.setString("prova", "");
    } on PlatformException {}
  }

  void addContent(String content) {
    final id = 'card_${Uuid().v1()}';
    Document doc = Document(
      {
        "id": id,
        "content": content
      }, id
    );
    if (docExample != null) {
      saveDocument(doc);
    }
  }


  Future<List<dynamic>> getCards() async {
    Query query = QueryBuilder.select([SelectResult.all()])
        .from('kalpataru_dev')
        .where(Meta.id.regex(Expression.string('^card')));
    // Query query = QueryBuilder.select([SelectResult.all()])
    //     .from("bucket")
    //     .where(Meta.id.equalTo(Expression.string("users")));

    // List<Card> cards = [];

    print('LL:: resultSet execute() ===========');
    final resultSet = await query.execute();
    print('LL:: resultSet resultSet : $resultSet');
    resultSet?.allResults().forEach((element) {
      element
          .toList()
          .forEach((element) => {
        print('LL:: resultSet element: ${element['title']}')
      });
    });

    return [];
  }
}