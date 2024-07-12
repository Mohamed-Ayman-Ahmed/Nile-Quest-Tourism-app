import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:nile_quest/modules/cities%20screen/cities_screen.dart';
import 'package:nile_quest/modules/favorites%20screen/favorites.dart';
import 'package:nile_quest/modules/home_screen/home_screen.dart';
import 'package:nile_quest/modules/profile%20screen/profile_screen.dart';
import 'package:nile_quest/shared/styles/colors.dart';

class HomeLayout extends StatefulWidget {
  @override
  State<HomeLayout> createState() => _HomeLayoutState();
}

class _HomeLayoutState extends State<HomeLayout> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(), // Disable manual swiping
        children: [
          HomeScreen(),
          CitiesScreen(),
          FavoritesScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 0.2, // Adjust the height as desired
            color: Colors.grey, // Adjust the color as desired
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GNav(
              onTabChange: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              selectedIndex: _currentIndex,
              tabBorderRadius: 20.0,
              activeColor: Colors.white,
              color: Colors.grey,
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 10.0),
              gap: 8.0,
              iconSize: 32.5,
              tabBackgroundColor: mainColor,
              textStyle: const TextStyle(
                  fontWeight: FontWeight.w700, color: Colors.white),
              tabs: [
                const GButton(
                  icon: Icons.home_outlined,
                  text: 'Home',
                ),
                const GButton(
                  icon: Icons.place_outlined,
                  text: "Cities",
                ),
                const GButton(
                  icon: Icons.favorite_outline,
                  text: 'Favorites',
                ),
                const GButton(
                  icon: Icons.account_circle_outlined,
                  text: 'Profile',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
