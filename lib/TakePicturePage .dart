import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';

class TakePicturePage extends StatefulWidget {
  //final CameraDescription camera;
  var camera;
  TakePicturePage({@required this.camera});

  @override
  _TakePicturePageState createState() => _TakePicturePageState();
}

class _TakePicturePageState extends State<TakePicturePage> {
  late CameraController _cameraController;
  late Future<void> _initializeCameraControllerFuture;

  @override
  void initState() {
    super.initState();

    _cameraController =
        CameraController(widget.camera, ResolutionPreset.medium);

    _initializeCameraControllerFuture = _cameraController.initialize();
  }
   @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      FutureBuilder(
        future: _initializeCameraControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    ]);
  }
}


// ***************************************************************masd9chhhhhh********************************** *//
/*
Future getimg() async{
    /*WidgetsFlutterBinding.ensureInitialized();
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      firstCamera,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
*/
    final ImagePicker _picker = ImagePicker();

    try {
      //final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      // Ensure that the camera is initialized.
      /*print('hello');
      await _initializeControllerFuture;
      print('is initialized');
      /*final image = await _controller.takePicture();
      File p = File(image.path);
      final path = image.path;
      final bytes = await File(path).readAsBytes();
      final img.Image? img0 = img.decodeImage(bytes);
      print('image taken::   ');*/
      final xFile = await _controller.takePicture();
      final path = xFile.path;
      final bytes = await File(path).readAsBytes();
      final img.Image? image = img.decodeImage(bytes);
      print('image taken::   ');*/
    } catch (e) {
      // If an error occurs, log the error to the console.
      print( "ereuue :: " + e.toString());
    }
    try{
      /*final CameraDescription camera;
      _controller = CameraController(
        // Get a specific camera from the list of available cameras.
        widget.camera,
        // Define the resolution to use.
        ResolutionPreset.medium,
      );*/

    // Next, initialize the controller. This returns a Future.
     // _initializeControllerFuture = _controller.initialize();

      /*
              //ui.platformViewRegistry.registerViewFactory('webcamVideoElement', (int viewId) => _webcamVideoElement);
        window.navigator.getUserMedia(video: true).then((MediaStream stream) {
        _webcamVideoElement.srcObject = stream;
        });
        if(_webcamVideoElement.srcObject.active){ 
          _webcamVideoElement.play();
        }else{
           _webcamVideoElement.pause();
        }
       */
    }catch(e) {
      print('erreur :: ' + e.toString());
    }
  }
  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }
  void _showCamera() async {

    final cameras = await availableCameras();
    final camera = cameras.first;

    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TakePicturePage(camera: camera)));

  }
 */