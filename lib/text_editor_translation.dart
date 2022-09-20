import 'dart:io';
import 'package:flutter/material.dart';
import 'package:zefyrka/zefyrka.dart';
import 'package:quill_format/quill_format.dart';
import 'package:photocamera_app_test/translation.dart';
import 'package:photocamera_app_test/view_of_languages.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';


class TextEditorTranslation extends StatefulWidget{
  String doc;
  final File? image;
  TextEditorTranslation({Key? key, required this.doc, this.image}) : super(key: key);

  @override
  _TextEditorTranslation createState() => _TextEditorTranslation();

}

class _TextEditorTranslation extends State<TextEditorTranslation> with AutomaticKeepAliveClientMixin{

  late ZefyrController _controller;
  late bool _readOnly;
  String textTranslated = "";
  String? _selectedLanguage;
  late bool _isChanged;
  late bool _isLoading;

  //override required by AutomaticKeepAliceClientMixin to avoid refresh of this tab bar view
  @override
  bool get wantKeepAlive => true;

  @override
  void initState(){
    super.initState();
    _readOnly = true;
    _isChanged = false;
    _isLoading = false;
    var document = loadDocument(textTranslated);
    _controller = ZefyrController(document);
  }

  void _translateText(String text){
    translate(text, _selectedLanguage!).then((translation) =>

        setState(() {
          _isLoading = false;
          textTranslated = translation;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if(!_isLoading)...[
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

                if(_isChanged)...[
                  Center(
                    child:
                    Text(
                        textTranslated
                    ),
                  ),
                ],

                Expanded(
                  child: ZefyrEditor(
                    controller: _controller,
                    readOnly: _readOnly,  //readOnly variable
                  ),
                ),

                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    SettingsWidgetLanguage(
                        onChanged: (currentLanguage) {
                          setState(() {
                            _isLoading = true;
                          });

                          _selectedLanguage = currentLanguage;
                          _translateText(widget.doc);

                          setState(() {
                            _isChanged = true;
                          });
                        }
                    ),
                  ],
                ),
              ],
            ),
          ),
        ]
        else...[
          const Center(
              child:
              SpinKitChasingDots(
                color: Colors.white,
                size: 50.0,
              )
          ),
        ],
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