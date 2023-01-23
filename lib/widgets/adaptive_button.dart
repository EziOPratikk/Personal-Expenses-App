import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class AdaptiveButton extends StatelessWidget {
  final String text;
  final Function handler;

  AdaptiveButton(this.text, this.handler);
  @override
  Widget build(BuildContext context) {
    // dart:io should be imported to unlock Platform. check
    return Platform.isIOS
        ? CupertinoButton(
            onPressed: handler,
            child: Text(text),
            color: Theme.of(context).primaryColor,
          )
        : ElevatedButton(
            onPressed: handler,
            child: Text(text),
            style: ButtonStyle(
              textStyle: MaterialStateProperty.all(
                  TextStyle(fontWeight: FontWeight.bold)),
              foregroundColor: MaterialStateProperty.all(
                  Theme.of(context).textTheme.button.color),
              backgroundColor:
                  MaterialStateProperty.all(Theme.of(context).primaryColor),
            ),
          );
  }
}
