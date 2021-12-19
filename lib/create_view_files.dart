import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photocamera_app_test/manage_files.dart';
import 'package:photocamera_app_test/text_editor.dart';

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
    //super.initState(); per togliere il warning
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
            onTap: () async =>
            {
              setfileName(files.elementAt(index)),
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      DisplayImageOCR(
                          extractText: getText(files.elementAt(index)),
                          pickedImage: getPhoto(files.elementAt(index))),
                ),
              ),
            },
            onLongPress: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context){
                    return Container(
                      height: 120,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.delete, color: Colors.red),
                            title: const Text('delete'),
                            onTap: () {
                              deleteFile(files[index]);
                              updateFiles();
                              Navigator.of(context).pop();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.share, color: Colors.blue),
                            title: const Text('share'),
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                          )
                        ]
                      )
                    );
                }
              );
              /*showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      contentPadding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                      insetPadding: const EdgeInsets.symmetric(horizontal: 115, vertical: 24),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                              deleteFile(files[index]);
                              updateFiles();
                              Navigator.of(context).pop();
                          },
                          child: Row(
                            children:const [
                              Icon(Icons.delete, color: Colors.red),
                              SizedBox(
                                width: 10,
                              ),
                              Text('delete', style: TextStyle(color: Colors.black),),
                            ]
                          ),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            //Navigator.pop(context, Department.state);
                          },
                          child: Row(
                              children:const [
                                Icon(Icons.share, color: Colors.blue,),
                                SizedBox(
                                  width: 10,
                                ),
                                Text('share', style: TextStyle(color: Colors.black),),
                              ]
                          ),
                        ),
                      ],
                    );
                  }
              );*/
            }
          );
        }
    );
  }


  //this function scan the directory to make a list of the txt files
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
    String finalString = "";
    List<String> strings = content.split('\n');                    //parsing
    for(int i=0; i<strings.length; i++) {
      String string = strings[i];
      int start = 3;
      int end = string.length - 3;
      string = string.substring(start, end);
      if(i!=strings.length-1) string = string + '\n';
      finalString = finalString + string;
    }
    return finalString;
  }

  File getPhoto(String name){
    String path = directory.path;
    File file = File("$path/$name.png");
    return file;
  }

}


