import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:text/controllers/HomeController.dart';
import 'package:text/gen_a/A.dart';
import 'package:text/pages/widgets/SanWidgets.dart';

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
      builder: (_) => CollapsingPagefold(
        context,
        title: A.sections,
        center: Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Column(
            children: [
              CustomDataTable(
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
                  return Text(
                      data is double ? data.toStringAsFixed(3) : '$data',
                      style: TextStyle());
                },
              ),
              Spacer(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 60),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: Text(
                                A.caudal_de_disenno
                                    .replaceAll(
                                        "%1d3",
                                        _.data
                                            .caudalCalculado()
                                            .toStringAsFixed(3))
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
                    Padding(
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
                    Padding(
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
                    CmdButton(
                      text: A.reset_sections,
                      accentColor: Colors.red,
                      icon: CupertinoIcons.delete,
                      backColor: Theme.of(context).dialogBackgroundColor,
                      onTap: () {
                        if (false) {
                          print("goto next");
                          _.goSectionsPage();
                        } else {
                          print("need fill before");
                        }
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        defaultAction: SanAction(
          Icons.navigate_next,
          onTap: () {
            if (false) {
              print("goto next");
              _.goSectionsPage();
            } else {
              print("need fill before");
            }
          },
          text: A.done,
        ),
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
