import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:text/controllers/SplashController.dart';
import 'package:text/gen_a/A.dart';
import 'package:text/pages/widgets/wave.dart';

import '../r.g.dart';

class Splash extends StatelessWidget {
  const Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = new Size(MediaQuery.of(context).size.width, 300.0);
    return GetBuilder(
      init: SplashController(),
      builder: (_) => Scaffold(
          backgroundColor: Colors.lightBlue,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  A.app_name,
                  style: TextStyle(fontSize: 100),
                ),
                Image.asset(R.image.logo().assetName),
                Stack(
                  children: <Widget>[
                    new Wave(
                      size: size,
                      xOffset: 0,
                      yOffset: 0,
                      duration: 2,
                      image: R.image.bubbles_jpg().assetName,
                    ),
                    new Opacity(
                      opacity: .7,
                      child: new Wave(
                        size: size,
                        xOffset: 530,
                        yOffset: 10,
                        duration: 5,
                        image: R.image.whater_jpg().assetName,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )),
    );
  }

}
