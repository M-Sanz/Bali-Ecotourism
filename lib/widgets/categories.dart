import 'package:flutter/material.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';
import 'package:get/get.dart';

class Categories extends StatelessWidget {
  Categories({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(vertical: 10),
      physics: const NeverScrollableScrollPhysics(),
      clipBehavior: Clip.none,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0,
        mainAxisSpacing: 10.0,
        childAspectRatio: 2.5,
      ),
      itemCount: Constants.categoryList.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Get.toNamed('/post-list', arguments: {
              'slug': Constants.categoryList[index]['slug'], // String value
              'name': Constants.categoryList[index]['name'], // String value
            });
          },
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(10, 0, 0, 0),
                  spreadRadius: 5,
                  blurRadius: 4,
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Constants.lightAccent,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Text(
                        Constants.categoryList[index]["icon"].toString(),
                        style: const TextStyle(fontSize: 35),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      Constants.categoryList[index]["name"].toString(),
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
