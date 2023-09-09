import 'package:flutter/cupertino.dart';

class TringularClipper extends CustomClipper<Path> {
  final bool left;

  TringularClipper(this.left);

  @override
  Path getClip(Size size) {
   late Path path;
   if(left) {
     path = Path()
      ..lineTo(size.width, size.height)
      ..lineTo(0, 0)
      ..close();
   } else {
     path = Path()
       ..lineTo(0, size.height)
       ..lineTo(size.width, 0)
       ..close();
   }

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }

}