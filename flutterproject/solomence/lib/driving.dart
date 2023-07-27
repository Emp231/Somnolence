import 'package:flutter/material.dart';

class Driving_Page extends StatefulWidget {
  const Driving_Page({super.key});

  @override
  State<Driving_Page> createState() => _Driving_PageState();
}

class _Driving_PageState extends State<Driving_Page> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        appBar: AppBar(
          title: Title(color: Color.fromARGB(255, 167, 255, 181), child: Text('Driving Mode'),),
          centerTitle: true,
        ),

        body: Center(
          child: Column(
            children: [
              SizedBox(
                height: 60,
              ),
              ElevatedButton(
                onPressed: () {}, 
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(340, 200),
                ),
                child: Text('Stop Alarm',
                  style: TextStyle(fontSize: 20),)
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {}, 
                child: Text('Driving Mode: Off',
                  style: TextStyle(fontSize: 20),),
              )
            ],
          )
        )
      )
    );
  }
}