import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photocamera_app_test/viewof_save_local_file.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';
import 'package:photocamera_app_test/translation.dart';

//this class manages the text editor
//when called it gets a string or a Json file and its type, so it displays it in the editor
//so we can modify it. it also starts in the "readOnly" mode that we can change  to improve
class TextEditor extends StatefulWidget{
  String doc;
  final Type type;
  final File image;
  TextEditor({required this.doc, required this.type, required this.image});

  @override
  _TextEditor createState() => _TextEditor();

}

class _TextEditor extends State<TextEditor>{

  late ZefyrController _controller;
  late bool _readOnly;
  bool _save=false;
  String text_translated = "";

  @override
  void initState(){
    super.initState();
    final document = loadDocument();
    _readOnly=true;
    _controller = ZefyrController(document);
  }

  void _translateText(String text){
    translate(text, 'en').then((translation) =>

        setState(() {
        text_translated = translation;
      }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: [
          Scaffold(
        body: Column(
        children: [
        if(_readOnly)...[
          Text(text_translated,
            style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                color: Colors.black),
          ),
          TextButton(
            onPressed: () {
              setState((){_readOnly = false;});
            },
            child: const Text(
              "Press to exit the ReadOnly mode", style: TextStyle(
              //fontSize: 10.0,
            ),),
          ),
          TextButton(
            onPressed: () {_translateText(widget.doc);},
            child: const Text(
              "Press to translate in english", style: TextStyle(),
            ),
          )
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
            setState((){_save=true;});
          }
      ),
    ),
          if(_save)...[
            SaveFile(image: widget.image, text: _controller.document.toString(), photo: widget.image)
          ],
    ],
    );
  }

  //this function provide a document readable from the Zefyr library
  NotusDocument loadDocument(){
    if(widget.type==String){
      Delta delta = Delta()..insert(widget.doc);
      delta = delta.concat(Delta()..insert('\n'));  //it always has to end with a newline
      return NotusDocument.fromDelta(delta);
  }
    else{
      List data = json.decode(widget.doc);
      return NotusDocument.fromJson(data);   //not tested
    }
  }
}
