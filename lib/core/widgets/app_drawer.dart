import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Drawer lateral reutilizable para navegación
class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({
    super.key,
    required this.currentRoute,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
              isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            // Header con gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
              decoration: BoxDecoration(
                gradient: isDark ? AppColors.primaryGradientDark : AppColors.primaryGradientLight,
                boxShadow: [
                  BoxShadow(
                    color: (isDark ? AppColors.primaryDark : AppColors.primaryLight).withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Logo/Icono
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.store_rounded,
                      size: 40,
                      color: AppColors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'ARAS App',
                    style: AppTextStyles.headlineMedium(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Sistema de Gestión',
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),

            // Menú de navegación
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 8),
                children: [
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.dashboard_rounded,
                    title: 'Dashboard',
                    route: '/dashboard',
                    isSelected: currentRoute == '/dashboard',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.inventory_2_rounded,
                    title: 'Productos',
                    route: '/products',
                    isSelected: currentRoute == '/products',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.category_rounded,
                    title: 'Categorías',
                    route: '/categories',
                    isSelected: currentRoute == '/categories',
                  ),
                  
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Divider(),
                  ),
                  
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.sync_rounded,
                    title: 'Sincronización',
                    route: '/sync',
                    isSelected: currentRoute == '/sync',
                  ),
                  _buildDrawerItem(
                    context: context,
                    icon: Icons.settings_rounded,
                    title: 'Configuración',
                    route: '/settings',
                    isSelected: currentRoute == '/settings',
                  ),
                ],
              ),
            ),

            // Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: isDark ? AppColors.gray700 : AppColors.gray200,
                  ),
                ),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: isDark ? AppColors.primaryContainerDark : AppColors.primaryContainerLight,
                    child: Icon(
                      Icons.person_rounded,
                      color: isDark ? AppColors.primaryDark : AppColors.primaryLight,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Usuario',
                          style: AppTextStyles.labelLarge(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'usuario@aras.com',
                          style: AppTextStyles.labelSmall(
                            color: isDark
                                ? AppColors.textSecondaryDark
                                : AppColors.textSecondaryLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // TODO: Implementar logout
                    },
                    icon: Icon(
                      Icons.logout_rounded,
                      color: AppColors.error,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String route,
    required bool isSelected,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        gradient: isSelected 
            ? (isDark ? AppColors.primaryGradientDark : AppColors.primaryGradientLight) 
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected
              ? AppColors.white
              : isDark
                  ? AppColors.textPrimaryDark
                  : AppColors.textPrimaryLight,
        ),
        title: Text(
          title,
          style: AppTextStyles.bodyLarge(
            color: isSelected
                ? AppColors.white
                : isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        onTap: () {
          Navigator.pop(context); // Cerrar drawer
          if (!isSelected) {
            Navigator.pushReplacementNamed(context, route);
          }
        },
      ),
    );
  }
}
