import 'package:flutter/material.dart';
import 'package:madcamp3/screens/profile.dart';
import 'package:madcamp3/screens/recipe.dart';

import 'all_users.dart';
import 'food.dart';
import 'widgets/naver.dart';

class TabPage extends StatefulWidget {
  final int initialTabIndex;

  const TabPage({super.key, this.initialTabIndex = 0});

  @override
  State<TabPage> createState() => _TabPageState();
}

class _TabPageState extends State<TabPage> with SingleTickerProviderStateMixin {
  GlobalKey<FormState> globalFormKey = GlobalKey<FormState>();
  String? username;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        initialIndex: widget.initialTabIndex, length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final imageSize = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              // Set the background color of the bottom navigation bar
              canvasColor: Colors.blue,
              // Set the active and inactive colors of the icon and text
              primaryColor: Colors.white,
              textTheme: Theme.of(context).textTheme.copyWith(
                    caption: TextStyle(color: Colors.grey),
                  ),
            ),
            child: TabBar(
              controller: _tabController,
              tabs: [
                Tab(
                  icon: Icon(Icons.home),
                  text: 'Home',
                ),
                Tab(
                  icon: Icon(Icons.fastfood),
                  text: 'Food',
                ),
                Tab(
                  icon: Icon(Icons.people),
                  text: 'My',
                ),
              ],
              indicatorColor: Colors.white,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              AllUsersScreen(),
              Dashboard(),
              ProfilePage(),
            ],
          ),
        ),
      ),
    );
  }
}
