//lib/screens/main_screen.dart

import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'camera_screen.dart';
import 'profile_screen.dart';
import 'rewards_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  // ignore: prefer_const_constructors
  final List<Widget> _screens = [
    // ignore: prefer_const_constructors
    HomeScreen(),
    // ignore: prefer_const_constructors
    CameraScreen(),
    // ignore: prefer_const_constructors
    ProfileScreen(),
    // ignore: prefer_const_constructors
    RewardsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
        ],
      ),
    );
  }
}