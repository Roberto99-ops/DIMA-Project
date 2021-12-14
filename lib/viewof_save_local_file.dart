import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photocamera_app_test/save_local_file.dart';

import 'main.dart';

class SaveFile extends StatefulWidget{
  final File image;
  final String text;
  final File photo;
  const SaveFile({Key? key, required this.image, required this.text, required this.photo}) : super(key: key);


  @override
  _SaveFile createState() => _SaveFile();
}

class _SaveFile extends State<SaveFile>{
  bool activated = true;
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
              readOnly: activated,
              onTap: (){setState(() {activated=false;});},
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
                  onPressed: () {setState(() {activated=true;});},
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