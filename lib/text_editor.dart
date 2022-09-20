import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:photocamera_app_test/viewof_save_local_file.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';

import 'main.dart';
import 'manage_files.dart';


class TextEditor extends StatefulWidget{
  String doc;
  final File? image;
  TextEditor({Key? key, required this.doc, this.image}) : super(key: key);

  @override
  _TextEditor createState() => _TextEditor();

}

class _TextEditor extends State<TextEditor>{

  late ZefyrController _controller;
  late bool _readOnly;
  bool _save = false;

  @override
  void initState(){
    super.initState();
    final document = loadDocument();
    _readOnly = true;
    _controller = ZefyrController(document);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Scaffold(
            body: Column(
            children: [
            if(_readOnly)...[
              Row(
                children: <Widget>[
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        setState((){_readOnly = false;});
                      },
                      child: const Text(
                        "Press to exit the ReadOnly mode", style: TextStyle(
                        //fontSize: 10.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]
            else...[
              ZefyrToolbar.basic(controller: _controller),
            ],
              Expanded(
                child: ZefyrEditor(
                  controller: _controller,
                  readOnly: _readOnly,  //readOnly variable
                ),
              ),
            ],
          ),

          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.archive_sharp),
            onPressed: () async {
            /*await Navigator.of(context).push(
                MaterialPageRoute(
                builder: (context) => SaveFile(image: widget.image, text: _controller.document.toString())));
                */
              if(getFileName()!="") {
                saveFile(getFileName(), _controller.document.toString(), widget.image!);
                setFileName("");
                final cameras = await availableCameras();
                await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => TabApp(camera: cameras.first,), //qui mi sa che è sbagliato nel senso che penso di dover fare la "back"
                    )
                );
              }
              else {
                setState(() {_save = true;});
              }
            }
           ),
          ),
          if(_save)...[
              ViewSaveFile(text: _controller.document.toString(), photo: widget.image!)
          ],
    ],
    );
  }

  //this function provide a document readable from the Zefyr library
  NotusDocument loadDocument(){
      Delta delta = Delta()..insert(widget.doc);
      delta = delta.concat(Delta()..insert('\n'));  //it always has to end with a newline
      return NotusDocument.fromDelta(delta);
  }
}

String fileName = ""; //this variable is used to know if the variable is already been saved
void setFileName(String name){
  fileName = name;
}
String getFileName(){
  return fileName;
}