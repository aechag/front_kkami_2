import 'package:animate_do/animate_do.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:front_kkami/main.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:front_kkami/connect.dart' as myplayer;

class LearnFlutter extends StatefulWidget {
  const LearnFlutter({ Key? key }) : super(key: key);

  static late AudioPlayer player = AudioPlayer();
  static late AudioCache cache = AudioCache(fixedPlayer: player);

  @override
  _LearnFlutterState createState() => _LearnFlutterState();
}

class _LearnFlutterState extends State<LearnFlutter> {
  AudioPlayer player = LearnFlutter.player;
  AudioCache cache = LearnFlutter.cache;
  bool isPlaying =false;
  Duration currentPostion = Duration();
  Duration musicLength = Duration();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_){
       cache.play('hello.mp3');
    });
    
  }

  /*setUp(){
   player.onAudioPositionChanged.listen((d) {
     // Give us the current position of the Audio file
     setState(() {
       currentPostion = d;
     });

     player.onDurationChanged.listen((d) {
       //Returns the duration of the audio file
       setState(() {
         musicLength= d;
       });
     });
   });
  }*/

  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MusicApp()),
          );
        },
        child: new Scaffold(
      backgroundColor: Color(0xffF6DEC8),
      body:  Container(
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: 5,),
              FadeInUp(
                duration: Duration(milliseconds: 1500),
                child: Image.network('https://cdn.dribbble.com/users/3484830/screenshots/16787618/media/b134e73ef667b926c76d8ce3f962dba2.gif', fit: BoxFit.cover,)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FadeInUp(
                      delay: Duration(milliseconds: 1000),
                      duration: Duration(milliseconds: 1000),
                      child: Text("Bienvenue chez l'assistant Kkami", style: GoogleFonts.robotoSlab(
                        fontSize: 36,
                        fontWeight: FontWeight.w600
                      ),),
                    ),
                    SizedBox(height: 0,),
                    FadeInUp(
                      delay: Duration(milliseconds: 1200),
                      duration: Duration(milliseconds: 1000),
                      child: Text("vous êtes près de choisir votre fichier \nou votre image pour l'écouté?", style: GoogleFonts.robotoSlab(
                        fontSize: 16,
                        height: 1.8,
                        color: Colors.grey.shade700
                      ),),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}