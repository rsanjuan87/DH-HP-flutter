import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/state_manager.dart';
import 'package:text/controllers/HomeController.dart';
import 'package:text/gen_a/A.dart';
import 'package:text/pages/widgets/SanWidgets.dart';

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
      builder: (_) => CollapsingPagefold(
        context,
        title: A.app_name,
        defaultAction: SanAction(Icons.navigate_next, text: A.done, onTap: () {
          if (checkAll()) {
            e.errorLongitudText = null;
            e.errorAreaText = null;
            _.update([]);
            print("goto next");
            _.goSectionsPage();
          } else {
            print("need fill before");
          }
        }),
        rigth: [
          SanAction(null, text: 'lolo'),
          SanAction(Icons.error, text: 'lolo'),
          SanAction(Icons.ac_unit),
        ],
        center: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                    child: Text(
                  A.initial_data,
                  style: TextStyle(fontSize: 20),
                )),
              ),
              GetBuilder<HomeController>(
                id: IDs.area,
                builder: (_) => Padding(
                  padding: const EdgeInsets.all(8.0),
                          child: Edit(
                              label: A.area_cuenca,
                              onChanged: (text) => checkArea(text),
                              errorText: e.errorAreaText),
                        ),
                  ),
                  GetBuilder<HomeController>(
                    id: IDs.longitud,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Edit(
                        errorText: e.errorLongitudText,
                        label: A.longitud_del_rio,
                        keyboardType: TextInputType.number,
                        onChanged: (text) => checkLongitud(text),
                      ),
                    ),
                  ),
                  GetBuilder<HomeController>(
                    id: IDs.pendiente,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Edit(
                        errorText: e.errorPendienteText,
                        label: A.pendiente,
                        keyboardType: TextInputType.number,
                        onChanged: (text) => checkPendiente(text),
                      ),
                    ),
                  ),
                  GetBuilder<HomeController>(
                    id: IDs.presipitaciones,
                    builder: (_) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Edit(
                        errorText: e.errorPresipitacionesText,
                        label: A.altura_resipitaciones,
                        keyboardType: TextInputType.number,
                        onChanged: (text) => checkPresipitaciones(text),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: <Widget>[
                        GetBuilder<HomeController>(
                          id: IDs.intensidad,
                          builder: (_) =>
                              Edit(
                                controller: TextEditingController(
                                  text: _.data.intensidad.toStringAsFixed(3),
                                ),
                                errorText: e.errorIntensidadText,
                                label: A.intensidad,
                                keyboardType: TextInputType.number,
                                onChanged: (text) => checkIntensidad(text),
                                readOnly: true,
                                onTap: () => selectIntensidad(),
                              ),
                        ),
                        GestureDetector(
                            onTap: () {
                              selectIntensidad();
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Icon(Icons.my_location_sharp),
                            )
                        )
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
                            items: <String>[A.select, A.autopista, A.i_ii, A.iii_iv]
                                .map((String value) =>
                            new DropdownMenuItem<String>(
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
                          .replaceAll(
                          "%1d3", _.data.caudalCalculado().toStringAsFixed(3))
                          .replaceAll("%2d3", _.data.rangoMin().toStringAsFixed(3))
                          .replaceAll("%3d3", _.data.rangoMax().toStringAsFixed(3)),
                      style: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
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
    } else if (controller.data.area > 30) {
      e.errorAreaText = A.area_muy_grande;
      res = false;
    } else {
      e.errorAreaText = null;
    }
    controller.update();
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
    controller.update();
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
    controller.update();
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
    controller.update();
    return res;
  }

  void setCategoria(String text) {
    controller.data.setCategoria(text);
    controller.update();
  }

  checkPendiente(String text) {
    bool res = true;
    controller.data.setPendiente(text);
    if (controller.data.pendiente < 1) {
      e.errorPendienteText = A.negativeNumberError;
      res = false;
    } else {
      e.errorPendienteText = null;
    }
    controller.update();
    return res;
  }

  bool checkCategoria(String categoria) {
    bool res = controller.data.categoriaIndex > -1;
    if (!res) {
      Fluttertoast.showToast(
        msg: A.error_select_cattegory,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );
    }
    return res;
  }

  selectIntensidad() {
    if (checkArea(controller.data.area.toString()) &&
        checkLongitud(controller.data.longitud.toString()) &&
        checkPendiente(controller.data.pendiente.toString()) &&
        checkPresipitaciones(controller.data.alturaPresipitaciones.toString()))
      controller.selectIntensidad();
    else
      Fluttertoast.showToast(
        msg: A.debe_insertar_algunos_datos_antes,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
      );
  }

  bool checkAll() {
    return checkArea(controller.data.area.toString()) &&
        checkLongitud(controller.data.longitud.toString()) &&
        checkPendiente(controller.data.pendiente.toString()) &&
        checkCategoria(controller.data.categoria) &&
        checkIntensidad(controller.data.intensidad.toString()) &&
        checkPresipitaciones(
            controller.data.alturaPresipitaciones.toString());
  }
}

class ErrorText {
  String errorAreaText;
  String errorLongitudText;
  String errorPresipitacionesText;
  String errorIntensidadText;
  String errorPendienteText;
}
