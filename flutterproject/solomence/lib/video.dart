import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:camera_web/camera_web.dart';
import 'main.dart';
import 'dart:io' show Platform;
import 'package:Somnolence/api.dart';
import 'package:flutter/foundation.dart';

class Video extends StatefulWidget {
  const Video({super.key});

  @override
  State<Video> createState() => _VideoState();
}

class _VideoState extends State<Video> {
  CameraImage? cameraImage;
  CameraController? cameraController;
  String output = '';

  @override
  void initState() {
    super.initState();
    loadCamera();
    initializeCamera();
  }

  void initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();
    if (cameras.isNotEmpty) {
      if (kIsWeb) {
        cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      } else {
        // Use camera_web plugin for web platforms
        cameraController = CameraController(cameras[0], ResolutionPreset.medium);
      }

      try {
        await cameraController!.initialize();
        if (mounted) {
          setState(() {
            cameraController!.startImageStream((imageStream) {
              cameraImage = imageStream;
            });
          });
        }
      } catch (e) {
        print("Error initializing camera: $e");
      }
    } else {
      print("No cameras available");
    }
    }

  loadCamera() {
    print("LoadedCamera");
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value){
      if(!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
          });
        });
      }
    });
  }

  @override
  void dispose() {
    cameraController?.dispose();
    Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:Text('Live Camera View')
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: !cameraController!.value.isInitialized?
                  Container():
                  AspectRatio(aspectRatio: cameraController!.value.aspectRatio,
                  child: CameraPreview(cameraController!))
            ),
          ), 
          Text(
            output,
            style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),
          ),
        ],
      ),
    );
  }
}
