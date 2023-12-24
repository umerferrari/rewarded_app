import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerProvider extends ChangeNotifier {



  Future<File?> cropImage({required File imageFile}) async {

    final CropAspectRatio aspectRatio = CropAspectRatio(ratioX: 1.1, ratioY: 1.0);
    final CroppedFile? croppedImage = await ImageCropper().cropImage(
        aspectRatio: aspectRatio,
        sourcePath: imageFile.path);

    if (croppedImage == null) return null;
    return File(croppedImage.path);
  }

  // ... existing code ...
  File? getImageSignUp;

  Future<void> pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      getImageSignUp = img;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
  Future<void> pickCameraImageSignUp() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      getImageSignUp = img;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }

  File? getImageGroupIcon;

  Future<void> pickImageGroupIcon() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      getImageGroupIcon = img;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }
  Future<void> pickImageGroupCameraIcon() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.camera);
      if (image == null) return;
      File? img = File(image.path);
      img = await cropImage(imageFile: img);
      getImageGroupIcon = img;
      notifyListeners();
    } on PlatformException catch (e) {
      print(e);
    }
  }

}
