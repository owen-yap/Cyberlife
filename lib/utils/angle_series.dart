class AngleSeries {
  AngleSeries(this.id, this.angle);

  final int id;
  final double angle;
}

List<AngleSeries> generateSeries(List<double> list) {
  int id = 0;
  List<AngleSeries> res = <AngleSeries>[];
  for (var item in list) {
    res.add(AngleSeries(id, item));
    id++;
  }
  return res;
}

