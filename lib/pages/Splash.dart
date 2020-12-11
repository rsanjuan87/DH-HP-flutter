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
          body: Stack(
            children: <Widget>[
              Align(
                alignment: Alignment.bottomCenter,
                child: Wave(
                  size: size,
                  xOffset: 0,
                  yOffset: 0,
                  duration: 2,
                  image: R.image.bubbles_jpg().assetName,
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Opacity(
                  opacity: .7,
                  child: Wave(
                    size: size,
                    xOffset: 530,
                    yOffset: 10,
                    duration: 5,
                    image: R.image.whater_jpg().assetName,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Image.asset(R.image.logo().assetName),
              ),
              Align(
                alignment: Alignment.center,
                child: Opacity(
                  opacity: .7,
                  child: Text(
                    A.app_name + "\n 2.0",
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Opacity(
                  opacity: .7,
                  child: Text(
                    "Reynaldo San Juan \n http://github.com/rsanjuan87 \n",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: .7,
                  child: Text(
                    "\n\n" + A.full_name,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 38, color: Colors.black),
                  ),
                ),
              ),
            ],
          )),
    );
  }

}
