import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/category_card.dart';
import '../widgets/connectivity_banner.dart';
import '../widgets/category_form_modal.dart';
import '../../core/widgets/app_drawer.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Pantalla de lista de categorías
class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCategories();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCategories() async {
    await context.read<CategoryProvider>().loadCategories();
  }

  Future<void> _syncCategories() async {
    final categoryProvider = context.read<CategoryProvider>();
    final success = await categoryProvider.syncWithServer();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Categorías sincronizadas correctamente'
                : categoryProvider.errorMessage ?? 'Error al sincronizar',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  Future<void> _deleteCategory(int id) async {
    final categoryProvider = context.read<CategoryProvider>();
    final success = await categoryProvider.deleteExistingCategory(id);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Categoría eliminada'
                : categoryProvider.errorMessage ?? 'Error al eliminar',
          ),
          backgroundColor: success ? AppColors.success : AppColors.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/categories'),
      appBar: AppBar(
        title: Text(
          'Categorías',
          style: AppTextStyles.headlineSmall(color: AppColors.white),
        ),
        actions: [
          // Botón de sincronización
          Consumer<ConnectivityProvider>(
            builder: (context, connectivity, _) {
              if (!connectivity.isConnected) return const SizedBox.shrink();

              return IconButton(
                onPressed: _syncCategories,
                icon: const Icon(Icons.sync_rounded),
                tooltip: 'Sincronizar',
              );
            },
          ),
          // Botón de búsqueda
          IconButton(
            onPressed: () {
              setState(() {
                if (_searchQuery.isEmpty) {
                  // Mostrar búsqueda
                } else {
                  _searchQuery = '';
                  _searchController.clear();
                }
              });
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: Column(
        children: [
          // Banner de conectividad
          const ConnectivityBanner(),

          // Barra de búsqueda
          if (_searchController.text.isNotEmpty || _searchQuery.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Buscar categorías...',
                  prefixIcon: const Icon(Icons.search_rounded),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear_rounded),
                    onPressed: () {
                      setState(() {
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),

          // Lista de categorías
          Expanded(
            child: Consumer<CategoryProvider>(
              builder: (context, provider, _) {
                if (provider.isLoading && provider.categories.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (provider.hasError && provider.categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline_rounded,
                          size: 64,
                          color: AppColors.error,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          provider.errorMessage ?? 'Error desconocido',
                          style: AppTextStyles.bodyLarge(color: AppColors.error),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadCategories,
                          icon: const Icon(Icons.refresh_rounded),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                final categories = _searchQuery.isEmpty
                    ? provider.categories
                    : provider.searchByName(_searchQuery);

                if (categories.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.category_outlined,
                          size: 64,
                          color: AppColors.gray400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? 'No hay categorías'
                              : 'No se encontraron categorías',
                          style: AppTextStyles.bodyLarge(color: AppColors.gray600),
                        ),
                        if (_searchQuery.isEmpty) ...[
                          const SizedBox(height: 8),
                          Text(
                            'Crea tu primera categoría',
                            style: AppTextStyles.bodyMedium(color: AppColors.gray500),
                          ),
                        ],
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: _loadCategories,
                  child: ListView.builder(
                    itemCount: categories.length,
                    padding: const EdgeInsets.only(bottom: 80),
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return CategoryCard(
                        category: category,
                        onTap: () {
                          // Ver detalles
                        },
                        onEdit: () {
                          CategoryFormModal.show(context, category: category);
                        },
                        onDelete: () async {
                          final confirmed = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Eliminar categoría'),
                              content: Text(
                                '¿Estás seguro de eliminar "${category.name}"?',
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context, false),
                                  child: const Text('Cancelar'),
                                ),
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(context, true),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.error,
                                  ),
                                  child: const Text('Eliminar'),
                                ),
                              ],
                            ),
                          );

                          if (confirmed == true && category.id != null) {
                            await _deleteCategory(category.id!);
                          }
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          CategoryFormModal.show(context);
        },
        icon: const Icon(Icons.add_rounded),
        label: const Text('Nueva Categoría'),
      ),
    );
  }
}
