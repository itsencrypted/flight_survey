import 'package:flutter/material.dart';

class ArrowIcons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 8,
      bottom: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_upward),
            onPressed: () {},
          ),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
            child: IconButton(
              color: Color.fromRGBO(120, 58, 183, 1),
              icon: Icon(Icons.arrow_downward),
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}