import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ocr_plugin/simple_ocr_plugin.dart';

import 'ocr.dart';

class CreateViewPhoto extends StatelessWidget {
  final String name;

  final camera;

  const CreateViewPhoto({Key? key, required this.name, this.camera}) : super(key: key);



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: TakePictureScreen(camera: camera),
      ),
    );
  }
}

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.
    _cameraController = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );

    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _cameraController.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Fill this out in the next steps.
    return Column(
        mainAxisAlignment: MainAxisAlignment.end,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          //this contains the live fotocamera
          Container(
        /*  child: Scaffold(
        appBar: AppBar(title: const Text('Take a picture')),
        // You must wait until the controller is initialized before displaying the
        // camera preview. Use a FutureBuilder to display a loading spinner until the
        // controller has finished initializing.*/
            child: FutureBuilder<void>(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
          // If the Future is complete, display the preview.
                  return CameraPreview(_cameraController);
                } else {
          // Otherwise, display a loading indicator.
                  return const Center(child: CircularProgressIndicator());
                }
                },
            ),
          ),
          //this contains the buttons
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                    onPressed: () {takePhoto();},
                    child: const Icon(Icons.photo_camera, color: Colors.black)
                ),

                ElevatedButton(
                    onPressed: () { chooseImage();},
                    child: const Icon(Icons.photo, color: Colors.purple)
                )
              ]
          )
        ]

    );
  }

  //this method contains the steps to choose a image from the gallery and convert into text
  chooseImage()
  async {
    File _pickedImage;
    bool _scanning=false;   //useless, is used only to set the state on and off to allow _extractText to be written
    late String _extractText;  //(that's because _extractText is String, and the return value of performOCR is future String)
    setState(() {
      _scanning = true;
    });
    _pickedImage =
    await ImagePicker.pickImage(source: ImageSource.gallery);
    File? _cropped = await cropImage(_pickedImage);
    _extractText =
    await SimpleOcrPlugin.performOCR(_cropped!.path, delimiter: "\n");// sarebbe fatto per salvare il tutto su un file json, boh pensiamoci
    _extractText = stringRefactor(_extractText);
    setState(() {
      _scanning = false;
    });

    await Navigator.of(context).push(
    MaterialPageRoute(
      builder: (context) => DisplayImageOCR(extractText: _extractText, pickedImage: _cropped,),
    ),
  );
  }


  //this method contains the steps to do to take a photo
  takePhoto()
  async {
    try {
      // Ensure that the camera is initialized.
      await _initializeControllerFuture;

      // Attempt to take a picture and get the file `image`
      // where it was saved.
      final image = await _cameraController.takePicture();
      //putInGallery(image.name);

      // If the picture was taken, display it on a new screen.

      File _pickedImage = File(image.path);
      bool _scanning=false;
      late String _extractText;
      setState(() {
        _scanning = true;
      });
      File? _cropped = await cropImage(_pickedImage);
      _extractText =
      await SimpleOcrPlugin.performOCR(_cropped!.path, delimiter: "\n");
      _extractText = stringRefactor(_extractText);
      setState(() {
        _scanning = false;
      });


      await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayImageOCR(extractText: _extractText, pickedImage: _cropped,),
      ),
    );

    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }

  //this function allow the user to resize and rotate the image
  Future<File?> cropImage(File _pickedImage) async {
    bool scanning = false;
    setState(() {
      scanning = true;
    });
    File? cropped = await ImageCropper.cropImage(
        sourcePath: _pickedImage.path,
        aspectRatio: const CropAspectRatio(
            ratioX: 1, ratioY: 1),
        compressQuality: 100,
        maxWidth: 700,
        maxHeight: 700,
        compressFormat: ImageCompressFormat.jpg,
        androidUiSettings: const AndroidUiSettings(
          toolbarColor: Colors.blue,
          toolbarTitle: "Crop Image",
          statusBarColor: Colors.blue,
          backgroundColor: Colors.white,
          lockAspectRatio: false,
        )
    );

    setState(() {
      scanning = false;
    });

    return cropped;
  }

  //this function refactors the text
  String stringRefactor(String string) {
    int start = string.indexOf("{")+24;
    int end = string.lastIndexOf("b")-4;
    return string.substring(start, end);
  }
}


