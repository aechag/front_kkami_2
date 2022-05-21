import 'dart:convert';
//import 'dart:html';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:front_kkami/connect.dart';
import 'dart:convert' as convert;

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';

class PlayNetwrk2 extends StatefulWidget {
  var audios;
  //const PlayNetwrk2({Key? key}) : super(key: key);
  PlayNetwrk2({Key? key,@required this.audios}) : super(key: key);
  
  @override
  _PlayNetwrk2State createState() => _PlayNetwrk2State(audios);
}

class _PlayNetwrk2State extends State<PlayNetwrk2>{

  var audios;
  _PlayNetwrk2State(this.audios);
  
  List<String> myList = ["http://192.168.124.105:8000/media/audios/page0_CCTAdXX.mp3", "http://192.168.124.105:8000/media/audios/page0_m2gfSLD.mp3"];
  String url = '';
  int count = 0;
  var p;
  
  late AudioPlayer player;
  late AudioCache cache;
  bool isPlaying= false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    player = AudioPlayer();
    //p = responce();
    //cache = AudioCache(fixedPlayer: player);
    //change_page(1);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    body: Container(
      width:double.infinity ,
      height: double.infinity,
      decoration: BoxDecoration(
       gradient: LinearGradient(
         colors: [
           Colors.blue,
           Colors.indigo,
           Colors.black87
         ]
       )
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 50,),
            Text(' Lire ',style: TextStyle(fontSize:30,color:Colors.white ),),
            SizedBox(height: 50,),

            InkWell(
                onTap: ()async{
                  if(isPlaying) {
                    stopPlay();
                    setState(() {
                      isPlaying = false;
                    });
                  }
                  else{
                    setState(() {
                        isPlaying =true;
                    });
                    //count = 0;
                    playFromNet();
                  }
                }, 
                child: Icon(isPlaying?Icons.pause:Icons.play_arrow,size: 45,color: Colors.white,)
            ),

          ],
      ),
     )
    );
  }
  playFromNet() async{
    player.play(audios[count]);
    count = count + 1;
    player.onPlayerCompletion.listen((event) {
      if(count<audios.length){
        playFromNet();
      }else{
        player.stop();
        setState(() {
          isPlaying =true;
        });         
      }
    });
  }
  stopPlay(){
    player.stop();
  }
  onComplete()async{
    count = count + 1;
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    player.dispose();
  }

/**post */
  Future change_page(count) async{
    try{
      var url = Uri.http(ApiConstants.baseUrl, ApiConstants.pdfAudio + '/update_count/');
      final response = await http.post(url, headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              },
              body: jsonEncode({
                'id': 36,
                'nbr_page': count,
              }),
      );
      
      if (response.statusCode == 200) {
        print('ok');
        print('Request success status: ${response.statusCode}.');
      } else {
        print('Request failed with status: ${response.statusCode}.');
      } 
    }catch(e){
      print('exception :: ' + e.toString());
    }
    return [];
  }
/**get */
  Future responce() async {
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

