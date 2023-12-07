// ignore_for_file: use_build_context_synchronously
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
// ignore: depend_on_referenced_packages
import 'package:latlong2/latlong.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:untitled/user.dart';
import 'problems.dart';
import 'application.dart';
import 'form.dart';


main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(apiKey: 'AIzaSyAsQef8q69Q4OkeI-_PDb5YASJsGmqiVOA', appId: '1:554234008708:android:11d0ac7e6ee4df5c14ded1'
        , messagingSenderId: '554234008708'	, projectId: 'auth-jaljeevan', storageBucket: 'auth-jaljeevan.appspot.com' ,
    )
  );
  await FirebaseAppCheck.instance.activate();
  runApp( const MaterialApp(
    home: MyApp()));
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  double $lat = 16.48;
  double $long = 80.69;
  FirebaseAppCheck appCheck = FirebaseAppCheck.instance;

  @override
  void initState() {
    super.initState();
    getCurrentLocation();
  }

  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location is disabled');
    }
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permission denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    setState(() {
      $lat = position.latitude;
      $long = position.longitude;
    });
  }

  @override
  Widget build(BuildContext context) {
    getCurrentLocation();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Jal Jeevan'),
      ),
      body:SlidingUpPanel (
          maxHeight: MediaQuery.of(context).size.height*0.65,
        parallaxEnabled: true,
        parallaxOffset: 0.7,
        body: _map($lat,$long),
        panel: _buildPanel(context),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
      ),
    );
  }
}


Widget _buildPanel(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(10),
    child: SingleChildScrollView( child:
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildDragHandle(),
        const SizedBox(height: 15),
        Center(child:
          Column(children:[
            ElevatedButton(
              onPressed: () async {
                GoogleAuthService googleAuthService = GoogleAuthService();
                User? user = FirebaseAuth.instance.currentUser;
                if (user != null) {
                  Navigator.push(context,MaterialPageRoute(builder: (context)=> const RForm()));
                  // Navigate to the next screen or perform other actions.
                } else {
                  user = await googleAuthService.signInWithGoogle();
                }
              },
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.9,60)),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)
                  ),
                ),
              ),
              child: const Text('Raise the problem'),
            ),
          ]),
        ), //Raise your problem button

        const Divider(
          thickness: 1,  // Adjust thickness as needed
          color: Colors.grey,
        ),

        const Center(child:
          Column(children:[
            Row( children:[
              Icon(
                Icons.water_drop,
                color: Colors.blue,
                size: 20.0,
              ),
              Text(
                'About Water',
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),
            ]),
            Divider(
              thickness: 1,  // Adjust thickness as needed
              color: Colors.grey,
            ),
            Text(
              '''        Water is essential for human survival. It supports bodily functions, regulates temperature, aids digestion, and helps transport nutrients. Adequate daily intake varies, but a common recommendation is around 8 cups (about 2 liters). Dehydration can lead to various health issues, so staying hydrated is crucial.
              
              Access to clean water is a fundamental human right, and water rights are essential to ensure fair distribution and prevent scarcity-related conflicts. Proper management of water resources is crucial for sustainable development and environmental preservation. ''',
              style: TextStyle(fontSize: 15.0),
            ),
            Divider(
              thickness: 1,  // Adjust thickness as needed
              color: Colors.grey,
            ),
          ]),
        ),//About Water

        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Application()));
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.3,50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
            ),
            child: const Text('App info'),
          ),

          SizedBox(width: MediaQuery.of(context).size.width*0.02),

          ElevatedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ProblemListScreen()));
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.3,50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
            ),
            child: const Text('Problems'),
          ),

          SizedBox(width: MediaQuery.of(context).size.width*0.02),

          ElevatedButton(
            onPressed: () async {
              GoogleAuthService googleAuthService = GoogleAuthService();
              User? user = FirebaseAuth.instance.currentUser;

              if (user != null) {
                Navigator.push(context,MaterialPageRoute(builder: (context)=>  UserP(context)));
                // Navigate to the next screen or perform other actions.
              } else {
                user = await googleAuthService.signInWithGoogle();
              }
            },
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all(Size(MediaQuery.of(context).size.width*0.3,50)),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)
                  )
              ),
            ),
            child: const Text('User Info'),
          ),
           ]
        ),
        const Divider(
          thickness: 1,  // Adjust thickness as needed
          color: Colors.grey,
        ),
        const Center(
          child: Text('Note: False deception is offence'),
        ),
      ]),
    ),
  );
}


Widget _buildDragHandle() =>GestureDetector(
  child: Center(
    child: Container(
      width: 50,
      height: 5,
      decoration: const BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.all(Radius.circular(12),)
      ),
    ),
  ),
);


Widget _map(double lat,double long){
  double lat0=lat;
  double long0=long;
  return FlutterMap(
    options: MapOptions(
      initialCenter: LatLng(lat, long), // Initial map center
      initialZoom: 12.0, // Initial zoom level
    ),
    children: [
      TileLayer(
        urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
      ),
    MarkerLayer(
      markers: [
      Marker(
        width: 40.0,
        height: 40.0,
        point: LatLng(lat0 ,long0),
        child: const Icon(
            Icons.person_pin,
            color: Colors.blue,
            size: 35.0,
          ),
        ),
      ],
     ),
  ]);
}


class GoogleAuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn
          .signIn();
      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential authResult = await _auth.signInWithCredential(
            credential);
        final User? user = authResult.user;

        return user;
      }
    } catch (e) {
      SnackBar(
        content: Text("Error signing in with Google: $e"),
      );
      return null;
    }
    return null;
  }
}