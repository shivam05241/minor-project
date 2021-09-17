import 'dart:isolate';
import 'dart:ui';
import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:swipe_up/swipe_up.dart';
import 'package:flutter/material.dart';
import 'package:music_recommender/AudioPlayer.dart';
import 'Home screen.dart';
import 'constants.dart';
import 'main.dart';
import 'musics.dart';
import 'musicListScreen.dart';

class MusicPlayerScreen extends StatefulWidget {
  int pos;
  MusicPlayerScreen({this.pos});
  @override
  _MusicPlayerScreenState createState() => _MusicPlayerScreenState(pos: pos);
}

class _MusicPlayerScreenState extends State<MusicPlayerScreen> {
  int pos;
  _MusicPlayerScreenState({this.pos});

  Widget slider() {
    return Slider.adaptive(
      activeColor: Colors.pinkAccent,
      inactiveColor: Colors.green[100],
      value: audioPlayer.position.inSeconds.toDouble(),
      onChanged: (value) {
        seekToSec(value.toInt());
      },
      max: audioPlayer.musicLength.inSeconds.toDouble(),
    );
  }

  void seekToSec(int sec) {
    audioPlayer.newPosition = new Duration(seconds: sec);
    MyApp.player.seek(audioPlayer.newPosition);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // MyApp.player.onPlayerCompletion.listen((event) {
    //   setState(() {
    //     audioPlayer.position = new Duration();
    //     audioPlayer.MusicButton = Icons.play_arrow;
    //   });
    //   if (loop) {
    //     MyApp.player.play(audioPlayer.musicURL);
    //     setState(() {
    //       audioPlayer.MusicButton = Icons.pause;
    //       MyApp.playing = true;
    //     });
    //   }
    // });

    IsolateNameServer.registerPortWithName(
        receivePort.sendPort, "downloadMusic");
    receivePort.listen((message) {
      setState(() {
        progress = message;
      });
    });
    FlutterDownloader.registerCallback(downloadCallBack);

    MyApp.player.onDurationChanged.listen((Duration d) {
      setState(() {
        audioPlayer.musicLength = d;
      });
    });

    MyApp.player.onAudioPositionChanged.listen((Duration p) {
      setState(() {
        audioPlayer.position = p;
      });
    });

    audioPlayer.musicURL = list[pos].url;
    if (MyApp.playing) MyApp.player.stop();
    MyApp.player.play(audioPlayer.musicURL);
    // cache.play(musicName);
    MyApp.playing = true;
    audioPlayer.MusicButton = Icons.pause;
  }

  Random random = new Random();
  bool loop = false;

  // fun() {
  //   if (loop == true && MyApp.player.state == AudioPlayerState.COMPLETED) {
  //     MyApp.player.onPlayerCompletion.listen((event) {
  //       if (MyApp.playing) MyApp.player.stop();
  //       audioPlayer.musicURL = list[pos].url;
  //       MyApp.player.play(audioPlayer.musicURL);
  //       setState(() {
  //         audioPlayer.MusicButton = Icons.pause;
  //         MyApp.playing = true;
  //       });
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    double Height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) /
        700;
    double Width = MediaQuery.of(context).size.width;

    return SwipeUp(
      animate: true,
      onSwipe: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (BuildContext context) => musicList(
                  pos: pos,
                  // tag: list[pos].tag,
                )));
      },
      child: Material(
        color: Colors.transparent,
        child: Text(
          'music list',
          style: TextStyle(foreground: Paint()..shader = klinearGradient),
        ),
      ),
      body: Scaffold(
        backgroundColor: Color(0xff191A2D),
        body: SafeArea(
            child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 15),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      // Navigator.of(context).pop();
                      // MyApp.player.stop();
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomeScreen(),
                        ),
                      );
                    },
                    child: kiconShader(
                      Icon(Icons.arrow_back_ios),
                    ),
                  ),
                ],
              ),
            ),
            // for music image and slider
            Container(
              alignment: Alignment.bottomCenter,
              width: double.infinity,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
              child: CircleAvatar(
                maxRadius: 125,
                backgroundImage: NetworkImage(list[pos].image),
              ),
            ),
            SizedBox(
              height: 50 * Height,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () {
                    if (MyApp.isLoggedIn) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Added to Favourite"),
                          );
                        },
                      );
                      writeData(list[pos].id);
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text("Sign In to add to Favourite"),
                          );
                        },
                      );
                    }
                  },
                  child: kiconShader(
                    Icon(
                      Icons.favorite,
                      size: 30 * Height,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      MyApp.isLoggedIn
                          ? downloadFile()
                          : showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Sigin In to Download"),
                                );
                              },
                            );
                    });
                  },
                  child: kiconShader(
                    Icon(
                      Icons.file_download,
                      size: 30 * Height,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    //TODO: share music logic
                  },
                  child: kiconShader(
                    Icon(
                      Icons.share_outlined,
                      size: 30 * Height,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20 * Height,
            ),
            //music name and artist name
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  // width: Width / 3,
                  height: 40 * Height,
                  child: Text(
                    list[pos].musicName,
                    style: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  alignment: Alignment.center,
                  // width: Width / 1.5,
                  height: 25 * Height,
                  child: Text(
                    list[pos].artistName,
                    style: TextStyle(color: Colors.grey, fontSize: 15),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 30 * Height,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${audioPlayer.position.inMinutes}:${audioPlayer.position.inSeconds.remainder(60)}",
                    style: TextStyle(
                        foreground: Paint()..shader = klinearGradient),
                  ),
                  Expanded(child: slider()),
                  Text(
                    "${audioPlayer.musicLength.inMinutes}:${audioPlayer.musicLength.inSeconds.remainder(60)}",
                    style: TextStyle(
                        foreground: Paint()..shader = klinearGradient),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 30 * Height,
            ),
            // music control buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    pos = random.nextInt(list.length);
                    if (MyApp.playing) MyApp.player.stop();
                    audioPlayer.musicURL = list[pos].url;
                    MyApp.player.play(audioPlayer.musicURL);
                    setState(() {
                      audioPlayer.MusicButton = Icons.pause;
                      MyApp.playing = true;
                    });
                  },
                  child: kiconShader(
                    Icon(
                      Icons.shuffle,
                      size: 30 * Height,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (pos - 1 >= 0) {
                      if (MyApp.playing) MyApp.player.stop();
                      pos--;
                      audioPlayer.musicURL = list[pos].url;
                      MyApp.player.play(audioPlayer.musicURL);
                      setState(() {
                        audioPlayer.MusicButton = Icons.pause;
                        MyApp.playing = true;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "no previous music",
                              style: TextStyle(
                                  foreground: Paint()
                                    ..shader = klinearGradient),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: kiconShader(
                    Icon(
                      Icons.skip_previous,
                      size: 30 * Height,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (!MyApp.playing) {
                      // player.setUrl(musicURL);
                      MyApp.player.play(audioPlayer.musicURL);
                      // cache.play(musicName);
                      setState(() {
                        audioPlayer.MusicButton = Icons.pause;
                        MyApp.playing = true;
                      });
                    } else {
                      MyApp.player.pause();
                      setState(() {
                        audioPlayer.MusicButton = Icons.play_arrow;
                        MyApp.playing = false;
                      });
                    }
                  },
                  child: Container(
                    height: 70 * Height,
                    width: 70 * Height,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 60 * Height,
                          width: 60 * Height,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.pink,
                            gradient: LinearGradient(
                              begin: Alignment.topRight,
                              end: Alignment.bottomLeft,
                              colors: [
                                Colors.pink[300],
                                //Colors.pink,
                                Colors.blue[300],
                              ],
                            ),
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          height: 50 * Height,
                          width: 50 * Height,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff191A2D),
                          ),
                          child: kiconShader(
                            Icon(
                              audioPlayer.MusicButton,
                              size: 40 * Height,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    if (pos + 1 < list.length) {
                      pos++;
                      if (MyApp.playing) MyApp.player.stop();
                      audioPlayer.musicURL = list[pos].url;
                      MyApp.player.play(audioPlayer.musicURL);
                      setState(() {
                        audioPlayer.MusicButton = Icons.pause;
                        MyApp.playing = true;
                      });
                    } else {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text(
                              "no next music",
                              style: TextStyle(
                                  foreground: Paint()
                                    ..shader = klinearGradient),
                            ),
                          );
                        },
                      );
                    }
                  },
                  child: kiconShader(
                    Icon(
                      Icons.skip_next,
                      size: 30 * Height,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      loop = !loop;
                    });
                  },
                  child: loop
                      ? Stack(
                          children: [
                            kiconShader(
                              Icon(
                                Icons.add_outlined,
                                size: 30 * Height,
                              ),
                            ),
                            kiconShader(
                              Icon(
                                Icons.loop,
                                size: 30 * Height,
                              ),
                            )
                          ],
                        )
                      : kiconShader(
                          Icon(
                            Icons.loop,
                            size: 30 * Height,
                          ),
                        ),
                ),
              ],
            ),
          ],
        )),
      ),
    );
  }

  void writeData(String id) async {
    // print("HI---$id--");
    DocumentSnapshot snapshot = await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .get();
    Map data = snapshot.data();

    List list = data['favList'];
    print(list);
    if (list.contains(id) == false) list += [id];
    print(list);

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({'favList': list});
  }

  downloadFile() async {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: Text("Downloading started..."),
          );
        });

    final status = await Permission.storage.request();
    if (status.isGranted) {
      final baseStorage = await getExternalStorageDirectory();
      final id = await FlutterDownloader.enqueue(
          url: list[pos].url,
          savedDir: baseStorage.path,
          fileName: list[pos].musicName);
    }
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            content: Text("Downloading completed..."),
          );
        });
  }

  int progress = 0;
  ReceivePort receivePort = ReceivePort();
  static downloadCallBack(id, status, progress) {
    SendPort sendPort = IsolateNameServer.lookupPortByName("downloadMusic");
    sendPort.send(progress);
  }
}
