import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Home screen.dart';
import 'constants.dart';
import 'music player.dart';
import 'musics.dart';

class favourite extends StatefulWidget {
  const favourite({Key key}) : super(key: key);

  @override
  _favouriteState createState() => _favouriteState();
}

class _favouriteState extends State<favourite> {
  List<MusicData> musicList = [];
  bool loading = false;
  fun() async {
    setState(() {
      loading = true;
    });
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser.uid}')
        .get();
    Map map = docSnap.data();
    List list = map['favList']; //!= null ? map['favList'] : [];
    DocumentSnapshot snapp;
    for (int i = 0; i < list.length; i++) {
      // print("------------------");
      snapp = await FirebaseFirestore.instance
          .collection('music')
          .doc('${list[i]}')
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
    setState(() {
      loading = false;
    });
  }

  void remove(int pos) async {
    print("------------------------------------------");
    DocumentSnapshot docSnap = await FirebaseFirestore.instance
        .collection('users')
        .doc('${FirebaseAuth.instance.currentUser.uid}')
        .get();
    Map map = docSnap.data();
    List favList = map['favList'];
    // print(map);
    favList.remove(favList[pos]);
    // map.update('favList', (value) => favList);
    // print(map);
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser.uid)
        .set({'favList': favList});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
                          "Favourite Music",
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
                                              width: 30,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
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
                                                          color:
                                                              Colors.white38),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                GestureDetector(
                                                  onTap: () {
                                                    remove(index);
                                                    setState(() {
                                                      musicList.remove(
                                                          musicList[index]);
                                                    });
                                                  },
                                                  child: kiconShader(
                                                    Icon(Icons.cancel),
                                                  ),
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
        ));
  }
}
