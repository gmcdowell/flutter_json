import 'package:flutter/material.dart';

import 'dart:io'; // files and dir paths support
import 'dart:convert'; // json support
import 'package:path_provider/path_provider.dart';

void main() => runApp(new MaterialApp(
      home: new Home(),
    ));

class Home extends StatefulWidget {
  @override
  State createState() => new HomeState();
}

class HomeState extends State<Home> {
  TextEditingController keyInputController = new TextEditingController();
  TextEditingController valueInputController = new TextEditingController();

  File jsonFile;
  Directory dir;
  String fileName = 'my_json_file.json';
  bool fileExists = false;
  Map<String, dynamic> fileContent;

  @override
  void dispose() {
    keyInputController.dispose();
    valueInputController.dispose();

    super.dispose();
  }

  @override
  initState() {
    super.initState();

    getApplicationDocumentsDirectory().then((Directory directory) {
      dir = directory;

      jsonFile = new File(dir.path + '/' + fileName);
      fileExists = jsonFile.existsSync();
      if (fileExists) {
        this.setState(
            () => fileContent = json.decode(jsonFile.readAsStringSync()));
      }
    });
  }

  void createFile(Directory dir, String fileName, Map<String, dynamic> content) {
    print('creating file');
    File file = new File(dir.path + '/' + fileName);
    file.createSync();
    fileExists = true;
    file.writeAsStringSync(json.encode(content));
  }

  void writeToFile(String key, dynamic value) {
    print('Writing to a file');

    Map<String, dynamic> content = {key: value};

    if (fileExists) {
      print('file exists');
      Map<String, dynamic> jsonFileContent =
          json.decode(jsonFile.readAsStringSync());
      jsonFileContent.addAll(content); // merge new to existing
      jsonFile.writeAsStringSync(json.encode(jsonFileContent));
    } else {
      print('File does not exist');
      createFile(dir, fileName, content);
      // writeToFile(key, value);
    }

    this.setState(() => fileContent = json.decode(jsonFile.readAsStringSync()));
  }

  void writeInputToScreen(String key, String value) {
    print('key: ' + key);
    print('value: ' + value);

    Map<String, dynamic> content = {key: value};

    print('content: ' + content.toString());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('JSON Tutorial'),
        ),
        body: new Column(
          children: <Widget>[
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
            ),
            new Text(
              'File content: ',
              style: new TextStyle(fontWeight: FontWeight.bold),
            ),
            new Text(fileContent.toString()),
            new Padding(
              padding: new EdgeInsets.only(top: 10.0),
            ),
            new Text('Add to JSON file: '),
            new TextField(
              controller: keyInputController,
            ),
            new TextField(
              controller: valueInputController,
            ),
            new Padding(
              padding: new EdgeInsets.only(top: 20.0),
            ),
            new RaisedButton(
              child: new Text('Add key, value pair'),
              onPressed: () => writeToFile(
                  keyInputController.text, valueInputController.text),
            )
          ],
        ));
  }
}
