import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import 'package:flutter_trip/pages/home_page.dart';
import 'package:flutter_trip/pages/my_page.dart';
import 'package:flutter_trip/pages/search_page.dart';
import 'package:flutter_trip/pages/travel_page.dart';

class TabNavigator extends StatefulWidget {
  @override
  _TabNavigatorState createState() => _TabNavigatorState();
}

class _TabNavigatorState extends State<TabNavigator> {
  final _defaultColor = Colors.grey;
  final _activeColor = Colors.blue;
  int _currentIndex = 0;
  final PageController _pageController = PageController(
    initialPage: 0,
  );
@override
  void initState() {
  hideScreen();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _pageController,
        children: <Widget>[
          HomePage(),
          SearchPage(
            hideLeft: true,
          ),
          TravelPage(),
          MyPage(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          _pageController.jumpToPage(index);
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: [
          _bottomItem(Icons.home, '首页', 0),
          _bottomItem(Icons.search, '搜索', 1),
          _bottomItem(Icons.camera_alt, '旅拍', 2),
          _bottomItem(Icons.account_circle, '我的', 3),

        ],
      ),
    );
  }
  BottomNavigationBarItem _bottomItem(IconData icon,String title,int index){
    return BottomNavigationBarItem(
      icon: Icon(
        icon,
        color: _defaultColor,
      ),
      activeIcon: Icon(
        icon,
        color: _activeColor,
      ),
      title: Text(
        title,
          style: TextStyle(
            color: _currentIndex != index ? _defaultColor : _activeColor
          ),
      )
    );
  }

  Future<void> hideScreen()  {
      FlutterSplashScreen.hide();
  }
}
