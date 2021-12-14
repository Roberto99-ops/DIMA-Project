import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'ocr.dart';


class CreateViewFiles extends StatefulWidget {
  final String name;

  final camera;

  const CreateViewFiles({Key? key, required this.name, this.camera})
      : super(key: key);

  @override
  _View createState() => _View();
}


class _View extends State<CreateViewFiles>{

  late List<String> files;
  late Directory directory;

  @override
  void initState(){
    files = List.filled(0, "", growable: true);
    updateFiles();
  }

  @override
  Widget build(BuildContext context) {

    return ListView.builder(
      itemCount: files.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          title: Text(files.elementAt(index)),
          onTap: () async => await Navigator.of(context).push(
                  MaterialPageRoute(
                  builder: (context) => DisplayImageOCR(extractText: getText(files.elementAt(index)), pickedImage: getPhoto(files.elementAt(index))),
                  ),
                  ),
          //onLongPress: , qui esce opzione condividi, cancella ecc
        );
      },
    );
  }


  updateFiles() async {
    List<String> names = List.filled(0, "", growable: true);
    List<FileSystemEntity> list;
    Directory dir = await getApplicationDocumentsDirectory();
    list = dir.listSync();
    for(FileSystemEntity file in list){
      //FileStat f = file.path;
      if(file.path.endsWith("txt")) {
        String string = file.path.split("/").last;
        int start = 0;
        int end = string.lastIndexOf(".");
        string = string.substring(start, end);
        names.add(string);
      }
    }

    setState((){
      files = names;
    directory = dir;
    });
  }

  String getText(String name){
    String path = directory.path;
    File file = File("$path/$name.txt");
    String content = file.readAsStringSync();
    return content;
  }

  File getPhoto(String name){
    String path = directory.path;
    File file = File("$path/$name.png");
    return file;
  }

}
