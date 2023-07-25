import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'main.dart';

class Calendar extends StatefulWidget {
  const Calendar({super.key});

  @override
  State<Calendar> createState() => Calendar_State();
}

class Calendar_State extends State<Calendar> {

  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Title(color: Color.fromARGB(255, 167, 255, 181), child: Text('Log'),),
          centerTitle: true,
        ),
        body: Column(
          children: [

            // Log list
          ],
        ),
      )
    );
  }
}