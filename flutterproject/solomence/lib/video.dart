import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:camera_web/camera_web.dart';
import 'main.dart';
import 'dart:io' show Platform;

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
    loadmodel();
    initializeCamera();
  }

  void initializeCamera() async {
    List<CameraDescription> cameras = await availableCameras();

    if (Platform.isAndroid || Platform.isIOS) {
      if (cameras.isNotEmpty) {
        cameraController = CameraController(cameras[0], ResolutionPreset.medium);
        await cameraController!.initialize();
        if (mounted) {
          setState(() {
            cameraController!.startImageStream((imageStream) {
              cameraImage = imageStream;
              runModel();
            });
          });
        }
      }
    } else {
        if (cameras.isNotEmpty) {
          cameraController = CameraController(cameras[0], ResolutionPreset.medium);
          try {
            await cameraController!.initialize();
            if (mounted) {
              setState(() {
                cameraController!.startImageStream((imageStream) {
                  cameraImage = imageStream;
                  runModel();
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
  }

  loadCamera() {
    cameraController = CameraController(cameras![0], ResolutionPreset.medium);
    cameraController!.initialize().then((value){
      if(!mounted) {
        return;
      } else {
        setState(() {
          cameraController!.startImageStream((imageStream) {
            cameraImage = imageStream;
            runModel();
          });
        });
      }
    });
  }

  runModel()async{
    if(cameraImage != null) {
      var predictions = await Tflite.runModelOnFrame(
        bytesList: cameraImage!.planes.map((plane) {
          return plane.bytes;
      }).toList(),
      imageHeight: cameraImage!.height, 
      imageWidth: cameraImage!.width,
      imageMean: 127.5,
      imageStd: 127.5,
      rotation: 90,
      numResults: 2,
      threshold: 0.1,
      asynch: true);
      predictions!.forEach((element) {
        setState(() {
          output = element['label'];
        });
      });

      if (predictions != null && predictions.isNotEmpty) {
        // Print the predictions to check if they are valid
        print(predictions);

        // Assuming the model returns a list of predictions with 'label' key
        String modelOutput = predictions[0]['label'];
        setState(() {
          output = modelOutput;
      });
    } else {
        print("Model did not return any predictions.");
    }
    }
  }

  loadmodel() async {
    await Tflite.loadModel(model: "assets/model.tflite", labels: "assets/labels.txt");
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
          Text(output,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20
          ))
        ],
      ),
    );
  }
}

