import 'package:flutter/material.dart';

import 'dot.dart';

class OptionItem extends StatefulWidget {
  final String name;
  final void Function(Offset dotOffset) onTap;
  final bool showDot;

  const OptionItem(
      {Key key, @required this.name, @required this.onTap, this.showDot = true})
      : super(key: key);

  @override
  _OptionItemState createState() => _OptionItemState();
}

class _OptionItemState extends State<OptionItem> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        RenderBox object = context.findRenderObject();
        Offset globalPosition = object.localToGlobal(Offset.zero);
        widget.onTap(globalPosition);
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: <Widget>[
            SizedBox(width: 26),
            Dot(visible: widget.showDot),
            SizedBox(width: 26),
            Expanded(
              child: Text(
                widget.name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 26),
              ),
            )
          ],
        ),
      ),
    );
  }
}