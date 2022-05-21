import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:dio/dio.dart';
import 'package:front_kkami/TakePicturePage%20.dart';
import 'package:front_kkami/connect.dart';
import 'package:front_kkami/hello.dart';
import 'package:front_kkami/playNetwrk2.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import 'package:image_picker/image_picker.dart';

import 'package:image/image.dart' as img;

import 'package:path/path.dart';

class Get_image extends StatefulWidget {
  const Get_image({Key? key}) : super(key: key);

  @override
  _Get_imageState createState() => _Get_imageState();
}

class _Get_imageState extends State<Get_image> {
  //AudioPlayer filePlayer = AudioPlayer();
  String file = 'photo';
  late File final_image;
  var audio = [];
  var t = false;

  late Future<void> _initializeControllerFuture;
  late CameraController _controller;
  var isCameraReady = false;
  var showCapturedPhoto = false;
  var ImagePath;

  @override
  void initState(){
    // TODO: implement initState
    super.initState();

    AudioPlayer p = LearnFlutter.player;
    AudioCache c = LearnFlutter.cache;
    p.stop();
    WidgetsBinding.instance?.addPostFrameCallback((_){
       c.play('image_to_speech.mp3');
    });
    //_initializeCamera(); 
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 245, 201, 225),
      alignment: Alignment.center,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'prend une photo',
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          SizedBox(
            height: 35,
          ),
          //if (provider.image != null) Image.network(provider.image.path),
          InkWell(
              onTap: () async {
                await imggetandsend();
                if(t == true){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PlayNetwrk2(audios: audio)),
                  );
                }
              },
              child: Icon(
                Icons.camera_alt_outlined,
                size: 50,
              )
          ),
          Text('${file.toString()}'),
        ],
      ),
    );
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;
    _controller = CameraController(firstCamera,ResolutionPreset.high);
    _initializeControllerFuture = _controller.initialize();
    if (!mounted) {
      return;
    }
    setState(() {
      isCameraReady = true;
    });
  }

  imggetandsend() async{
    final ImagePicker _picker = ImagePicker();
    final image = await _picker.pickImage(source: ImageSource.camera);

    var url = Uri.http(ApiConstants.baseUrl, ApiConstants.imageAudio + '/detectText/');
    final request = http.MultipartRequest('POST', url);

    if(image != null){
      var fimage = image;
      try{
        Uint8List data = await fimage.readAsBytes();
        List<int> list = data.cast();
        request.files.add(http.MultipartFile.fromBytes('image', list, filename: 'myFile.png'));
        var response = await request.send();
        final body = await response.stream.transform(utf8.decoder).join();

        var myaudio = json.decode(body);
        audio.add(myaudio);
        t = true;

        print(response.statusCode);
        print(myaudio);

      }catch(e){
        print('ereeeeeue :: ' + e.toString());
      }
    }
  }
}