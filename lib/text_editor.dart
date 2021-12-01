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
  State<StatefulWidget> createState() {
    return _TextEditor();
  }

}

class _TextEditor extends State<TextEditor>{

  late ZefyrController _controller;

  @override
  void initState(){
    super.initState();
    final document = loadDocument();
    _controller = ZefyrController(document);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ZefyrToolbar.basic(controller: _controller),
        Expanded(
          child: ZefyrEditor(
            controller: _controller,
            readOnly: false,  //readOnly variable
          ),
        ),
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
