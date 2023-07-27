import 'package:Somnolence/components/square_tile.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';  
import 'driving.dart';
import 'noise_page.dart';
import 'calendar.dart';
import 'components/square_tile.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:Somnolence/noise_page.dart';
import 'package:Somnolence/video.dart';
   
class HomePage extends StatelessWidget {  
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override  
  Widget build(BuildContext context) {
    print("Hello");
    return MaterialApp(  
      debugShowCheckedModeBanner: false,
      home: Scaffold(  
        backgroundColor: Color.fromARGB(255, 230, 179, 178),
          body: Center(
            child: SingleChildScrollView(
              child: Column(
              children: [
                Image.asset('assets/image_png.png', height: 100,),

                SizedBox(height: 30),
                SquareTile(
                  title: 'How to use:',
                  text: 'Below are many buttons to help make your drive more safe. First is the \'Start Driving\' button where when pressing it starts your camera and records when you feel sleepy. Then is the \'Alarm Noise\', which sets your alarm to wake you up if you fall asleep. After that we have our calender. It is used to record when you felt sleepy. Lastly we have a \'Logout\' button which logs you out of the app ',
                
                ),

                ElevatedButton(
                onPressed: () {
                  // final player = AudioPlayer();
                  // player.setSource(AssetSource('alarm.mp3'));
                  Navigator.push(context, MaterialPageRoute(builder: (context) => Video()));
                },
                style: ElevatedButton.styleFrom(
                    fixedSize: Size(240, 80),
                    backgroundColor: Colors.pink,
                ),
                child: Text("Start Driving",
                  style: TextStyle(
                    fontSize: 20,
                  ),),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Noise_Page()));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(240, 80),
                      backgroundColor: Colors.pink,
                  ),
                  child: Text("Alarm Noise",
                    style: TextStyle(
                      fontSize: 20,
                    ),),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Calendar()));
                  },
                  style: ElevatedButton.styleFrom(
                      fixedSize: Size(240, 80),
                      backgroundColor: Colors.pink,
                  ),
                  child: Text("Calendar",
                    style: TextStyle(
                      fontSize: 20,
                    ),),
                ),
                const SizedBox(height: 20,),
                ElevatedButton(
                  onPressed: signUserOut, 
                style: ElevatedButton.styleFrom(  
                    fixedSize: Size(240, 80),
                    backgroundColor: Colors.redAccent,
                    foregroundColor: Colors.white
                  ),
                  child: Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 20,
                    ),
                  )
                )
              ],
            )
          ), 
        )   
      ),
    );  
  }  
  }