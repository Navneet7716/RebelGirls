import 'package:flutter/material.dart';

// ignore: must_be_immutable
class ExpandableText extends StatefulWidget {
  ExpandableText(this.text, {Key? key}) : super(key: key);

  final String text;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      ConstrainedBox(
          constraints: widget.isExpanded
              ? const BoxConstraints()
              : const BoxConstraints(maxHeight: 50.0),
          child: Text(
            widget.text,
            softWrap: true,
            overflow: TextOverflow.fade,
          )),
      widget.isExpanded
          ? TextButton(
              child: const Text('Read Less...'),
              onPressed: () => setState(() => widget.isExpanded = false))
          : TextButton(
              child: const Text('Read More...'),
              onPressed: () => setState(() => widget.isExpanded = true))
    ]);
  }
}
