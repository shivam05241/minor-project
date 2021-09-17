import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'constants.dart';
import 'music player.dart';
import 'musics.dart';

class musicList extends StatefulWidget {
  // String tag;
  int pos;
  musicList({this.pos});

  @override
  _musicListState createState() => _musicListState(pos: pos);
}

class _musicListState extends State<musicList> {
  int pos;

  _musicListState({this.pos});

  @override
  Widget build(BuildContext context) {
    double Height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) /
        700;
    double Width = MediaQuery.of(context).size.width;

    GestureDetector gestureDetector(int i) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MusicPlayerScreen(pos: i)));
        },
        child: Container(
          width: Width / 3, //- 13
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
                    child: Container(
                      child: CircleAvatar(
                        maxRadius: 50,
                        backgroundColor: Colors.purple,
                        backgroundImage: NetworkImage(list[i].image),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Text(
                          list[i].musicName,
                          style: TextStyle(
                              foreground: Paint()..shader = klinearGradient),
                        ),
                        Opacity(
                          opacity: 0.7,
                          child: Text(
                            list[i].artistName,
                            style: TextStyle(
                                foreground: Paint()..shader = klinearGradient),
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

    Widget getTextWidgets() {
      List<Widget> lists = [];

      for (var i = 0; i < list.length; i++) {
        if (list[i].tag == list[pos].tag) lists.add(gestureDetector(i));
      }

      return new Wrap(alignment: WrapAlignment.center, children: lists);
    }

    return Scaffold(
      backgroundColor: Color(0xff191A2D),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            children: [
              // back and search button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: kiconShader(
                      Icon(Icons.arrow_back_ios),
                    ),
                  ),
                  Text(
                    'Music List',
                    style: TextStyle(
                        foreground: Paint()..shader = klinearGradient,
                        fontSize: 30),
                  ),
                  GestureDetector(
                    child: kiconShader(Icon(
                      Icons.search,
                      size: 30,
                    )),
                  )
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: double.infinity,
                height: 500 * Height,
                child: SingleChildScrollView(
                  child: getTextWidgets(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
