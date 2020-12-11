import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:text/controllers/HomeController.dart';
import 'package:text/gen_a/A.dart';

import '../Defs.dart';

class MainPage extends StatelessWidget {
  ErrorText e;
  HomeController controller;

  MainPage() {
    e = ErrorText();
    controller = HomeController();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(A.app_name),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(child: Text(A.initial_data)),
              ),
              GetBuilder<HomeController>(
                id: IDs.area,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      errorText: e.errorAreaText,
                      border: OutlineInputBorder(),
                      labelText: A.area_cuenca,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => checkArea(text),
                  ),
                ),
              ),
              GetBuilder<HomeController>(
                id: IDs.longitud,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      errorText: e.errorLongitudText,
                      border: OutlineInputBorder(),
                      labelText: A.longitud_del_rio,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => checkLongitud(text),
                  ),
                ),
              ),
              GetBuilder<HomeController>(
                id: IDs.presipitaciones,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    decoration: InputDecoration(
                      errorText: e.errorPresipitacionesText,
                      border: OutlineInputBorder(),
                      labelText: A.altura_resipitaciones,
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (text) => checkPresipitaciones(text),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: const Alignment(1.0, 1.0),
                  children: <Widget>[
                    GetBuilder<HomeController>(
                      id: IDs.intensidad,
                      builder: (_) => TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: A.intensidad,
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (text) {
                          checkIntensidad(text);
                        },
                        readOnly: true,
                        onTap: () => _.selectIntensidad(),
                      ),
                    ),
                    new FlatButton(
                        onPressed: () {
                          _.selectIntensidad();
                        },
                        child: new Text(A.select))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        A.categoria,
                      ),
                    ),
                    GetBuilder<HomeController>(
                      id: IDs.categoria,
                      builder: (_) => DropdownButton<String>(
                        value: _.data.categoria,
                        items: <String>[A.autopista, A.i_ii, A.iii_iv]
                            .map((String value) => new DropdownMenuItem<String>(
                                  value: value,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: new Text(value),
                                  ),
                                ))
                            .toList(),
                        onChanged: (text) => setCategoria(text),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  A.caudal_de_disenno
                      .replaceAll("%1d3",
                          _.data.caudalCalculado().toStringAsPrecision(4))
                      .replaceAll(
                          "%2d3", _.data.rangoMin().toStringAsPrecision(4))
                      .replaceAll(
                          "%3d3", _.data.rangoMax().toStringAsPrecision(4)),
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (checkArea(controller.data.area.toString()) &&
                checkLongitud(controller.data.longitud.toString()) &&
                checkPresipitaciones(
                    controller.data.alturaPresipitaciones.toString())) {
              e.errorLongitudText = null;
              e.errorAreaText = null;
              _.update([]);
              //TODO GOTO NEXT
              print("goto next");
            } else {
              print("need fill");
            }
          },
          child: Icon(Icons.check),
        ),
      ),
    );
  }

  bool checkArea(String text) {
    bool res = true;
    controller.data.setArea(text);
    if (controller.data.area < 1) {
      e.errorAreaText = A.negativeNumberError;
      res = false;
    } else {
      e.errorAreaText = null;
    }
    controller.update([IDs.area]);
    return res;
  }

  bool checkLongitud(String text) {
    bool res = true;
    controller.data.setLongitud(text);
    if (controller.data.longitud < 1) {
      e.errorLongitudText = A.negativeNumberError;
      res = false;
    } else {
      e.errorLongitudText = null;
    }
    controller.update([IDs.longitud]);
    return res;
  }

  bool checkPresipitaciones(String text) {
    bool res = true;
    controller.data.setAlturaPresipitaciones(text);
    if (controller.data.alturaPresipitaciones < 1) {
      e.errorPresipitacionesText = A.negativeNumberError;
      res = false;
    } else {
      e.errorPresipitacionesText = null;
    }
    controller.update([IDs.presipitaciones]);
    return res;
  }

  bool checkIntensidad(String text) {
    bool res = true;
    controller.data.setIntensidad(text);
    if (controller.data.intensidad < 1) {
      e.errorIntensidadText = A.negativeNumberError;
      res = false;
    } else {
      e.errorIntensidadText = null;
    }
    controller.update([IDs.presipitaciones]);
    return res;
  }

  void setCategoria(String text) {
    controller.data.setCategoria(text);
    controller.update([IDs.categoria]);
  }
}

class ErrorText {
  String errorAreaText;
  String errorLongitudText;
  String errorPresipitacionesText;
  String errorIntensidadText;
}
