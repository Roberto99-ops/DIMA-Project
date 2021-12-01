import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photocamera_app_test/text_editor.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:zefyrka/zefyrka.dart';

class DisplayImageOCR extends StatelessWidget {

  final String extractText;
  final File pickedImage;
  DisplayImageOCR({Key? key,required this.pickedImage, required this.extractText})
      : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            bottom: const TabBar(tabs: [
              Tab(child: Icon(Icons.photo)),
              Tab(child: Icon(Icons.text_fields)),
            ],),
          ),
          body: TabBarView(children: [
            Container(
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: FileImage(pickedImage),
                    fit: BoxFit.fill,
                  )),
            ),
            TextEditor(doc: extractText, type: String,)
          ],),
        ),
      ),
    );
  }
}




