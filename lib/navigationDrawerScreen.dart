import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_recommender/google_sign_in.dart';
import 'package:music_recommender/musics.dart';
import 'Favourites.dart';
import 'RecommendedScreen.dart';
import 'constants.dart';
import 'main.dart';

class navigationDrawer extends StatefulWidget {
  const navigationDrawer({Key key}) : super(key: key);

  @override
  _navigationDrawerState createState() => _navigationDrawerState();
}

class _navigationDrawerState extends State<navigationDrawer> {
  bool loding = false;
  @override
  Widget build(BuildContext context) {
    double Height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) /
        700;
    final user = FirebaseAuth.instance.currentUser;
    GoogleSignInProvider googleSignInProvider = new GoogleSignInProvider();

    return MyApp.isLoggedIn
        ? Container(
            color: Colors.white24,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: Column(
                //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    height: 100,
                  ),
                  Column(
                    children: [
                      CircleAvatar(
                        maxRadius: 50,
                        backgroundImage: NetworkImage(user.photoURL),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        user.displayName,
                        style: TextStyle(
                            foreground: Paint()..shader = klinearGradient),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => favourite()));
                    },
                    child: Row(
                      children: [
                        kiconShader(
                          Icon(
                            Icons.favorite_outlined,
                            size: 54,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Your Favourite music",
                          style: TextStyle(
                              foreground: Paint()..shader = klinearGradient),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => Recommended()));
                    },
                    child: Row(
                      children: [
                        kiconShader(
                          Icon(
                            Icons.recommend,
                            size: 54,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          "Recommended to You",
                          style: TextStyle(
                              foreground: Paint()..shader = klinearGradient),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  Row(
                    children: [
                      kiconShader(
                        Icon(
                          Icons.logout,
                          size: 54,
                        ),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      TextButton(
                        onPressed: () {
                          googleSignInProvider.logOut();
                          setState(() {
                            MyApp.isLoggedIn = false;
                          });
                        },
                        child: Text(
                          "Log-Out",
                          style: TextStyle(
                              foreground: Paint()..shader = klinearGradient),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        : Container(
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    width: double.infinity,
                    height: Height * 200,
                    child: Image.asset("assets/appLogo.png"),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        shadowColor: Colors.blueGrey,
                        child: FlatButton(
                          //TODO: create login screen
                          onPressed: () async {
                            print("pressed");
                            await googleSignInProvider.login().whenComplete(() {
                              setState(() {
                                MyApp.isLoggedIn =
                                    FirebaseAuth.instance.currentUser != null
                                        ? true
                                        : false;
                              });
                            });
                            if (ifNewUser() == true) {
                              makeList();
                            }
                          },
                          child: Text(
                            'Sign In',
                            style: TextStyle(fontSize: 30),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
  }

  // void loadFav() async {
  //   if (ifNewUser() == true) {
  //     print("new user");
  //     makeList();
  //   } else {
  //     print("old user");
  //     //TODO: this
  //     String userId = FirebaseAuth.instance.currentUser.uid;
  //     print("user id is===$userId");
  //     DocumentSnapshot snapshot = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(FirebaseAuth.instance.currentUser.uid)
  //         .get();
  //     Map data = snapshot.data();
  //
  //     List list = data['favList'];
  //     List<MusicData> musiclist;
  //     for (int i = 0; i < list.length; i++) {
  //       DocumentSnapshot snap = await FirebaseFirestore.instance
  //           .collection('music')
  //           .doc('${list[i]}')
  //           .get();
  //       Map currMap = snap.data();
  //
  //       musiclist.add(MusicData(
  //           musicName: currMap['musicName'],
  //           artistName: currMap['artistName'],
  //           image: currMap['image'],
  //           tag: currMap['tag'],
  //           url: currMap['url']));
  //     }
  //
  //     favList = musiclist;
  //   }
  // }

  bool ifNewUser() {
    UserMetadata metadata = FirebaseAuth.instance.currentUser.metadata;
    if (metadata.creationTime == metadata.lastSignInTime) {
      print("returning true");
      return true;
    } else {
      print("returning false");
      return false;
    }
  }

  void makeList() async {
    print("making list for new user");
    String userId = FirebaseAuth.instance.currentUser.uid;
    print(userId);
    final ref = FirebaseFirestore.instance.doc("users/${userId}");
    userData data = userData(list: []);
    Map map = data.toMap();
    ref.set(map);
    print("list added to fireStore");
  }
}

class userData {
  List<String> list = [];
  userData({this.list});

  Map<String, dynamic> toMap() {
    return {'favList': list};
  }
}
