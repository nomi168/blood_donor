import 'package:flutter/material.dart';

class NewChat extends StatefulWidget {
  const NewChat({
    super.key,
  });

  @override
  State<NewChat> createState() => _NewChatState();
}

class _NewChatState extends State<NewChat> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Expandable Page'),
        ),
        body: Container(
          child: new ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 300.0,
            ),
            child: new Scrollbar(
              child: new SingleChildScrollView(
                scrollDirection: Axis.vertical,
                reverse: true,
                child: new TextField(
                  maxLines: null,
                ),
              ),
            ),
          ),
        ));
  }
}
