import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

/// Modal reutilizable y configurable para toda la aplicación
class AppModal {
  /// Mostrar modal básico
  static Future<T?> show<T>({
    required BuildContext context,
    required Widget child,
    bool isDismissible = true,
    bool enableDrag = true,
    Color? backgroundColor,
    double? height,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isDismissible: isDismissible,
      enableDrag: enableDrag,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: height,
        decoration: BoxDecoration(
          color: backgroundColor ?? Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: child,
      ),
    );
  }
  
  /// Modal de confirmación
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirmar',
    String cancelText = 'Cancelar',
    Color? confirmColor,
    IconData? icon,
    bool isDangerous = false,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: icon != null
            ? Icon(
                icon,
                size: 48,
                color: isDangerous ? AppColors.error : AppColors.primary,
              )
            : null,
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(cancelText),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: isDangerous
                  ? AppColors.error
                  : (confirmColor ?? AppColors.primary),
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
  
  /// Modal de opciones (lista de opciones)
  static Future<T?> showOptions<T>({
    required BuildContext context,
    required String title,
    required List<ModalOption<T>> options,
    String? subtitle,
  }) {
    return show<T>(
      context: context,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall(),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          
          // Options
          ...options.map((option) => ListTile(
                leading: option.icon != null
                    ? Icon(option.icon, color: option.color)
                    : null,
                title: Text(
                  option.title,
                  style: AppTextStyles.bodyLarge(color: option.color),
                ),
                subtitle: option.subtitle != null
                    ? Text(option.subtitle!)
                    : null,
                onTap: () => Navigator.pop(context, option.value),
              )),
          
          const SizedBox(height: 24),
        ],
      ),
    );
  }
  
  /// Modal de formulario personalizado
  static Future<T?> showForm<T>({
    required BuildContext context,
    required String title,
    required Widget form,
    String? subtitle,
    double? height,
  }) {
    return show<T>(
      context: context,
      height: height ?? MediaQuery.of(context).size.height * 0.9,
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.gray300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          
          // Header
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Text(
                  title,
                  style: AppTextStyles.headlineSmall(),
                  textAlign: TextAlign.center,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodyMedium(
                      color: AppColors.textSecondaryLight,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ],
            ),
          ),
          
          // Form
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: form,
            ),
          ),
        ],
      ),
    );
  }
  
  /// Modal de loading
  static Future<T?> showLoading<T>({
    required BuildContext context,
    String message = 'Cargando...',
  }) {
    return showDialog<T>(
      context: context,
      barrierDismissible: false,
      builder: (context) => PopScope(
        canPop: false,
        child: Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(
                    message,
                    style: AppTextStyles.bodyMedium(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  /// Modal de éxito
  static Future<void> showSuccess({
    required BuildContext context,
    required String message,
    String title = '¡Éxito!',
    Duration duration = const Duration(seconds: 2),
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        Future.delayed(duration, () {
          if (context.mounted) Navigator.pop(context);
        });
        
        return Center(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.successContainer,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_circle,
                      size: 48,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    style: AppTextStyles.titleLarge(
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: AppTextStyles.bodyMedium(),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
  
  /// Modal de error
  static Future<void> showError({
    required BuildContext context,
    required String message,
    String title = 'Error',
  }) {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.errorContainer,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.error_outline,
            size: 48,
            color: AppColors.error,
          ),
        ),
        title: Text(title),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Entendido'),
          ),
        ],
      ),
    );
  }
}

/// Opción para modal de opciones
class ModalOption<T> {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? color;
  final T value;

  ModalOption({
    required this.title,
    this.subtitle,
    this.icon,
    this.color,
    required this.value,
  });
}
