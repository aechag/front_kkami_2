import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:front_kkami/connect.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:front_kkami/hello.dart' as hello;

class PlayMusic extends StatefulWidget {
  const PlayMusic({Key? key}) : super(key: key);

  @override
  _PlayMusicState createState() => _PlayMusicState();
}


class _PlayMusicState extends State<PlayMusic> {
  late AudioPlayer player;
  late AudioCache cache;
  bool isPlaying =false;
   Duration currentPostion = Duration();
   Duration musicLength = Duration();
   int index =0;
   List<String> mylist= ['a.mp3','b.mp3','c.mp3', 'd.mp3', 'e.mp3'];
   //var mylist;

   @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    index = 0;
   // cache.loadAll(['1.mp3','2.mp3','3.mp3', '4.mp3', '5.mp3']);
    setUp();
    //mylist = getpdfs();
  }
  setUp(){
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: 400,
            width: double.infinity,
            child: Text('Play Music', style: TextStyle(fontSize: 35, color: Colors.white),),
            alignment: Alignment.center,
            color: Colors.indigo,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text('${currentPostion.inSeconds}'),
              Container(
                  width: 300,
                  child: Slider(
                      value: currentPostion.inSeconds.toDouble(),
                      max: musicLength.inSeconds.toDouble(),
                      onChanged: (val){
                        seekTo(val.toInt());
                      })
              ),
              Text('${musicLength.inSeconds}'),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: Icon(Icons.first_page), iconSize: 35,
                onPressed: (){
                  if(index>0) {
                    setState(() {
                      index--;
                      isPlaying= true;
                      print('$index');
                    });
                    cache.play(mylist[index]);
                  }
                  else{
                    setState(() {
                      isPlaying= true;

                    });
                    print('$index');
                    cache.play(mylist[index]);
                  }
              }, ),
              IconButton(onPressed: (){
               if(isPlaying)
                 {
                   setState(() {
                     isPlaying = false;
                   });
                   stopMusic();
                 }
               else {
                 setState(() {
                   isPlaying = true;
                 });
                 playMusic(mylist[index]);
               }
              },
                icon: isPlaying?Icon(Icons.pause):
                Icon(Icons.play_arrow), iconSize: 35,),

              IconButton(
                icon: Icon(Icons.last_page), iconSize: 35,
                onPressed: (){
                     if(index < mylist.length-1 )
                  {  print('$index');
                  setState(() {
                    index=index+1;
                    isPlaying=true;
                  });
                  print('$index');
                  cache.play(mylist[index]);
                  }
                  else {
                    setState(() {
                      index=0;
                      isPlaying=true;
                    });
                    print("$index");
                    cache.play(mylist[index]);
                  }
                },
               )
            ],
          ),
          Text('${mylist[index]}')
        ],
      ),
    );
  }

  playMusic(String song)
  { // to play the Audio
     cache.play(song);
  }
  stopMusic()
  {// to pause the Audio
    player.pause();
  }
  seekTo(int sec)
  {// To seek the audio to a new position
    player.seek(Duration(seconds: sec));
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

  /*-------------------my data-----------------------*/
  Future getpdfs() async {
    //var pdfs = [];
    try{
      var url = Uri.http(ApiConstants.baseUrl, ApiConstants.pdfAudio + '/all/');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        var pdfs = convert.jsonDecode(response.body)[0];
        print('Request success status: ${response.statusCode}.');
        print(pdfs);
        return pdfs;
      } else {
        print('Request failed with status: ${response.statusCode}.');
      } 
    }catch(e){
      print('exception :: ' + e.toString());
    }
    return [];
  }

}
