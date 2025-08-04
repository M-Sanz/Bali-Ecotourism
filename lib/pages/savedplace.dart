import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/pages/tabs/savedplaces.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:bali_smart_ecotourism_app/widgets/appbar.dart';

class SavedPlace extends StatefulWidget {
  const SavedPlace({super.key});

  @override
  _SavedPlaceState createState() => _SavedPlaceState();
}

class _SavedPlaceState extends State<SavedPlace>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: Constants.categoryList.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              Flexible(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: TabBar(
                        controller: _tabController,
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 25),
                        indicatorColor: Constants.darkPrimary,
                        indicator: UnderlineTabIndicator(
                          insets: const EdgeInsets.only(bottom: 5),
                          borderSide: BorderSide(
                              color: Constants.darkPrimary, width: 2.0),
                        ),
                        indicatorWeight: 1.0,
                        isScrollable: true,
                        unselectedLabelColor: Colors.grey,
                        tabs: Constants.categoryList.map((category) {
                          return Tab(
                            child: Text(
                              '${category['name']}',
                              style: const TextStyle(fontSize: 12),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: Constants.categoryList.map((category) {
                          return SavedPlaces(term: category['slug'] as String);
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    'Saved',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
