import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../../domain/entities/category.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Modal profesional para crear/editar categorías
class CategoryFormModal {
  static Future<void> show(
    BuildContext context, {
    Category? category,
  }) async {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CategoryFormContent(category: category),
    );
  }
}

class _CategoryFormContent extends StatefulWidget {
  final Category? category;

  const _CategoryFormContent({this.category});

  @override
  State<_CategoryFormContent> createState() => _CategoryFormContentState();
}

class _CategoryFormContentState extends State<_CategoryFormContent> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedIcon;
  String? _selectedColor;
  bool _isLoading = false;

  // Iconos disponibles
  final List<Map<String, dynamic>> _availableIcons = [
    {'name': 'category', 'icon': Icons.category_rounded},
    {'name': 'shopping_cart', 'icon': Icons.shopping_cart_rounded},
    {'name': 'restaurant', 'icon': Icons.restaurant_rounded},
    {'name': 'devices', 'icon': Icons.devices_rounded},
    {'name': 'sports', 'icon': Icons.sports_soccer_rounded},
    {'name': 'book', 'icon': Icons.book_rounded},
    {'name': 'home', 'icon': Icons.home_rounded},
    {'name': 'work', 'icon': Icons.work_rounded},
    {'name': 'favorite', 'icon': Icons.favorite_rounded},
    {'name': 'star', 'icon': Icons.star_rounded},
  ];

  // Colores profesionales
  late final List<Map<String, dynamic>> _availableColors = List.generate(
    AppColors.categoryColors.length,
    (index) => {
      'name': AppColors.categoryColorNames[index],
      'color': AppColors.categoryColors[index],
      'hex': AppColors.categoryColorHex[index],
    },
  );

  @override
  void initState() {
    super.initState();
    if (widget.category != null) {
      _nameController.text = widget.category!.name;
      _descriptionController.text = widget.category!.description ?? '';
      _selectedIcon = widget.category!.icon;
      _selectedColor = widget.category!.color;
    } else {
      _selectedIcon = 'category';
      _selectedColor = '#1976D2'; // Azul por defecto
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveCategory() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final categoryProvider = context.read<CategoryProvider>();
    bool success;

    if (widget.category == null) {
      success = await categoryProvider.createNewCategory(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );
    } else {
      final updatedCategory = widget.category!.copyWith(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim().isEmpty
            ? null
            : _descriptionController.text.trim(),
        icon: _selectedIcon,
        color: _selectedColor,
      );

      success = await categoryProvider.updateExistingCategory(updatedCategory);
    }

    setState(() => _isLoading = false);

    if (mounted) {
      if (success) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.category == null
                  ? 'Categoría creada correctamente'
                  : 'Categoría actualizada correctamente',
            ),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              categoryProvider.errorMessage ?? 'Error al guardar categoría',
            ),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    final bottomPadding = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(bottom: bottomPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: Theme.of(context).brightness == Brightness.dark
                  ? AppColors.primaryGradientDark
                  : AppColors.primaryGradientLight,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isEditing ? Icons.edit_rounded : Icons.add_rounded,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    isEditing ? 'Editar Categoría' : 'Nueva Categoría',
                    style: AppTextStyles.headlineSmall(
                      color: AppColors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close_rounded, color: AppColors.white),
                ),
              ],
            ),
          ),

          // Form
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Nombre
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Nombre *',
                        hintText: 'Ej: Electrónica',
                        prefixIcon: Icon(Icons.label_rounded),
                      ),
                      textCapitalization: TextCapitalization.words,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'El nombre es requerido';
                        }
                        if (value.trim().length < 3) {
                          return 'El nombre debe tener al menos 3 caracteres';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 16),

                    // Descripción
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Descripción',
                        hintText: 'Descripción opcional',
                        prefixIcon: Icon(Icons.description_rounded),
                      ),
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                    ),

                    const SizedBox(height: 20),

                    // Selector de icono
                    Text(
                      'Icono',
                      style: AppTextStyles.titleSmall(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableIcons.map((iconData) {
                        final isSelected = _selectedIcon == iconData['name'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedIcon = iconData['name'];
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppColors.primary
                                  : AppColors.gray100,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.transparent,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              iconData['icon'],
                              color: isSelected ? AppColors.white : AppColors.gray700,
                              size: 24,
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    // Selector de color
                    Text(
                      'Color',
                      style: AppTextStyles.titleSmall(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _availableColors.map((colorData) {
                        final isSelected = _selectedColor == colorData['hex'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedColor = colorData['hex'];
                            });
                          },
                          child: Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              color: colorData['color'],
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: isSelected ? AppColors.black : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(
                                    Icons.check_rounded,
                                    color: AppColors.white,
                                    size: 28,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 24),

                    // Botones
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading ? null : () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _saveCategory,
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.white,
                                      ),
                                    ),
                                  )
                                : Text(isEditing ? 'Actualizar' : 'Crear'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
