import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/widgets/appbar.dart';
import 'package:bali_smart_ecotourism_app/widgets/postsitem.dart';
import 'package:bali_smart_ecotourism_app/widgets/saveitem.dart';
import 'package:bali_smart_ecotourism_app/widgets/storyitem.dart';

// ori
class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Flexible(
              child: ListView(
                padding: const EdgeInsets.only(left: 20, right: 10),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const AlwaysScrollableScrollPhysics(),
                children: const [
                  SizedBox(height: 10.0),
                  StoryItem(),
                  SavedItem(),
                  PostItem(),
                ],
              ),
            ),
            const Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: 20.0, vertical: 12),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Newsfeed',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    fontFamily: 'Ubuntu-Regular',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
