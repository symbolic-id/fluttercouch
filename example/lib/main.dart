import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:fluttercouch_example/app_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Fluttercouch example application',
        home: ScopedModel<AppModel>(
          model: AppModel(),
          child: Home(),
        ));
  }
}

class Home extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluttercouch example application'),
      ),
      body: Center(
        child: ScopedModelDescendant<AppModel>(
          builder: (context, child, model) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("This is an example app"),
              Expanded(
                child: ScopedModelDescendant<AppModel>(
                  builder: (context, child, model) => Text(
                    // '${model.docExample.getKeys()}',
                    '${model.docExample?.getValue('content') ?? "Loading.."}',
                    style: Theme.of(context).textTheme.display1,
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: FloatingActionButton(
                    onPressed: () {
                      model?.addContent("This card created from Android");
                    },
                    child: Icon(Icons.add),
                  ),
                ),
              )
            ],
          ),
        )
      ),
    );
  }
}
