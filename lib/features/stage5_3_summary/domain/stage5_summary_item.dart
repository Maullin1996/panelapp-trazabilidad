// Un ítem agrupado: e.g. “30 canastillas de 28 kg – gavera 950”
class Stage5SummaryItem {
  final double gaveraWeight;
  final double realWeight;
  final int totalCount;

  Stage5SummaryItem({
    required this.gaveraWeight,
    required this.realWeight,
    required this.totalCount,
  });
}

// Un “día” en el resumen
class Stage5SummaryDay {
  final DateTime date;
  final List<Stage5SummaryItem> items;

  Stage5SummaryDay({required this.date, required this.items});
}
