import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photocamera_app_test/viewof_save_local_file.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';
import 'package:photocamera_app_test/translation.dart';
import 'package:photocamera_app_test/view_of_languages.dart';

//this class manages the text editor
//when called it gets a string or a Json file and its type, so it displays it in the editor
//so we can modify it. it also starts in the "readOnly" mode that we can change  to improve
class TextEditor extends StatefulWidget{
  String doc;
  final Type type;
  final File image;
  TextEditor({Key? key, required this.doc, required this.type, required this.image}) : super(key: key);

  @override
  _TextEditor createState() => _TextEditor();

}

class _TextEditor extends State<TextEditor>{

  late ZefyrController _controller;
  late bool _readOnly;
  bool _save=false;
  String text_translated = "";
  String? _selectedLanguage;

  @override
  void initState(){
    super.initState();
    final document = loadDocument();
    _readOnly=true;
    _controller = ZefyrController(document);
  }

  void _translateText(String text){
    translate(text, _selectedLanguage!).then((translation) =>

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
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 5, // 50%
                    child: TextButton(
                      onPressed: () {
                        setState((){_readOnly = false;});
                      },
                      child: const Text(
                        "Press to exit the ReadOnly mode", style: TextStyle(
                        //fontSize: 10.0,
                      ),),
                    ),
                  ),
                  Expanded(
                    flex: 5, // 50%
                    child: TextButton(
                      onPressed: () {_translateText(widget.doc);},
                      child: const Text(
                        "Press to translate", style: TextStyle(),
                      ),
                    ),
                  )
                ],
              ),
            ]
            else...[
            ZefyrToolbar.basic(controller: _controller),
            ],
            Expanded(
              flex: 3,
              child: ZefyrEditor(
                controller: _controller,
                readOnly: _readOnly,  //readOnly variable
              ),
            ),
            /*const Expanded(
              flex: 4,
              child:
                SizedBox()
            ),*/
            Expanded(
              flex: 5,
              child:
                Text(text_translated,
                  style: const TextStyle(
                      fontSize: 20,
                      color: Color(0xFF007ADC)),
                ),
            ),
            Expanded(
              flex: 2,
              child:
                SettingsWidgetLanguage(
                    onChanged: (_currentLanguage) {
                      _selectedLanguage = _currentLanguage;
                    }
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
            SaveFile(text: _controller.document.toString(), photo: widget.image)
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
