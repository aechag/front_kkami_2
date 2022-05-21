import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:front_kkami/connect.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;


class Play_pdfs extends StatefulWidget {
  const Play_pdfs({Key? key}) : super(key: key);

  @override
  _Play_pdfsState createState() => _Play_pdfsState();
}


class _Play_pdfsState extends State<Play_pdfs> {
  late AudioPlayer player;
  late AudioCache cache;
  bool isPlaying = false;
  bool pdfsexiste = false;
  Duration currentPostion = Duration();
  Duration musicLength = Duration();
  int index = 0;
  //List<String> mylist= ['a.mp3','b.mp3','c.mp3', 'd.mp3', 'e.mp3'];
  List<String> mylist= ['http://192.168.124.105:8000/media/audios/page0_CCTAdXX.mp3', 'http://192.168.124.105:8000/media/audios/page0_5WDGFHW.mp3'];
  var my_pdfs;
  List my_pdfs0 = ['walo'];
  List list_audioss = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    index = 0;
   // cache.loadAll(['1.mp3','2.mp3','3.mp3', '4.mp3', '5.mp3']);
    setUp();
    WidgetsBinding.instance?.addPostFrameCallback((_){
      getpdfs();
    });
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
                    playMusic();
                    //cache.play(mylist[index]);
                  }
                  else{
                    setState(() {
                      isPlaying= true;
                    });
                    print('$index');
                    playMusic();
                    //cache.play(mylist[index]);
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
                  try{
                   playMusic();
                  }catch(e){
                   print('erreur :: ' + e.toString());
                }
              }
              },
                icon: isPlaying?Icon(Icons.pause):
                Icon(Icons.play_arrow), iconSize: 35,),

              IconButton(
                icon: Icon(Icons.last_page), iconSize: 35,
                onPressed: (){
                  if(index < mylist.length-1 ){
                    try{
                      print('$index');
                      setState(() {
                        index=index+1;
                        isPlaying=true;
                      });
                      print('$index');
                      playMusic();
                  //cache.play(mylist[index]);
                    }catch(e){
                      print('ereuur :: ' + e.toString());
                    }
                  }
                  else {
                    setState(() {
                      index=0;
                      isPlaying=true;
                    });
                    print("$index");
                    playMusic();
                    //cache.play(mylist[index]);
                  }
                },
               )
            ],
          ),
          Text('${my_pdfs0[index]}')
        ],
      ),
    );
  }

  playMusic2(String song)
  { // to play the Audio
     cache.play(song);
  }
  var count = 0;
  playMusic() async{
    cache.play(list_audioss[25][count]);
    count = count + 1;
    player.onPlayerCompletion.listen((event) {
      if(count<list_audioss[index].length){
        playMusic();
      }else{
        player.stop();
        setState(() {
          isPlaying =true;
        });         
      }
    });
  }
  stopMusic()
  {// to pause the Audio
    player.pause();
  }
  stopMusic2()
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
  /**get all pds */
  Future getpdfs() async {
    print('hi pdfs');
    //var pdfs = [];
    try{
      var url = Uri.http(ApiConstants.baseUrl, ApiConstants.pdfAudio + '/all/');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        my_pdfs = convert.jsonDecode(response.body);
        print('Request success status: ${response.statusCode}.');
        //print(my_pdfs);
        //my_pdfs0.clear();
        /*for(var i=0; i<my_pdfs.length; i++){
          my_pdfs0.add(my_pdfs[i]['id']);
        }*/
        print(my_pdfs0[0]);
        pdfsexiste = true;
        my_pdfs0.clear();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      } 
    }catch(e){
      print('exception :: ' + e.toString());
    }
    try{
      for(var i=0; i<my_pdfs.length; i++){
        //print('my_pdfs id : ' + my_pdfs[i]['id'].toString() + '  ' + 'my_pdfs nbrpage : '+ my_pdfs[i]['nbr_page_read'].toString());
        my_pdfs0.add(my_pdfs[i]['id']);
        await get_audios(my_pdfs[i]['id'], my_pdfs[i]['nbr_page_read']);
      }
      print('finally1    ----  ' + my_pdfs0.toString());
      print('finally2    -- '+ list_audioss.length.toString() +' --  ' + list_audioss.toString());
    }catch(e){
      print('exception :: ' + e.toString());
    }
  }
/**get audios by pdf */
  Future get_audios(pdf_id, pdf_page_read) async{
    print('hi audios');
    try{
      var map = new Map<String, dynamic>();
      map['pdf_id'] = pdf_id.toString();
      map['nbr_page'] = pdf_page_read.toString();

      var url = Uri.http(ApiConstants.baseUrl, ApiConstants.pdfAudio + '/get/');
      final response = await http.post(url, body: map,);
      
      if (response.statusCode == 200) {
        //print('Request success status: ${response.statusCode}.');
        var mylist = convert.jsonDecode(response.body);
        //print(mylist);
        list_audioss.add(mylist);

      } else {
        print('Request failed with status: ${response.statusCode}.');
      } 
    }catch(e){
      print('exception :: ' + e.toString());
    }
  }

}
