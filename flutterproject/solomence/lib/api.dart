import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:typed_data';

Future<void> sendImageToServer(CameraImage image) async {
  
  String base64Image = convertCameraImageToBase64(image);
  
  var url = null; // Add Url Here
  var response = await http.post(
    url, 
    body: {"image": base64Image}, 
  );

  if (response.statusCode == 200) {
    Map<String, dynamic> jsonRes = jsonDecode(response.body);
    List<String> result = List<String>.from(jsonRes["result"]);
    print("Classification Result: $result");
  }
  else {
    print("FAILED");
  }
}


String convertCameraImageToBase64(CameraImage image) {
  final int width = image.width;
  final int height = image.height;

  final Uint8List rgbBytes = Uint8List(width * height * 3);
  int uvIndex = 0;
  int rgbIndex = 0;
  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      final int yIndex = y * width + x;
      final int uvPlaneOffset = (y >> 1) * image.planes[1].bytesPerRow + (x >> 1) * 2;
      final int yValue = image.planes[0].bytes[yIndex];
      final int uValue = image.planes[1].bytes[uvPlaneOffset];
      final int vValue = image.planes[1].bytes[uvPlaneOffset + 1];

      int r = (yValue + (1.370705 * (vValue - 128))).round().clamp(0, 255);
      int g = (yValue - (0.698001 * (vValue - 128)) - (0.337633 * (uValue - 128))).round().clamp(0, 255);
      int b = (yValue + (1.732446 * (uValue - 128))).round().clamp(0, 255);

      rgbBytes[rgbIndex++] = r;
      rgbBytes[rgbIndex++] = g;
      rgbBytes[rgbIndex++] = b;
    }
  }

  String base64Image = base64.encode(rgbBytes);
  return base64Image;
}