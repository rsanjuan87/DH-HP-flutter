import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:text/controllers/HomeController.dart';
import 'package:text/gen_a/A.dart';

import '../Defs.dart';
import '../r.g.dart';

class IntensidadPage extends StatelessWidget {
  HomeController controller;
  ErrorText e;

  IntensidadPage(HomeController _) {
    e = ErrorText();
    controller = _;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(A.intensidad),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                A.puede_hacer_zoom,
                style: TextStyle(fontSize: 20),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(children: [
                  InteractiveViewer(
                    panEnabled: true,
                    // Set it to false
                    boundaryMargin: EdgeInsets.all(100),
                    minScale: 1,
                    maxScale: 4,
                    child: Image.asset(
                      R.image.intensidad().assetName,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        height: 1.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        width: 1.0,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ]),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  A.tiempo_de_concentracion.replaceAll("%1d3", "replace,000"),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  A.altura_resipitaciones +
                      ' ' +
                      _.data.alturaPresipitaciones.toStringAsFixed(3),
                  style: TextStyle(fontSize: 20),
                ),
              ),
              GetBuilder<HomeController>(
                id: IDs.intensidad,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      errorText: e.errorIntensidadText,
                      border: OutlineInputBorder(),
                      labelText: A.intensidad,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => checkIntensidadEstimada(text),
                  ),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (checkIntensidadEstimada(_.data.intensidad.toString()))
              _.goMainPage();
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  bool checkIntensidadEstimada(String text) {
    bool res = true;
    controller.data.setIntensidad(text);
    if (controller.data.intensidad < 1) {
      e.errorIntensidadText = A.negativeNumberError;
      res = false;
    } else {
      e.errorIntensidadText = null;
    }
    controller.update();
    return res;
  }
}

class ErrorText {
  String errorIntensidadText;
}
