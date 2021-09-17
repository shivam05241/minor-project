import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:music_recommender/musics.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'music player.dart';
import 'navigationDrawerScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String tag = "all";
  bool pressed = false;

  Color button1Color = Color(0xff1E1F35);
  Color button2Color = Color(0xff191A2D);
  //Stream<List<MusicData>>getMusicData();

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> _scaffoldKey =
        new GlobalKey<ScaffoldState>();

    double Height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) /
        700;
    double Width = MediaQuery.of(context).size.width;

    GestureDetector gestureDetector(int i) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (BuildContext context) => MusicPlayerScreen(
                    pos: i,
                  )));
        },
        child: Container(
          width: Width / 3,
          height: 150,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Color(0xff1E1F35),
              ),
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child: CircleAvatar(
                      maxRadius: 50,
                      backgroundColor: Colors.purple,
                      backgroundImage: NetworkImage(list[i].image),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        FittedBox(
                          child: Text(
                            list[i].musicName,
                            style: TextStyle(
                                foreground: Paint()..shader = klinearGradient),
                          ),
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: FittedBox(
                            child: Text(
                              list[i].artistName,
                              style: TextStyle(
                                  foreground: Paint()
                                    ..shader = klinearGradient),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    Widget getTextWidgets(String tag) {
      List<Widget> lists = [];
      // list.clear();
      if (tag == 'all') {
        for (var i = 0; i < list.length; i++) {
          lists.add(gestureDetector(i));
        }
      } else {
        for (var i = 0; i < list.length; i++) {
          if (list[i].tag == 'popular') {
            lists.add(gestureDetector(i));
          }
        }
      }
      return new Wrap(
        children: lists,
        alignment: WrapAlignment.center,
      );
    }

    return Scaffold(
      key: _scaffoldKey,
      drawer: Drawer(
        child: navigationDrawer(),
      ),
      backgroundColor: Color(0xff191A2D),
      body: SafeArea(
          child: Column(
        children: [
          Container(
            height: 130,
            child: Column(
              children: [
                Container(
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  height: 45,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: FloatingActionButton(
                            backgroundColor: Colors.lightBlueAccent[100],
                            onPressed: () {
                              _scaffoldKey.currentState.openDrawer();
                            },
                            child: Icon(Icons.menu),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 7,
                          child: Container(
                            alignment: Alignment.center,
                            child: TextFormField(
                              style: TextStyle(
                                foreground: Paint()..shader = klinearGradient,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Search Songs',
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: GestureDetector(
                            onTap: () {},
                            child: kiconShader(
                              Icon(Icons.search),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  height: 65,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 10,
                      right: 10,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                button1Color = Color(0xff1E1F35);
                                button2Color = Color(0xff191A2D);
                                tag = 'all';
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: button1Color,
                              ),
                              child: Text(
                                'All Music',
                                style: TextStyle(
                                    foreground: Paint()
                                      ..shader = klinearGradient),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                button1Color = Color(0xff191A2D);
                                button2Color = Color(0xff1E1F35);
                                tag = 'popular';
                              });
                            },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: button2Color,
                              ),
                              child: Text(
                                'Popular',
                                style: TextStyle(
                                    foreground: Paint()
                                      ..shader = klinearGradient),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            color: Color(0xff191A2D),
            height: 580,
            width: double.infinity,
            child: SingleChildScrollView(
              child: tag == 'all'
                  ? getTextWidgets('all')
                  : getTextWidgets('popular'),
            ),
          ),
        ],
      )),
    );
  }
}
