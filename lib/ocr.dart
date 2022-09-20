import 'dart:io';

import 'package:flutter/material.dart';
import 'package:photocamera_app_test/text_editor.dart';
import 'package:photocamera_app_test/text_editor_translation.dart';

class DisplayImageOCR extends StatelessWidget {

  final String extractText;
  final File pickedImage;
  const DisplayImageOCR({Key? key,required this.pickedImage, required this.extractText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
      ),
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(child: Icon(Icons.photo)),
              Tab(child: Icon(Icons.text_fields)),
              Tab(child: Icon(Icons.language)),
            ],),
          ),
          body: TabBarView(children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: FileImage(pickedImage),
                    //fit: BoxFit.none,
                  )),
            ),
            TextEditor(doc: extractText, image: pickedImage),
            TextEditorTranslation(doc: extractText),
          ],),
        ),
      ),
    );
  }
}




