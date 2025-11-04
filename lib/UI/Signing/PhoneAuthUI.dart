import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneAuthUI extends StatefulWidget {
  const PhoneAuthUI({super.key});

  @override
  State<PhoneAuthUI> createState() => _PhoneAuthUIState();
}

class _PhoneAuthUIState extends State<PhoneAuthUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Whats auth"),),
        body: Stack());
  }
}
