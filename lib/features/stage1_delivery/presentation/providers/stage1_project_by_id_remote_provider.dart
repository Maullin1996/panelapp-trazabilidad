import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/stage1_form_data.dart';
import 'index.dart';

final stage1ProjectByIdRemoteProvider =
    FutureProvider.family<Stage1FormData?, String>((ref, id) {
      return ref.read(getStage1DataByIdProvider)(id);
    });
