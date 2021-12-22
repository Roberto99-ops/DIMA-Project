import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:photocamera_app_test/viewof_save_local_file.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';
import 'package:photocamera_app_test/translation.dart';
import 'package:photocamera_app_test/view_of_languages.dart';

import 'main.dart';
import 'manage_files.dart';


class TextEditorTranslation extends StatefulWidget{
  String doc;
  final File? image;
  TextEditorTranslation({Key? key, required this.doc, this.image}) : super(key: key);

  @override
  _TextEditorTranslation createState() => _TextEditorTranslation();

}

class _TextEditorTranslation extends State<TextEditorTranslation>{

  late ZefyrController _controller;
  late bool _readOnly;
  String textTranslated = "";
  String? _selectedLanguage;
  late bool _isChanged;

  @override
  void initState(){
    super.initState();
    _readOnly = true;
    _isChanged = false;
    var document = loadDocument(textTranslated);
    _controller = ZefyrController(document);
  }

  void _translateText(String text){
    translate(text, _selectedLanguage!).then((translation) =>

        setState(() {
          textTranslated = translation;
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
                          setState((){
                            _controller = ZefyrController(loadDocument(textTranslated));
                            _readOnly = false;
                            _isChanged = false;
                          });
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
              Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if(_isChanged)...[
                  Center(
                    child:
                    Text(
                        textTranslated
                    ),
                  ),
                ],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SettingsWidgetLanguage(
                        onChanged: (_currentLanguage) {
                          _isChanged = true;
                          _selectedLanguage = _currentLanguage;
                          _translateText(widget.doc);
                        }
                    ),
                  ],
                ),
               ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  //this function provide a document readable from the Zefyr library
  NotusDocument loadDocument(String text){
    Delta delta = Delta()..insert(text);
    delta = delta.concat(Delta()..insert('\n'));  //it always has to end with a newline
    return NotusDocument.fromDelta(delta);
  }
}