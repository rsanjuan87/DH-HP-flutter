import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:text/controllers/HomeController.dart';
import 'package:text/gen_a/A.dart';

import 'widgets/CustomDataTable.dart';

class SectionsPage extends StatelessWidget {
  HomeController controller;
  ErrorText e;

  SectionsPage(HomeController _) {
    e = ErrorText();
    controller = _;
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      init: controller,
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text(A.sections),
        ),
        body: Padding(
          padding: const EdgeInsets.only(bottom: 250),
          child: CustomDataTable(
            rowsCells: _buildData(),
            fixedColCells: sectionsList(_.data.sectionsCount),
            fixedRowCells: [
              A.Ni,
              A.Aim3,
              A.Pim,
              A.Rim,
              A.EAm,
              A.Qim3s,
              A.QEm3s,
            ],
            fixedCornerCell: A.seccion,
            cellBuilder: (data) {
              return Text(data is double ? data.toStringAsFixed(3) : '$data',
                  style: TextStyle());
            },
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: Text(
                            A.caudal_de_disenno
                                .replaceAll("%1d3",
                                    _.data.caudalCalculado().toStringAsFixed(3))
                                .replaceAll("%2d3",
                                    _.data.rangoMin().toStringAsFixed(3))
                                .replaceAll("%3d3",
                                    _.data.rangoMax().toStringAsFixed(3))
                                .replaceAll("\n", ''),
                            style: TextStyle(fontSize: 12),
                          ),
                        ),
                        Text(
                          A.no_se_cumple_condicion_de_parada,
                          style: TextStyle(color: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      Text(A.seleccione_cuase_principal),
                      Spacer(),
                      DropdownButton<String>(
                        items: (sectionsList(_.data.sectionsCount))
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (text) => {
                          //todo set cause principal min
                        },
                      ),
                      Text('..'),
                      DropdownButton<String>(
                        items: (sectionsList(_.data.sectionsCount))
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (text) => {
                          //todo set cause principal min
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: Row(
                    children: [
                      Text(A.seleccione_secciones_entre_estribos),
                      Spacer(),
                      DropdownButton<String>(
                        items: (sectionsList(_.data.sectionsCount))
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (text) => {
                          //todo set cause principal min
                        },
                      ),
                      Text('..'),
                      DropdownButton<String>(
                        items: (sectionsList(_.data.sectionsCount))
                            .map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: new Text(value),
                            ),
                          );
                        }).toList(),
                        onChanged: (text) => {
                          //todo set cause principal min
                        },
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(color: Colors.white),
                child: Stack(children: <Widget>[
                  Align(
                    alignment: Alignment.bottomRight,
                    child: FloatingActionButton.extended(
                      heroTag: A.siguiente,
                      onPressed: () {
                        if (false) {
                          print("goto next");
                          _.goSectionsPage();
                        } else {
                          print("need fill before");
                        }
                      },
                      icon: Icon(Icons.navigate_next),
                      label: Text(A.siguiente),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: FloatingActionButton.extended(
                      heroTag: A.reset,
                      onPressed: () {
                        if (false) {
                          print("goto next");
                          _.goSectionsPage();
                        } else {
                          print("need fill before");
                        }
                      },
                      icon: Icon(Icons.delete_outlined),
                      label: Text(A.clear),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ]),
              ),
            ],
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      ),
    );
  }

  List<String> sectionsList(int count) {
    List<String> list = new List<String>();
    for (int i = 0; i < count; i++) {
      list.add(i.toString());
    }
    return list;
  }

  List<List<double>> _buildData() {
    List<List<double>> list = List<List<double>>();

    for (int i = 0; i < controller.data.sectionsCount; i++) {
      List<double> t = new List();
      for (int j = 0; j < 7; j++) {
        switch (j) {
          case 4:
            t.add(t[1] + (i == 0 ? 0 : list[i - 1][4]));
            break;
          case 6:
            t.add(t[5] + (i == 0 ? 0 : list[i - 1][6]));
            break;


          default:
            t.add(pow(i + j, .2));
            break;
        }
      }
      list.add(t);
    }
    return list;
  }
}

class ErrorText {}
