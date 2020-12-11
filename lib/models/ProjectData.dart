import 'package:text/gen_a/A.dart';

class ProjectData {
  double area = 0;

  void setArea(String _) => area = double.tryParse(_) ?? 0;

  double longitud = 0;

  void setLongitud(String _) => longitud = double.tryParse(_) ?? 0;

  double alturaPresipitaciones = 0;

  void setAlturaPresipitaciones(String _) =>
      alturaPresipitaciones = double.tryParse(_) ?? 0;

  double intensidad = 0;

  void setIntensidad(String _) => intensidad = double.tryParse(_) ?? 0;

  String categoria = A.autopista;
  int categoriaIndex = 0;

  void setCategoria(String _) {
    if (_ == A.autopista)
      categoriaIndex = 0;
    else if (_ == A.i_ii)
      categoriaIndex = 1;
    else
      categoriaIndex = 2;
    categoria = _;
  }

  double caudalCalculado() {
    return 0;
  }

  double rangoMin() {
    return 0;
  }

  double rangoMax() {
    return 0;
  }
}
