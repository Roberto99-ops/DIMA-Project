import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photocamera_app_test/manage_files.dart';

import 'main.dart';

class ViewSaveFile extends StatefulWidget{
  final String text;
  final File photo;
  const ViewSaveFile({Key? key, required this.text, required this.photo}) : super(key: key);


  @override
  _ViewSaveFile createState() => _ViewSaveFile();
}

class _ViewSaveFile extends State<ViewSaveFile>{
  bool isReadOnly = true;
  final titleController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Container(
          color: Colors.white,
        height: 200,
        width: 300,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              width: 300,
              height: 10,
            ),
            const Text("Insert the name of the file"),
            TextField(
              controller: titleController,
              enableSuggestions: false,
              autocorrect: false,
              readOnly: isReadOnly,
              onTap: (){setState(() {isReadOnly=false;});},
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(
              width: 300,
              height: 60,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 120,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {setState(() {isReadOnly=true;});},
                  child: const Text("delete"),
                  style: const ButtonStyle(
                   // minimumSize: MaterialStateProperty.,
                  )
                ),
                ),
                const SizedBox(
                  width: 60,
                ),
                SizedBox(
                  width: 120,
                  height: 55,
                child: ElevatedButton(
                  onPressed: () async {
                    saveFile(titleController.text, widget.text, widget.photo);
                    final cameras = await availableCameras();
                    await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TabApp(camera: cameras.first,), //qui mi sa che è sbagliato nel senso che penso di dover fare la "back"
                      ),
                    );
                  },
                  child: const Text("save"),
                ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    );
  }

}