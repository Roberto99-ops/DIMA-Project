import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DisplayImageOCR extends StatelessWidget {

  final String extractText;
  final File pickedImage;

  const DisplayImageOCR({Key? key,required this.pickedImage, required this.extractText})
      : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Tesseract OCR'),
        ),
        body: ListView(
          children: [
            Container(
              height: 300,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  image: DecorationImage(
                    image: FileImage(pickedImage),
                    fit: BoxFit.fill,
                  )),
            ),
            SizedBox(height: 20),
            Center(
              child: Text(
                extractText,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
    );
  }
}
