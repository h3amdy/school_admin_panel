import 'package:ashil_school/Utils/Styles.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget emptyWidget(String msg) {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: SizedBox(
      width: 300,
      height: 150,
      child: Card(
        elevation: 2,
        color: Colors.white,
        child: Center(
            child: Text(
          msg,
          style: normalStyle(fontSize: 18),
        )),
      ),
    ),
  );
}
