import 'dart:collection';
import 'dart:math';

import 'package:text/gen_a/A.dart';

class ProjectData {
  double area = 0;

  void setArea(String _) => area = double.tryParse(_) ?? 0;

  double pendiente = 0;

  void setPendiente(String _) => pendiente = double.tryParse(_) ?? 0;

  double longitud = 0;

  void setLongitud(String _) => longitud = double.tryParse(_) ?? 0;

  double alturaPresipitaciones = 0;

  void setAlturaPresipitaciones(String _) =>
      alturaPresipitaciones = double.tryParse(_) ?? 0;

  double intensidad = 0;

  void setIntensidad(String _) => intensidad = double.tryParse(_) ?? 0;

  String categoria = A.select;
  int categoriaIndex = -1;
  double factor_prob = 0;

  void setCategoria(String _) {
    if (_ == A.autopista) {
      categoriaIndex = 0; // autopista
      factor_prob = 1;
    } else if (_ == A.i_ii) {
      categoriaIndex = 1; // I - II
      factor_prob = 0.83;
    } else if (_ == A.iii_iv) {
      categoriaIndex = 2; // III - IV
      factor_prob = 0.55;
    } else {
      categoriaIndex = -1; // III - IV
      factor_prob = 0;
    }
    categoria = _;
  }

  static final double KD = 16.67; // COEFICIENTE DEFINIDO
  static final double CONST_SEGURIDAD = 0.25;

  static List<List<double>> matrix = [
    [1.0, 1.0, 1.0, 1.0, 1.0, 1.0],
    [0.96, 0.98, 0.99, 0.99, 1, 1],
    [0.94, 0.97, 0.97, 0.99, 0.99, 1],
    [0.93, 0.95, 0.97, 0.98, 0.99, 0.99],
    [0.9, 0.94, 0.96, 0.97, 0.98, 0.99],
    [0.89, 0.93, 0.95, 0.96, 0.95, 0.99],
    [0.87, 0.92, 0.94, 0.96, 0.98, 0.99],
    [0.85, 0.91, 0.93, 0.95, 0.97, 0.99]
  ];

  double coeficiente = 0;

  double caudalCalculado() {
    coeficiente = coeficienteEscurrimiento(pendiente);
    return caudalDisenno(area, coeficiente, intensidad, factor_prob);
  }

  static double caudalDisenno(double area, double coeficiente, double intensidad, double factorProb) {
    return area * coeficiente * intensidad * KD * factorProb;
  }

  double rangoMin() {
    return caudalCalculado() * 0.95;
  }

  double rangoMax() {
    return caudalCalculado() * 1.05;
  }

  static double coeficienteEscurrimiento(double pendiente) {
    double result = 0;
    if (pendiente <= 0.01) {
      result = 0.65;
    } else if (0.001 < pendiente && pendiente <= 0.02) {
      result = 0.725;
    } else if (0.002 < pendiente && pendiente <= 0.03) {
      result = 0.775;
    } else {
      result = 0.85;
    }
    return result;
  }

  SectionsDesign sections = new SectionsDesign();

  int get sectionsCount => sections.length;
}

enum Formas { Triangulo, Rectangulo, Trapecio }

class Seccion extends LinkedListEntry<Seccion> {
  double getGasto(double pendiente) {
    return (1 / rugosidad) *
        getArea() *
        pow(getRadio(), 0.666666666666667) *
        sqrt(pendiente);
  }

  static double getGastoSeccion(Seccion seccion, double pendiente) {
    return (1 / seccion.rugosidad) *
        seccion.getArea() *
        pow(seccion.getRadio(), 0.666666666666667) *
        sqrt(pendiente);
  }

  static double getGasto_PRAR(
      double pendiente, double radio, double area, double rugosidad) {
    return (1 / rugosidad) *
        area *
        pow(radio, 0.666666666666667) *
        sqrt(pendiente);
  }

  static double getPerimetroMojadoseccion(Seccion seccion) {
    return getPerimetroMojadoA_P_Pa(
        seccion.ancho, seccion.prof, seccion.profAnt);
  }

  static double getPerimetroMojadoA_P_Pa(
      double ancho, double prof, double profAnt) {
    double Pi = 0;
    switch (getFormaP_Pa(prof, profAnt)) {
      case Formas.Triangulo:
        Pi = sqrt(pow(ancho, 2) + pow(max(prof, profAnt), 2));
        break;
      case Formas.Rectangulo:
        Pi = ancho;
        break;
      case Formas.Trapecio:
        Pi = getPerimetroMojadoA_P_Pa(ancho, (prof - profAnt).abs(), 0);
        break;
    }

    return Pi;
  }

  double getPerimetroMojado() {
    double Pi = 0;
    switch (getFormaP_Pa(prof, profAnt)) {
      case Formas.Triangulo:
        Pi = sqrt(pow(ancho, 2) + pow(max(prof, profAnt), 2));
        break;
      case Formas.Rectangulo:
        Pi = ancho;
        break;
      case Formas.Trapecio:
        Pi = getPerimetroMojadoA_P_Pa(ancho, (prof - profAnt).abs(), 0);
        break;
    }

    return Pi;
  }

  static double getRadioAreaPerimetro(double area, double perimetro) {
    return area / perimetro;
  }

  static double getRadioSeccion(Seccion seccion) {
    return seccion.getArea() / seccion.getPerimetroMojado();
  }

  double getRadio() {
    return getArea() / getPerimetroMojado();
  }

  double getProfMax() {
    return prof > profAnt ? prof : profAnt;
  }

  double rugosidad;
  double ancho; //ancho de la session = altura de figura
  double prof; //progundidad mas larga = prof o lado mas largo de la figura
  double profAnt =
      0; //progundidad mas corto = prof o lado mas corto de la figura

  Seccion(double rugosidad, double ancho, double prof, double profAnt) {
    init(rugosidad, ancho, prof, profAnt);
  }

  void init(double rugosidad, double ancho, double prof, double proAnt) {
    this.rugosidad = rugosidad;
    this.ancho = ancho;
    this.prof = prof;
    this.profAnt = proAnt;
  }

  static Formas getFormaP_Pa(double prof, double proAnt) {
    Formas f = Formas.Trapecio;
    if (prof == 0 || proAnt == 0)
      f = Formas.Triangulo;
    else if (prof == proAnt) f = Formas.Rectangulo;
    return f;
  }

  Formas getForma() {
    Formas f = Formas.Trapecio;
    if (prof == 0 || profAnt == 0)
      f = Formas.Triangulo;
    else if (prof == profAnt) f = Formas.Rectangulo;
    return f;
  }

  double getArea() {
    return getAreaAPPa(ancho, prof, profAnt);
  }

  static double getAreaSeccion(Seccion seccion) {
    return getAreaAPPa(seccion.ancho, seccion.prof, seccion.profAnt);
  }

  static double getAreaAPPa(double ancho, double prof, double profAnt) {
    double result;

    if (Seccion.getFormaP_Pa(prof, profAnt) == Formas.Rectangulo) {
      result = ancho * prof;
    } else {
      result = ((prof + profAnt) / 2) * ancho;
    }

    return result;
  }

  String toString() {
    String t = "";
    t +=
        "< Rugosidad: $rugosidad Ancho: $ancho Profundidad izquierda: $profAnt  Profundidad derecha: $prof>";
    return t;
  }
}

class SectionsDesign extends LinkedList<Seccion> {
  double getLastProf() {
    double result = 0;
    try {
      result = last.prof;
    } catch (e) {}

    return result;
  }

  double getAreaAcumulada(int id) {
    double area = 0;
    for (int i = 0; i < id; i++) {
      area += elementAt(i).getArea();
    }
    return area;
  }

  double getGastoAcumulado(int id, double pendiente) {
    double sum = 0;
    for (int i = 0; i < id; i++) {
      sum += elementAt(i).getGasto(pendiente);
    }
    return sum;
  }

  double getGastoAcumuladoTotal(double pendiente) {
    return getGastoAcumulado(length, pendiente);
  }

  double getAreaAcumuladaTotal() {
    return getAreaAcumulada(length);
  }

  double getProfundidadMax() {
    double result = 0;
    forEach((s) {
      if (s.prof > result) result = s.prof;
      if (s.profAnt > result) result = s.profAnt;
    });
    return result;
  }

  double getAreaAcumuladaEntreEstribos(int estriboIpos, int estriboFpos) {
    return getAreaAcumulada(estriboFpos + 1) - getAreaAcumulada(estriboIpos);
  }

  double getAnchoTotal() {
    double result = 0;
    forEach((s) => result += s.ancho);
    return result;
  }

  double getInicio(int pos) {
    double result = 0;
    forEach((entry) => result += entry.ancho);
    return result;
  }

  double getLongitudAcumulada(int estriboIpos, int estriboFpos) {
    double r = 0;
    for (int i = estriboIpos; i <= estriboFpos; i++) {
      r += elementAt(i).ancho;
    }
    return r;
  }
}
