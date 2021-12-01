import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';

//this class manages the text editor
//when called it gets a string or a Json file and its type, so it displays it in the editor
//so we can modify it. it also starts in the "readOnly" mode that we can change  to improve
class TextEditor extends StatefulWidget{
  final String doc;
  final Type type;
  TextEditor({required this.doc, required this.type});

  @override
  _TextEditor createState() => _TextEditor();

}

class _TextEditor extends State<TextEditor>{

  late ZefyrController _controller;
  late bool _readOnly;

  @override
  void initState(){
    super.initState();
    final document = loadDocument();
    _readOnly=true;
    _controller = ZefyrController(document);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
        children: [
        if(_readOnly)...[
          TextButton(
            onPressed: () {
              setState((){_readOnly = false;});
            },
            child: const Text(
              "Press to exit the ReadOnly mode", style: TextStyle(
              //fontSize: 10.0,
            ),),
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
          onPressed: (){}),
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
