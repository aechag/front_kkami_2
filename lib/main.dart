import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:front_kkami/ass_audiop.dart';
import 'package:front_kkami/get_image.dart';
import 'package:front_kkami/hello.dart';
import 'package:front_kkami/pay_file2.dart';
import 'package:front_kkami/play_file.dart';
import 'package:front_kkami/play_music.dart';
import 'package:front_kkami/play_network.dart';
import 'package:front_kkami/playNetwrk2.dart';
import 'package:front_kkami/play_pdf2.dart';
import 'package:front_kkami/play_pdfs.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home:MusicApp(),
      routes: {
        '/': (context) => const LearnFlutter(),
        '/second': (context) => MusicApp(),
      },
    );
  }
}
class MusicApp extends StatefulWidget {
  const MusicApp({Key? key}) : super(key: key);

  @override
  MusicAppState createState() => MusicAppState();
}

class MusicAppState extends State<MusicApp> {
  List<Widget> myWidget=[Playpdf2(), Get_image(), PlayLocalFile2()];
  int pageIndex= 0; //curent index
  PageController page_contrl =  PageController(initialPage: 0);

  selectPage(int val)
  {
    setState(() {
      pageIndex=val;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //body: myWidget[pageIndex],
      body: PageView(
        controller: page_contrl,
        onPageChanged: (newindex){
          selectPage(newindex);
        },
        children: [
          Playpdf2(), 
          Get_image(), 
          PlayLocalFile2(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: pageIndex,
        //onTap: selectPage,
        onTap: (index){
          page_contrl.animateToPage(index, duration: Duration(milliseconds: 500), curve: Curves.ease);
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.music_note), label: 'tous les pdfs'),
          BottomNavigationBarItem(icon:Icon( Icons.camera_alt),label: 'lire photo'),
          BottomNavigationBarItem(icon: Icon(Icons.folder),label: 'lire pdf')
        ],
      ),
    );
  }
}

