import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/profile/myprofile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileState createState() => _ProfileState();
}

// Ori
class _ProfileState extends State<Profile> {
  late PageController _pageController;
  int _page = 0;
  int selectedItem = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontFamily: 'Ubuntu-Regular',
            fontSize: 15,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: SizedBox(
              height: MediaQuery.of(context).size.height,
              child: PageView(
                physics: const NeverScrollableScrollPhysics(),
                controller: _pageController,
                onPageChanged: onPageChanged,
                children: [
                  MyProfile(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.dispose();
  }

  selectItem(page) {
    setState(() {
      selectedItem = page;
    });
  }
}
