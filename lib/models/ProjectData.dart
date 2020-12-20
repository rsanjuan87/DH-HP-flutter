import 'package:text/gen_a/A.dart';

class ProjectData {
  double area = 0;

  int sectionsCount = 35; //todo poner en 0;

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

  static double caudalDisenno(
      double area, double coeficiente, double intensidad, double factorProb) {
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
}
