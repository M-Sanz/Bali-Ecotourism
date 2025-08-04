import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/data.dart';

// Ori
class SavedItem extends StatefulWidget {
  const SavedItem({super.key});

  @override
  _SavedItemState createState() => _SavedItemState();
}

class _SavedItemState extends State<SavedItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Flexible(
            child: ListView.builder(
              itemCount: 3,
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                Map datar = data[index];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                              image: AssetImage(datar['saved']),
                              fit: BoxFit.cover),
                        ),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Container(
                                    height: 30,
                                    width: 30,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.white,
                                    ),
                                    child: const Center(
                                      child: Icon(
                                        Icons.bookmark,
                                        size: 15,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 20.0,
                                  horizontal: 10,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      datar['city'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                        fontFamily: 'Ubuntu-Regular',
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      datar['places'],
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontFamily: 'Ubuntu-Regular',
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on,
                                          size: 15,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(width: 2),
                                        Text(
                                          datar['location'],
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Ubuntu-Regular',
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(bottom: 20.0),
          //   child: DotsIndicator(
          //     dotsCount: totalDots,
          //     position: currentPosition,
          //     decorator: DotsDecorator(
          //       size: Size.square(5.0),
          //       spacing: EdgeInsets.only(left: 5),
          //       activeSize: Size(20.0, 5.0),
          //       activeShape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.circular(5.0),
          //       ),
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
