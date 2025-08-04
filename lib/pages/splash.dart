import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:bali_smart_ecotourism_app/utils/constants.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start ,
          children: <Widget>[
            SizedBox(height: 120,),
            Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(60),)
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 200,),
                        Text("Bali Ecotourism", style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold),),
                        SizedBox(height: 50,),
                        Container(
                          height: 50,
                          margin: EdgeInsets.symmetric(horizontal: 50),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: Constants.darkPrimary
                          ),
                          child: Center(child: Text("Get Started", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500, fontSize: 20),)),
                        ),
                        SizedBox(height: 30,),
                        RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Already have an account? ',
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),
                              TextSpan(
                                text: ' Login',
                                style: TextStyle(
                                  color: Color.fromRGBO(230, 133, 73, 1),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
            )
          ],
        ),
      ),
    );
  }
}