import 'package:devfolio_genai/Chat%20Window/chatpage.dart';
import 'package:devfolio_genai/HomePage/homepage.dart';
import 'package:devfolio_genai/Settings/settings.dart';
import 'package:devfolio_genai/Widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';
import 'package:motion_tab_bar/MotionTabBarController.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  MotionTabBarController? _motionTabBarController;
  final PageController _pageController =
      PageController(); // Add a PageController for swipe functionality

  @override
  void initState() {
    super.initState();

    // Initialize the MotionTabBarController with 3 tabs (Explore, Chatbot, Settings)
    _motionTabBarController = MotionTabBarController(
      initialIndex: 0, // Start with "Explore" tab
      length: 3, // Number of tabs
      vsync: this, // TickerProvider
    );

    // Listen to MotionTabBarController changes and update the PageController
    _motionTabBarController!.addListener(() {
      if (_motionTabBarController!.index != _pageController.page?.round()) {
        _pageController.jumpToPage(_motionTabBarController!.index);
      }
    });
  }

  @override
  void dispose() {
    // Dispose of the MotionTabBarController and PageController
    _motionTabBarController?.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: PageView(
        controller:
            _pageController, // Connect the PageController to allow swiping
        onPageChanged: (int page) {
          setState(() {
            _motionTabBarController!.index = page; // Update tab when swiping
          });
        },
        children: const <Widget>[
          HomeScreen(),
          ChatPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        controller: _motionTabBarController, // Attach MotionTabBarController
        labels: const ["Explore", "Chatbot", "Settings"],
        initialSelectedTab: "Explore", // Initial selected tab
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.purple,
        icons: const [Icons.explore, Icons.chat, Icons.settings],
        textStyle: const TextStyle(color: Colors.purple),
        onTabItemSelected: (int value) {
          // Update the MotionTabBarController when a tab is selected
          setState(() {
            _motionTabBarController!.index = value; // Change tab index
            _pageController.animateToPage(
              // Animate page change when a tab is selected
              value,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          });
        },
      ),
    );
  }
}
