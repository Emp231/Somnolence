import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'calendar.dart';
import 'driving.dart';
import 'homepage.dart';
import 'main.dart';

class Noise_Page extends StatefulWidget {
  const Noise_Page({Key? key}) : super (key: key);

  @override
  State<Noise_Page> createState() => _Noise_Page_State();
}


class _Noise_Page_State extends State<Noise_Page>{
  String? valueChoose;
  List<String> listItem = ["Alarm 1", "Alarm 2", "Alarm 3"];
  final player = AudioPlayer();
    
  Future<void> playAudioFromUrl(String url) async {
    await player.play(UrlSource(url));
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Alarm Noise'),
        leading: GestureDetector(
          onTap: () {
            // Handle leading icon tap if needed
          },
          child: Icon(
            Icons.menu,
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.directions_car_filled),
              title: const Text('Driving'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Driving_Page()));
              },
            ),
            ListTile(
              leading: Icon(Icons.calendar_today),
              title: const Text('Calendar'),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar()));
              },
            ),
          ],
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RawMaterialButton(
              child: Text("Click Here"),
              fillColor: Colors.lightBlueAccent,
              onPressed: () {
                final player = AudioPlayer();
                player.play(AssetSource('audio/alarm.wav'));
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: DropdownButton(
                  hint: Text("Select Items: "),
                  icon: Icon(Icons.arrow_drop_down),
                  iconSize: 36,
                  isExpanded: true,
                  underline: SizedBox(),
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                  value: valueChoose,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue as String;
                    });
                  },
                  items: listItem.map((valueItem) {
                    return DropdownMenuItem(
                      value: valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

  
}