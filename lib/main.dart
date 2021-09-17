import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:music_recommender/welcomeScreen.dart';
import 'musics.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FlutterDownloader.initialize();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);
  static bool isLoggedIn =
      FirebaseAuth.instance.currentUser != null ? true : false;
  static AudioPlayer player = new AudioPlayer();
  static bool playing = false;

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, dynamic> data;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    list.clear();
    // favList.clear();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: welcome(),
    );
  }

  //TODO: take fav list
  //assign to map
  getData() {
    FirebaseFirestore.instance
        .collection('music')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        list.add(new MusicData(
            musicName: doc["musicName"],
            artistName: doc["artistName"],
            image: doc["image"],
            tag: doc["tag"],
            url: doc["url"],
            id: doc.id.toString()));
      });
    });
  }
}
