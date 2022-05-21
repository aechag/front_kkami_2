import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/cupertino.dart';

class ApiConstants {
  static String baseUrl = '192.168.124.105:8000'; /*'127.0.0.1:8000'*//*10.0.2.2:8000*/ 
  static String imageAudio = '/detecttxt';
  static String pdfAudio = '/doc';
}

/*class MyPlayer {

  static late AudioPlayer player;
  static late AudioCache cache;

  MyPlayer() {
    // TODO: implement initState
    player = AudioPlayer();
    cache = AudioCache(fixedPlayer: player);
  }
}*/

class MyPlayer {
  static AudioPlayer get player => AudioPlayer();
  static AudioCache get cache => AudioCache(fixedPlayer: player);
  
  
}