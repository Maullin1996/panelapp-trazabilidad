import '../../domain/entities/stage1_form_data.dart';

class Stage1FormModel {
  final String id;
  final String name;
  final String? moliendaId;
  final List<Map<String, dynamic>> gaveras;
  final List<Map<String, dynamic>> baskets;
  final double preservativesWeight;
  final int preservativesJars;
  final double limeWeight;
  final int limeJars;
  final String phone;
  final DateTime date;
  final String? photoPath;

  Stage1FormModel({
    required this.id,
    required this.name,
    this.moliendaId,
    required this.gaveras,
    required this.baskets,
    required this.preservativesWeight,
    required this.preservativesJars,
    required this.limeWeight,
    required this.limeJars,
    required this.phone,
    required this.date,
    this.photoPath,
  });

  factory Stage1FormModel.fromEntity(Stage1FormData data) {
    return Stage1FormModel(
      id: data.id,
      name: data.name,
      moliendaId: data.moliendaId,
      gaveras: data.gaveras
          .map(
            (g) => {
              'quantity': g.quantity,
              'referenceWeight': g.referenceWeight,
              'gaveraType': g.gaveraType, // ← ya es String
            },
          )
          .toList(),
      baskets: data.baskets
          .map((b) => {'size': b.size.name, 'quantity': b.quantity})
          .toList(),
      preservativesWeight: data.preservativesWeight,
      preservativesJars: data.preservativesJars,
      limeWeight: data.limeWeight,
      limeJars: data.limeJars,
      phone: data.phone,
      date: data.date,
      photoPath: data.photoPath,
    );
  }

  Stage1FormData toEntity() {
    return Stage1FormData(
      id: id,
      name: name,
      moliendaId: moliendaId,
      gaveras: gaveras
          .map(
            (g) => GaveraData(
              quantity: (g['quantity'] as num).toInt(),
              referenceWeight: (g['referenceWeight'] as num).toDouble(),
              gaveraType: g['gaveraType'] as String, // ← ya es String
            ),
          )
          .toList(),
      baskets: baskets
          .map(
            (b) => BasketData(
              size: BasketSize.values.byName(b['size'] as String),
              quantity: (b['quantity'] as num).toInt(),
            ),
          )
          .toList(),
      preservativesWeight: (preservativesWeight as num).toDouble(),
      preservativesJars: (preservativesJars as num).toInt(),
      limeWeight: (limeWeight as num).toDouble(),
      limeJars: (limeJars as num).toInt(),
      phone: phone,
      date: date,
      photoPath: photoPath,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'moliendaId': moliendaId,
      'gaveras': gaveras,
      'baskets': baskets,
      'preservativesWeight': preservativesWeight,
      'preservativesJars': preservativesJars,
      'limeWeight': limeWeight,
      'limeJars': limeJars,
      'phone': phone,
      'date': date.toIso8601String(),
      'photoPath': photoPath,
    };
  }

  factory Stage1FormModel.fromJson(Map<String, dynamic> json) {
    return Stage1FormModel(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      moliendaId: json['moliendaId'] as String?,
      gaveras: List<Map<String, dynamic>>.from(json['gaveras'] ?? []),
      baskets: List<Map<String, dynamic>>.from(json['baskets'] ?? []),
      preservativesWeight:
          (json['preservativesWeight'] as num?)?.toDouble() ?? 0.0,
      preservativesJars: (json['preservativesJars'] as num?)?.toInt() ?? 0,
      limeWeight: (json['limeWeight'] as num?)?.toDouble() ?? 0.0,
      limeJars: (json['limeJars'] as num?)?.toInt() ?? 0,
      phone: json['phone'] as String? ?? '',
      date: json['date'] != null
          ? DateTime.parse(json['date'] as String)
          : DateTime.now(),
      photoPath: json['photoPath'] as String?,
    );
  }
}
