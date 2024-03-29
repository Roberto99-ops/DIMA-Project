import 'dart:async';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'create_view_files.dart';
import 'create_view_photo.dart';

Future<void> main() async{
  //It ensures that plugin services are initialized and fun like availableCameras() can be called
  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  // Get a specific camera from the list of available cameras (generally backCamera)
  final firstCamera = cameras.first;

  runApp(TabApp(camera: firstCamera));
}

class TabApp extends StatelessWidget {
  final camera;
  const TabApp({Key? key, required this.camera}) : super(key: key);


  // This widget is the root of the application.
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
              Tab(child: Icon(Icons.photo_camera)),
              Tab(child: Icon(Icons.link)),
              Tab(child: Icon(Icons.star)),
            ],),
          ),
          body: TabBarView(children: [
            CreateViewPhoto(name: 'Take photos', camera: camera),
            const CreateViewFiles(name: 'Links'),
            const CreateViewFiles(name: 'Favourites'),
          ],),
        ),
      ),
    );
  }
}

