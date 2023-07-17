// This widget will draw header section of all page. Wich you will get with the project source code.

import 'package:EVFI/presentation/resources/color_manager.dart';
import 'package:flutter/material.dart';

class HeaderUI extends StatelessWidget {
  final double _height;
  final bool _showIcon;
  final String _image;

  const HeaderUI(this._height, this._showIcon, this._image, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Container(
      child: Stack(
        children: [
          ClipPath(
            clipper: ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 10 * 5, _height - 60),
              Offset(width / 5 * 4, _height + 20),
              Offset(width, _height - 18)
            ]),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.6),
                      Colors.orange.shade400.withOpacity(0.6),
                      // Theme.of(context).primaryColor.withOpacity(0.4),
                      // Theme.of(context).accentColor.withOpacity(0.4),
                    ],
                    begin:
                        Alignment.topLeft, //const FractionalOffset(0.0, 0.0),
                    end: Alignment.topRight, //const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          ClipPath(
            clipper: ShapeClipper([
              Offset(width / 3, _height + 20),
              Offset(width / 10 * 8, _height - 60),
              Offset(width / 5 * 4, _height - 60),
              Offset(width, _height - 20)
            ]),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      Theme.of(context).primaryColor.withOpacity(0.6),
                      Colors.orange.shade400.withOpacity(0.6),
                    ],
                    begin: Alignment
                        .centerLeft, //const FractionalOffset(0.0, 0.0),
                    end: Alignment
                        .centerRight, //const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          ClipPath(
            clipper: ShapeClipper([
              Offset(width / 5, _height),
              Offset(width / 2, _height - 40),
              Offset(width / 5 * 4, _height - 80),
              Offset(width, _height - 20)
            ]),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [
                      ColorManager.grey3,
                      Colors.amber.shade100,
                      // const Color.fromRGBO(255, 213, 79, 1),
                      // const Color.fromRGBO(255, 236, 179, 1),
                    ],
                    begin: const FractionalOffset(0.0, 0.0),
                    end: const FractionalOffset(1.0, 0.0),
                    stops: const [0.0, 1.0],
                    tileMode: TileMode.clamp),
              ),
            ),
          ),
          Visibility(
            visible: _showIcon,
            child: Align(
              alignment: Alignment.center,
              child: Container(
                height: _height - 95,
                width: _height-140,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(40), bottom: Radius.circular(15)),
                  border: Border.all(width: 6, color: Colors.black),
                ),
                padding: const EdgeInsets.only(top: 20.0,),
                child: Stack(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 5.0, left: 0.3, right: 0.3, bottom: 0.5),
                      decoration: const BoxDecoration(color: Color.fromARGB(255, 104, 210, 107)),),
                    Positioned(
                        top: 0,
                        width: 77,
                        height: 110,
                        child: Image.asset(_image)),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShapeClipper extends CustomClipper<Path> {
  final List<Offset> _offsets;
  ShapeClipper(this._offsets);
  @override
  Path getClip(Size size) {
    var path = Path();

    path.lineTo(0.0, size.height - 20);

    // path.quadraticBezierTo(size.width/5, size.height, size.width/2, size.height-40);
    // path.quadraticBezierTo(size.width/5*4, size.height-80, size.width, size.height-20);

    path.quadraticBezierTo(
        _offsets[0].dx, _offsets[0].dy, _offsets[1].dx, _offsets[1].dy);
    path.quadraticBezierTo(
        _offsets[2].dx, _offsets[2].dy, _offsets[3].dx, _offsets[3].dy);

    // path.lineTo(size.width, size.height-20);
    path.lineTo(size.width, 0.0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
