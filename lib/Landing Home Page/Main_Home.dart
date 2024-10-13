import 'package:devfolio_genai/Chat%20Window/chatpage.dart';
import 'package:devfolio_genai/HomePage/homepage.dart';
import 'package:devfolio_genai/Settings/settings.dart';
import 'package:devfolio_genai/Widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:motion_tab_bar/MotionTabBar.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   int _selectedIndex = 0;

//   // List of pages corresponding to the bottom nav bar
//   static const List<Widget> _pages = <Widget>[
//     HomeScreen(),
//     ChatPage(),
//     SettingsScreen(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _pages[_selectedIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.chat),
//             label: 'Chatbot',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.settings),
//             label: 'Settings',
//           ),
//         ],
//         currentIndex: _selectedIndex,
//         selectedItemColor: Colors.purple,
//         onTap: _onItemTapped,
//       ),
//     );
//   }
// }

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: TabBarView(
        controller: _tabController,
        children: const <Widget>[
          HomeScreen(),
          ChatPage(),
          SettingsPage(),
        ],
      ),
      bottomNavigationBar: MotionTabBar(
        tabIconSelectedSize: 30,
        tabBarHeight: MediaQuery.of(context).size.height * 0.09,
        labels: const ["Explore", "Chatbot", "Settings"],
        initialSelectedTab: "Explore",
        tabIconColor: Colors.grey,
        tabSelectedColor: Colors.purple,
        icons: const [Icons.explore, Icons.chat, Icons.settings],
        textStyle: const TextStyle(color: Colors.purple),
        onTabItemSelected: (int value) {
          setState(() {
            _tabController.index = value;
          });
        },
      ),
    );
  }
}
