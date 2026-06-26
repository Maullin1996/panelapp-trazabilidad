import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:core/features/molienda/providers/molienda_providers.dart';
import 'package:core/shared/utils/tokens.dart';
import 'package:core/shared/widgets/widgets.dart';

class MoliendaEntregasList extends ConsumerWidget {
  final String moliendaId;
  const MoliendaEntregasList({super.key, required this.moliendaId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = TextTheme.of(context);
    final entregasAsync = ref.watch(moliendaEntregasProvider(moliendaId));

    return entregasAsync.when(
      loading: () => const Center(
        child: CircularProgressIndicator(color: AppColors.primaryPanelaBrown),
      ),
      error: (e, _) => ErrorWidgetCustom(error: e.toString()),
      data: (entregas) {
        if (entregas.isEmpty) {
          return Center(
            child: Text(
              'Sin entregas registradas',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.textDark.withValues(alpha: 0.47),
              ),
            ),
          );
        }
        return ListView.separated(
          shrinkWrap: true,
          itemCount: entregas.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final entrega = entregas[index];
            return ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                DateFormat('dd/MM/yyyy HH:mm').format(entrega.fechaEntrega),
                style: textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              trailing: IconButton(
                icon: const Icon(
                  Icons.qr_code_2_outlined,
                  color: AppColors.primaryPanelaBrown,
                  size: 30,
                ),
                tooltip: 'Ver QR',
                onPressed: () {
                  Navigator.of(context).pop();
                  context.pushNamed(
                    'entregaDetail',
                    pathParameters: {
                      'moliendaId': moliendaId,
                      'entregaId': entrega.id,
                    },
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
