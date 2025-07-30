import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:registro_panela/core/router/routes.dart';
import 'package:registro_panela/shared/utils/tokens.dart';

class StageSelectorPage extends StatelessWidget {
  final String projectId;
  const StageSelectorPage({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.go(Routes.projects)),
        centerTitle: true,
        title: Text('Seleccionar Etapa', style: textTheme.headlineLarge),
      ),
      body: SafeArea(
        child: ListView(
          children: [
            for (var stage = 1; stage <= 5; stage++)
              Padding(
                padding: const EdgeInsets.all(AppSpacing.smallLarge),
                child: Container(
                  decoration: BoxDecoration(
                    color: Color(0xFFFCF8F0),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                  ),
                  child: ListTile(
                    subtitle: Text(
                      _stageSubtitle(stage),
                      style: textTheme.bodyMedium,
                    ),
                    trailing: Icon(Icons.arrow_forward_ios_sharp),
                    contentPadding: EdgeInsetsGeometry.all(AppSpacing.small),
                    dense: true,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        16,
                      ), // Bordes redondeados
                    ),

                    leading: Icon(_iconForStage(stage), size: 35),
                    title: Text(
                      _stageName(stage),
                      style: textTheme.headlineLarge,
                    ),
                    onTap: () => context.go('${byStage(stage)}/$projectId'),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconForStage(int stage) {
    switch (stage) {
      case 1:
        return AppIcons.deliversSupplies;
      case 2:
        return AppIcons.collect;
      case 3:
        return AppIcons.weighing;
      case 4:
        return AppIcons.pickUpSupplies;
      case 5:
        return AppIcons.summarize;
      default:
        return Icons.help;
    }
  }

  String _stageName(int stage) {
    switch (stage) {
      case 1:
        return 'Entrega';
      case 2:
        return 'Cargue';
      case 3:
        return 'Pesado';
      case 4:
        return 'Recogida molienda';
      case 5:
        return 'Liquidación';
      default:
        return 'No encontrado';
    }
  }

  String _stageSubtitle(int stage) {
    switch (stage) {
      case 1:
        return 'Pantalla Para Editar suminitros enviados a la molienda';
      case 2:
        return 'Pantalla para registrar canastillas recogidas en molienda';
      case 3:
        return 'Pantalla para registrar el peso de las canastillas que llegaron a la molienda';
      case 4:
        return 'Pantalla para registrar los suministros vueltos por la molienda';
      case 5:
        return 'Pantalla para de resumen del proyecto y registro de paquetes de panela';
      default:
        return 'No encontrado';
    }
  }
}

String byStage(int n) {
  switch (n) {
    case 1:
      return Routes.stage1;
    case 2:
      return Routes.stage2;
    case 3:
      return Routes.stage3;
    case 4:
      return Routes.stage4;
    case 5:
      return Routes.stage5;
    default:
      return Routes.projects;
  }
}
