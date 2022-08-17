import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rebel_girls/modles/user.dart';
import 'package:rebel_girls/providers/user_provider.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/utils/global_variables.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController();
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        children: homeScreenItems,
        controller: pageController,
        onPageChanged: onPageChanged,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedFontSize: 0,
        selectedFontSize: 0,
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        elevation: 0,
        items: user != null && user.isAdmin
            ? [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: 'Home',
                    backgroundColor: mobileBackgroundColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle,
                      color: _page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: 'Event',
                    backgroundColor: mobileBackgroundColor),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.assignment_rounded,
                    color: _page == 2 ? primaryColor : secondaryColor,
                  ),
                  label: 'About',
                  backgroundColor: mobileBackgroundColor,
                ),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.approval_rounded,
                    color: _page == 3 ? primaryColor : secondaryColor,
                  ),
                  label: 'Approve',
                  backgroundColor: mobileBackgroundColor,
                ),
              ]
            : [
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.home,
                      color: _page == 0 ? primaryColor : secondaryColor,
                    ),
                    label: 'Home',
                    backgroundColor: mobileBackgroundColor),
                BottomNavigationBarItem(
                    icon: Icon(
                      Icons.add_circle,
                      color: _page == 1 ? primaryColor : secondaryColor,
                    ),
                    label: 'Event',
                    backgroundColor: mobileBackgroundColor),
                BottomNavigationBarItem(
                  icon: Icon(
                    Icons.assignment_rounded,
                    color: _page == 2 ? primaryColor : secondaryColor,
                  ),
                  label: 'About',
                  backgroundColor: mobileBackgroundColor,
                ),
              ],
        currentIndex: _page,
        onTap: navigationTapped,
      ),
    );
  }
}
