import 'dart:math';

import 'package:flutter/cupertino.dart';

class ChatMessageTail extends StatelessWidget {
  final Color? color;
  
  final double width;
  final double height;
  final double peakRadius;
  final bool show;
  final bool mirror;

  const ChatMessageTail({
    super.key,
    this.color,
    this.width = 10,
    this.height = 13,
    this.peakRadius = 2,
    this.show = true,
    this.mirror = false
  });

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipBehavior: show?Clip.antiAlias:Clip.none,
      clipper: show?_ChatMessageTailClipper(
        peakRadius: peakRadius,
        mirror: mirror
      ):null,
      child: Container(
        width: width-3,
        height: height,
        color: show?color:null,
      )
    );
  }
}
class _ChatMessageTailClipper extends CustomClipper<Path>{
  final double peakRadius;
  final bool mirror;

  const _ChatMessageTailClipper({ this.peakRadius = 3, this.mirror = false });
  @override
  bool shouldReclip(covariant CustomClipper oldClipper) {
    if(oldClipper is! _ChatMessageTailClipper) return false;
    return true;
  }
  
  @override
  Path getClip(Size size) {
    var path = Path();
    var dir = mirror?-1:1;
    var start = Point<double>(mirror?size.width:0,0);
    var end = Point<double>(mirror?0:size.width,size.height);
    path.moveTo(start.x, start.y);
    path.lineTo(start.x, end.y);
    path.lineTo(end.x+(-peakRadius*dir), size.height);
    path.arcToPoint( Offset(end.x+(-peakRadius*dir), size.height-peakRadius),
      radius: const Radius.circular(1),
      clockwise: mirror
    );
    path.quadraticBezierTo(start.x, size.height-peakRadius, start.x, 0);
    return path;
  }
}