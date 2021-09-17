import 'package:flutter/material.dart';
import 'dart:ui' as ui;

Widget kiconShader(Icon icon) {
  return ShaderMask(
    blendMode: BlendMode.srcIn,
    shaderCallback: (Rect bounds) {
      return ui.Gradient.linear(
        Offset(4.0, 24.0),
        Offset(24.0, 4.0),
        [
          Colors.pink[300],
          //Colors.pink,
          Colors.blue[300],
        ],
      );
    },
    child: icon,
  );
}

final Shader klinearGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.topRight,
  colors: [
    Colors.pink[900],
    Colors.pink[700],
    Colors.pink[500],
    Colors.pink[300],
    Colors.blue[500],
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 220.0, 70.0));

final Shader klinearGradient1 = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    Colors.pink[900],
    Colors.pink[700],
    Colors.pink[500],
    Colors.blue[500],
    Colors.blue[700],
    Colors.blue[900],
  ],
).createShader(Rect.fromLTWH(0.0, 0.0, 500.0, 50.0));

class LoginBox extends StatelessWidget {
  String text;
  IconData icon;
  //VoidCallback callback = () {};
  LoginBox({@required this.text, @required this.icon});

  @override
  Widget build(BuildContext context) {
    double Height = (MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top) /
        700;
    double Width = MediaQuery.of(context).size.width / 300;

    return Container(
      width: 400 * Width,
      height: 40 * Height,
      margin: EdgeInsets.only(left: 30 * Width, right: 30 * Width),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          color: Colors.white),
      child: Row(
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: 50,
            height: 40,
            child: FittedBox(
                fit: BoxFit.scaleDown, child: kiconShader(Icon(icon))),
          ),
          Container(
            padding: EdgeInsets.only(left: 45 * Width),
            child: Center(
              child: Text(
                text,
                style: TextStyle(foreground: Paint()..shader = klinearGradient),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// void makeAlert(String message, context) {
//   showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text(
//             'Login',
//             style: TextStyle(foreground: Paint()..shader = klinearGradient),
//           ),
//           backgroundColor: Colors.white,
//           content: Text(
//             message,
//             style: TextStyle(foreground: Paint()..shader = klinearGradient),
//           ),
//           actions: [
//             Card(
//               shadowColor: Colors.blueGrey,
//               child: FlatButton(
//
//                 onPressed: ()  {
//                   Navigator.of(context).pushReplacement(Material)
//                 },
//                 child: Text(
//                   'Sign In',
//                   style: TextStyle(fontSize: 30),
//                 ),
//               ),
//             )
//           ],
//         );
//       });
// }
