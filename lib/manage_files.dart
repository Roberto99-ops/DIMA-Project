import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



  Future<bool> saveFile(String fileName, String text, File photo) async {

    Directory directory;
    try {
      if (Platform.isAndroid) {
        if (await _requestPermission(Permission.storage)) {
          directory = await getApplicationDocumentsDirectory();
          /*String newPath = "";
          List<String> paths = directory.path.split("/");
          for (int x = 1; x < paths.length; x++) {
            String folder = paths[x];
            if (folder != "Android") {
              newPath += "/" + folder;
            } else {
              break;
            }
          }
          newPath = newPath + "/TextFiles";
          directory = Directory(newPath);*/
        } else {
          return false;
        }
      } else {
        if (await _requestPermission(Permission.storage)) {
          directory = await getTemporaryDirectory();
        } else {
          return false;
        }
      }

      if (!await directory.exists()) {
        await directory.create(recursive: true);
      }
      if (await directory.exists()) {
        File saveTxtFile = File("${directory.path}/$fileName.txt");
        File saveImgFile = File("${directory.path}/$fileName.png");

        String finalString = "";                                //parsing
        List<String> strings = text.split('\n');
        for(int i=0; i<strings.length; i++) {
          String string = strings[i];
          int start = 3;
          int end = string.length - 3;
          string = string.substring(start, end);
          if(i!=strings.length-1) string = '$string\n';
          finalString = finalString + string;
        }

        saveTxtFile.writeAsString(finalString);
        saveImgFile.writeAsBytes(photo.readAsBytesSync());
        if (Platform.isIOS) {
          await ImageGallerySaver.saveFile(saveTxtFile.path,  //qui da cambiare ma ok
              isReturnPathOfIOS: true);
        }
        return true;
      }
      return false;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> _requestPermission(Permission permission) async {
    if (await permission.isGranted) {
      return true;
    } else {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      }
    }
    return false;
  }

  Future<void> deleteFile(String fileName) async {
    Directory directory = await getApplicationDocumentsDirectory();
    File TxtFile = File("${directory.path}/$fileName.txt");
    File ImgFile = File("${directory.path}/$fileName.png");
    TxtFile.deleteSync();
    ImgFile.deleteSync();
  }
