import 'package:ashil_school/AppResources.dart';
import 'package:ashil_school/UI/Home/UsersUI.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../Controllers/UserController.dart';
import 'SubjectsUI.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    Scaffold(
      body: Container(
        child: Text("1"),
      ),
    ),
    Scaffold(
      body: Container(
        child: Text("2"),
      ),
    )
    // SubjectsUI(), UsersUI()
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: secondaryColor,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: secondaryColor,
        unselectedItemColor: Colors.grey.shade400,
        currentIndex: _currentIndex,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "الرئيسية"),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: "المستخدمون"),
        ],
      ),
    );
  }
}
