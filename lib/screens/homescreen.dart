import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/pages/auth/profile.dart';
import 'package:bali_smart_ecotourism_app/pages/explore.dart';
import 'package:bali_smart_ecotourism_app/pages/home.dart';
import 'package:bali_smart_ecotourism_app/pages/savedplace.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import '../pages/auth/login_or_register.dart';
import '../services/shared_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late PageController _pageController;
  int _page = 0;
  int selectedItem = 0;

  // Icon configurations for each tab
  final List<Map<String, IconData>> _navIcons = [
    {
      'outlined': Icons.home_outlined,
      'filled': Icons.home_filled,
    },
    {
      'outlined': Icons.search_outlined,
      'filled': Icons.search,
    },
    {
      'outlined': Icons.bookmark_border,
      'filled': Icons.bookmark,
    },
    {
      'outlined': Icons.person_outline,
      'filled': Icons.person,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: _pageController,
        onPageChanged: onPageChanged,
        children: const [
          Home(),
          Explore(),
          SavedPlace(),
          Profile(),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: SizedBox(
          height: 48.0,
          child: BottomAppBar(
            color: Colors.white,
            elevation: 0.8,
            padding: EdgeInsets.zero,
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(4, (index) => _buildNavButton(index)),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton(int index) {
    final isSelected = _page == index;
    return IconButton(
      icon: Icon(
        isSelected ? _navIcons[index]['filled'] : _navIcons[index]['outlined'],
        size: 24,
        color: isSelected ? Constants.darkPrimary : Colors.grey,
      ),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => navigationTapped(index),
    );
  }

  void navigationTapped(int page) {
    _pageController.jumpToPage(page);
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    bool isLoggedIn = await SharedService.isLoggedIn();
    if (!isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.of(context).pushReplacementNamed(LoginOrRegister.routeName);
      });
    }
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
