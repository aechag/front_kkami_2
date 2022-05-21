import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:front_kkami/connect.dart';

import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

import 'package:front_kkami/hello.dart';

class Playpdf2 extends StatefulWidget {
  const Playpdf2({Key? key}) : super(key: key);

  @override
  _Playpdf2State createState() => _Playpdf2State();
}

class _Playpdf2State extends State<Playpdf2> {
  late AudioPlayer player;
  late AudioCache cache;
  bool isPlaying =false;
  Duration currentPostion = Duration();
  Duration musicLength = Duration();
  int index = 0;
  int count = 0;
  //List<String> mylist= ['a.mp3','b.mp3','c.mp3', 'd.mp3', 'e.mp3'];
  //List<String> mylist = ['http://192.168.124.105:8000/media/audios/page0_CCTAdXX.mp3', 'http://192.168.124.105:8000/media/audios/page0_5WDGFHW.mp3'];
  
  List<String> mypdfs = ['doc name'];
  List myaudios = [];

  late AudioPlayer p;  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
    //index = 0;
   // cache.loadAll(['1.mp3','2.mp3','3.mp3', '4.mp3', '5.mp3']);
    setUp();
    //hello.LearnFlutterState e = new hello.LearnFlutterState();
    //e.player.stop();
    WidgetsBinding.instance?.addPostFrameCallback((_){
      responce();
    });

    p = LearnFlutter.player;
    AudioCache c = LearnFlutter.cache;
    p.stop();
    WidgetsBinding.instance?.addPostFrameCallback((_){
       c.play('list_pdfs.mp3');
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
            child: Text('ancien pdfs', style: TextStyle(fontSize: 35, color: Colors.white),),
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
                  stopMusic();
                  if(index>0) {
                    setState(() {
                      index--;
                      isPlaying= true;
                      print('$index');
                    });
                    //playMusic(mylist[index]);
                    playMusic(myaudios[index]);
                  }
                  else{
                    setState(() {
                      isPlaying= true;
                    });
                    print('$index');
                    //playMusic(mylist[index]);
                    playMusic(myaudios[index]);
                  }
              },
              ),
              IconButton(
                onPressed: (){
                  stopMusic();
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
                    //playMusic(mylist[index]);
                    playMusic(myaudios[index]);
                  }
                },
                icon: isPlaying?Icon(Icons.pause):
                Icon(Icons.play_arrow), iconSize: 35,),

              IconButton(
                icon: Icon(Icons.last_page), iconSize: 35,
                onPressed: (){
                  stopMusic();
                  if(index < myaudios.length-1 ){  
                    print('$index');
                    setState(() {
                      index++;
                      isPlaying=true;
                    });
                    print('$index');
                    //playMusic(mylist[index]);
                    playMusic(myaudios[index]);
                  }
                  else {
                    setState(() {
                      index=0;
                      isPlaying=true;
                    });
                    print("$index");
                    //playMusic(mylist[index]);
                    playMusic(myaudios[index]);
                  }
                },
              )
            ],
          ),
          Text('${mypdfs[index]}')
          //Text('walodima')
        ],
      ),
    );
  }

  playMusic0(String song)
  { // to play the Audio
     cache.play(song);
  }

  playMusic(List pages){
    //player = AudioPlayer();
    try{
      p.stop();
      cache.play(pages[count]);
      count = count + 1;
      player.onPlayerCompletion.listen((event) {
        if(count<pages[count].length){
          playMusic(pages);
        }else{
          count = 0;
          player.stop();
          setState(() {
            isPlaying = false;
          });         
        }
      });
    }catch(e){
      print('ereuur :: ' + e.toString());
    }
  }
  
  stopMusic()
  {// to pause the Audio
    player.pause();
    count = 0;
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
    count = 0;
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

/*-------------------my data-----------------------*/
  /**get all pds */
  Future responce() async {
    print('hi pdfs');
    var my_pdfs;
    try{
      var url = Uri.http(ApiConstants.baseUrl, ApiConstants.pdfAudio + '/all/');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        my_pdfs = convert.jsonDecode(response.body);
        print('Request success status: ${response.statusCode}.');
        mypdfs.clear();
      } else {
        print('Request failed with status: ${response.statusCode}.');
      } 
    }catch(e){
      print('exception :: ' + e.toString());
    }
    try{
      for(var i=0; i<my_pdfs.length; i++){
        //print('my_pdfs id : ' + my_pdfs[i]['id'].toString() + '  ' + 'my_pdfs nbrpage : '+ my_pdfs[i]['nbr_page_read'].toString());
        mypdfs.add(my_pdfs[i]['name'].toString());
        await getAudios(my_pdfs[i]['id'].toString(), my_pdfs[i]['nbr_page_read'].toString());
      }
      print('finally1    ----  ' + my_pdfs.toString());
      print('finally2    -- '+ myaudios.length.toString() +' --  ' + myaudios.toString());
    }catch(e){
      print('exception :: ' + e.toString());
    }
  }
/**get audios by pdf */
  Future getAudios(pdf_id, pdf_page_read) async{
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
        myaudios.add(mylist);

      } else {
        print('Request failed with status: ${response.statusCode}.');
      } 
    }catch(e){
      print('exception :: ' + e.toString());
    }
  }

}
