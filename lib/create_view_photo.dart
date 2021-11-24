import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:simple_ocr_plugin/simple_ocr_plugin.dart';

import 'gallery_ocr.dart';

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
                    child: Icon(Icons.photo_camera, color: Colors.black)
                ),

                ElevatedButton(
                    onPressed: () { chooseImage();},
                    child: Icon(Icons.photo, color: Colors.purple)
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
    _extractText =
    await SimpleOcrPlugin.performOCR(_pickedImage.path, delimiter: "\n");// sarebbe fatto per salvare il tutto su un file json, boh pensiamoci
    setState(() {
      _scanning = false;
    });

    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DisplayImageOCR(extractText: _extractText, pickedImage: _pickedImage,),
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

      // If the picture was taken, display it on a new screen.
      await Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => DisplayPictureScreen(
            // Pass the automatically generated path to
            // the DisplayPictureScreen widget.
            imagePath: image.path,
          ),
        ),
      );
    } catch (e) {
      // If an error occurs, log the error to the console.
      print(e);
    }
  }
}


// A widget that displays the picture taken by the user.
class DisplayPictureScreen extends StatelessWidget {
  final String imagePath;

  const DisplayPictureScreen({Key? key, required this.imagePath})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Display the Picture')),
      // The image is stored as a file on the device. Use the `Image.file`
      // constructor with the given path to display the image.
      body: Image.file(File(imagePath)),
    );
  }
}
