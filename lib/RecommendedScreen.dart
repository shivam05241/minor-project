import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Home screen.dart';
import 'constants.dart';
import 'music player.dart';
import 'musics.dart';
import 'navigationDrawerScreen.dart';

class Recommended extends StatefulWidget {
  const Recommended({Key key}) : super(key: key);

  @override
  _RecommendedState createState() => _RecommendedState();
}

class _RecommendedState extends State<Recommended> {
  List<MusicData> musicList = [];
  bool loading = false;

  void fun() async {
    print("------------------called fun---------------------------");
    setState(() {
      loading = true;
    });
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser.uid}')
        .get();
    Map map = docSnap.data();
    List lists = map['favList'];
    DocumentSnapshot snapp;
    for (int i = 0; i < lists.length; i++) {
      // print("------------------");
      snapp = await FirebaseFirestore.instance
          .collection('music')
          .doc('${lists[i]}')
          .get();
      Map currMap = snapp.data();
      musicList.add(MusicData(
        musicName: currMap['musicName'],
        artistName: currMap['artistName'],
        image: await currMap['image'],
        tag: currMap['tag'],
        url: currMap['url'],
        id: snapp.id.toString(),
      ));
    }
    addByArtist();
    setState(() {
      loading = false;
    });
  }

  void addByArtist() {
    // print("--------------called method----------------------");
    List artists = [];
    for (int i = 0; i < musicList.length; i++) {
      // print(
      // "-----------------${musicList[i].artistName.split(",")}--------$i-----");
      List art = musicList[i].artistName.split(",");
      for (int i = 0; i < art.length; i++) {
        if (artists.contains(art[i]) == false) artists.add(art[i]);
      }
      // print("-----------------$artists-------------");
    }
    musicList.clear();
    for (int i = 0; i < list.length; i++) {
      // print(
      //     "-----------------list[i].split():art:-${list[i].artistName.split(",")}---------");
      List art = list[i].artistName.split(",");
      // print("---------------$art-----------------");
      for (int j = 0; j < artists.length; j++) {
        if (art.contains(artists[j])) {
          // print("---------------adding:${list[i].musicName}----------");
          musicList.add(
            MusicData(
              artistName: list[i].artistName,
              musicName: list[i].musicName,
              tag: list[i].tag,
              url: list[i].url,
              image: list[i].image,
              id: list[i].id,
            ),
          );
          break;
        }
      }
    }
    addByTag();
  }

  void addByTag() {
    // print("---------called------------------");
    List<MusicData> toAdd = [];
    for (int i = 0; i < list.length; i++) {
      for (int j = 0; j < musicList.length; j++) {
        // print(
        //     "--------i:-$i---j:-$j----list[i].tag-${list[i].tag}---musiclist[i].tag-${musicList[j].tag}");
        if (list[i].tag == musicList[j].tag) {
          String ide = list[i].id;
          // print("------------------ide:$ide-----------");
          bool flag = true;
          for (int k = 0; k < musicList.length; k++) {
            if (musicList[k].id == ide) {
              flag = false;
              break;
            }
          }
          // print("-----------------$flag--------------");
          if (flag)
            toAdd.add(MusicData(
              musicName: list[i].musicName,
              artistName: list[i].artistName,
              tag: list[i].tag,
              url: list[i].url,
              image: list[i].image,
            ));
        }
      }
    }
    // for (MusicData md in toAdd)
    // print("-------------------${md.musicName}-----------------------\n");
    musicList.addAll(toAdd);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    musicList.clear();
    fun();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191A2D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Color(0xff1E1F35),
                  ),
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                        child: kiconShader(
                          Icon(Icons.arrow_back),
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        "Recommended Music",
                        style: TextStyle(
                            fontSize: 24,
                            foreground: Paint()..shader = klinearGradient),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                flex: 10,
                child: Container(
                  child: ListView.builder(
                      itemCount: musicList.length,
                      itemBuilder: (context, index) {
                        MusicData item = musicList[index];
                        return loading == false
                            ? Padding(
                                padding: EdgeInsets.all(5),
                                child: GestureDetector(
                                  onTap: () {
                                    int pos = 0;
                                    for (int i = 0; i < list.length; i++) {
                                      if (list[i].id == musicList[index].id)
                                        pos = i;
                                    }
                                    Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            MusicPlayerScreen(pos: pos),
                                      ),
                                    );
                                  },
                                  child: Container(
                                    height: 80,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: Color(0xff1E1F35),
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            maxRadius: 30,
                                            backgroundImage:
                                                NetworkImage(item.image),
                                          ),
                                          SizedBox(
                                            width: 50,
                                          ),
                                          Column(
                                            children: [
                                              Text(
                                                item.musicName,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white),
                                              ),
                                              SizedBox(
                                                height: 10,
                                              ),
                                              Text(
                                                item.artistName,
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white38),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                height: 80,
                                child: CircularProgressIndicator(),
                              );
                      }),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
