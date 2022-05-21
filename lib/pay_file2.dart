import 'dart:convert';
import 'dart:io';
import 'package:front_kkami/connect.dart';
import 'package:front_kkami/hello.dart';
import 'package:front_kkami/playNetwrk2.dart';
import 'package:http/http.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart';
import 'package:dio/dio.dart';

import 'package:http/http.dart' as http;
import 'package:http/retry.dart';
import 'dart:convert' as convert;

class PlayLocalFile2 extends StatefulWidget {
  const PlayLocalFile2({Key? key}) : super(key: key);

  @override
  _PlayLocalFileState2 createState() => _PlayLocalFileState2();
}

class _PlayLocalFileState2 extends State<PlayLocalFile2> {
  AudioPlayer filePlayer = AudioPlayer();
  String file = 'pdf';
  //File? file = null;
  AudioCache cache = AudioCache();
  var audios;
  var t = false;

  void initState(){
    // TODO: implement initState
    super.initState();

    AudioPlayer p = LearnFlutter.player;
    AudioCache c = LearnFlutter.cache;
    //p = myplayer.MyPlayer.player;
    //AudioCache c = myplayer.MyPlayer.cache;
    p.stop();
    WidgetsBinding.instance?.addPostFrameCallback((_){
       c.play('pdf_to_speech.mp3');
    });
    //_initializeCamera(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 152, 241, 192),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'choisir un pdf',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          InkWell(
              onTap: () async {
                await getFile2();
                if(t == true){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayNetwrk2(audios: audios)),
                  );
                }
              },
              child: Icon(
                Icons.folder_open,
                size: 50,
              )),
          Text('${file.toString()}'),
        ],
      ),
    );
  }

  Future<void> getFile2() async{
    print('hhhiii1');
    try{
      final result = await FilePicker.platform.pickFiles(
              type: FileType.custom,
              allowedExtensions: [
                'pdf',
              ],
              withData: false,
              withReadStream: true,
            );
      print('hi2');
      if (result == null || result.files.isEmpty) {
        throw Exception('No files picked or file picker was canceled');
      }

      final file = result.files.first;
      //final filePath = file.path;
      final fileReadStream = file.readStream;

      if (fileReadStream == null) {
        throw Exception('Cannot read file from null stream');
      }

      final stream = http.ByteStream(fileReadStream);
      var url = Uri.http(ApiConstants.baseUrl, ApiConstants.pdfAudio + '/read/');
      final request = http.MultipartRequest('POST', url);
      final multipartFile = http.MultipartFile(
        'doc',
        stream,
        file.size,
        filename: file.name,
        //contentType: contentType,
      );
      
      print('hi3 uurrll = ' + ApiConstants.baseUrl);
      request.files.add(multipartFile);

      final httpClient = http.Client();
      final response = await httpClient.send(request);

      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}');
      }

      final body = await response.stream.transform(utf8.decoder).join();

      audios = json.decode(body);
      
      print(body);
      t = true;
    
    }catch(e) {
      print('erreur :: ' + e.toString());
    }
  }
}
