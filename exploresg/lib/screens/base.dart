import 'package:exploresg/helper/utils.dart';
import 'package:exploresg/screens/FavouriteScreen.dart';
import 'package:exploresg/screens/home.dart';
import 'package:exploresg/screens/inbox.dart';
import 'package:exploresg/screens/profile.dart';
import 'package:exploresg/screens/tracker.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BaseScreen extends StatefulWidget {
  static const routeName = "/base";
  @override
  State<StatefulWidget> createState() {
    return _BaseScreen();
  }
}

class _BaseScreen extends State<BaseScreen> {

  PersistentTabController _controller = PersistentTabController(initialIndex: 0);

  List<Widget> _buildScreens() {
    return [
      HomeScreen(),
      FavouriteScreen(),
      TrackerScreen(),
      InboxScreen(),
      ProfileScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        activeColorPrimary: createMaterialColor(Color(0xFF6488E5)),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.favorite),
        activeColorPrimary: createMaterialColor(Color(0xFF6488E5)),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.list_alt_outlined),
        activeColorPrimary: createMaterialColor(Color(0xFF6488E5)),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.markunread_mailbox_outlined),
        activeColorPrimary: createMaterialColor(Color(0xFF6488E5)),
        inactiveColorPrimary: Colors.grey,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.person_sharp),
        activeColorPrimary: createMaterialColor(Color(0xFF6488E5)),
        inactiveColorPrimary: Colors.grey,
      ),
    ];
  }
  
  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white,
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(20.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style1,
    );
  }
}