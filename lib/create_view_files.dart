import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';


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

  @override
  void initState(){
    files = List.filled(0, "", growable: true);
    updateFiles();
  }

  @override
  Widget build(BuildContext context) {

    return Center(
        child: Column(
          children: [
            if(files.isNotEmpty)...[
            for(int i=0; i<files.length; i++)...[
              new Text(files.elementAt(i)),
            ],
        ],
      ],
        ),
    );

  }


  updateFiles() async {
    List<String> names = List.filled(0, "", growable: true);
    List<FileSystemEntity> list;
    Directory directory = await getApplicationDocumentsDirectory();
    list = directory.listSync();
    for(FileSystemEntity file in list){
      //FileStat f = file.path;
      if(file.path.endsWith("txt"))
        names.add(file.path.split("/").last);
    }

    setState((){files = names;});
  }

}
