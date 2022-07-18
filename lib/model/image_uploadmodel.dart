


import 'dart:io';

import 'package:flutter/material.dart';

class ImageUploadModel {
  bool isUploaded;
  bool uploading;
 File imageFile;
  String imageUrl;

  ImageUploadModel({
    required this.isUploaded,
    required  this.uploading,
    required this.imageFile,
    required   this.imageUrl,
  });
}