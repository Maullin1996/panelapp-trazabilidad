import 'package:flutter/material.dart';
import 'package:core/shared/utils/tokens.dart';

class WebLayout extends StatelessWidget {
  final Widget child;
  final int selectedIndex;
  final void Function(int) onDestinationSelected;

  const WebLayout({
    super.key,
    required this.child,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundCrema,
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: AppColors.cardBackground,
            selectedIndex: selectedIndex,
            onDestinationSelected: onDestinationSelected,
            labelType: NavigationRailLabelType.all,
            indicatorColor: AppColors.primaryPanelaBrown.withAlpha(30),
            selectedIconTheme: const IconThemeData(
              color: AppColors.primaryPanelaBrown,
            ),
            selectedLabelTextStyle: const TextStyle(
              color: AppColors.primaryPanelaBrown,
              fontWeight: FontWeight.w600,
            ),
            unselectedIconTheme: IconThemeData(
              color: AppColors.textDark.withAlpha(150),
            ),
            unselectedLabelTextStyle: TextStyle(
              color: AppColors.textDark.withAlpha(150),
            ),
            leading: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.medium),
              child: Image.asset('assets/images/logo.png', width: 48),
            ),
            destinations: const [
              NavigationRailDestination(
                icon: Icon(Icons.folder_outlined),
                selectedIcon: Icon(Icons.folder),
                label: Text('Proyectos'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2),
                label: Text('Inventario'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.admin_panel_settings_outlined),
                selectedIcon: Icon(Icons.admin_panel_settings),
                label: Text('Admin'),
              ),
              NavigationRailDestination(
                icon: Icon(Icons.store_outlined),
                selectedIcon: Icon(Icons.store),
                label: Text('Moliendas'),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: child),
        ],
      ),
    );
  }
}
