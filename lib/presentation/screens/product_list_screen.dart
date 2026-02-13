import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/widgets/app_drawer.dart';
import '../providers/product_provider.dart';
import '../providers/connectivity_provider.dart';
import '../widgets/connectivity_banner.dart';
import '../widgets/product_card.dart';
import '../widgets/product_form_modal.dart';

/// Pantalla principal que muestra la lista de productos
class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  void initState() {
    super.initState();
    // Cargar productos al iniciar
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });

    // Auto-sincronizar cuando se detecte conexión
    _setupAutoSync();
  }

  void _setupAutoSync() {
    final connectivityProvider = context.read<ConnectivityProvider>();
    connectivityProvider.addListener(() {
      if (connectivityProvider.isConnected && !connectivityProvider.isSyncing) {
        _syncProducts();
      }
    });
  }

  Future<void> _syncProducts() async {
    final productProvider = context.read<ProductProvider>();
    final connectivityProvider = context.read<ConnectivityProvider>();

    connectivityProvider.setSyncing(true);
    await productProvider.syncProducts();
    connectivityProvider.setSyncing(false);
  }

  Future<void> _refreshProducts() async {
    final productProvider = context.read<ProductProvider>();
    final connectivityProvider = context.read<ConnectivityProvider>();
    
    await productProvider.loadProducts();
    if (connectivityProvider.isConnected) {
      await _syncProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(currentRoute: '/products'),
      appBar: AppBar(
        title: const Text('Productos'),
        actions: [
          Consumer<ConnectivityProvider>(
            builder: (context, connectivity, child) {
              return IconButton(
                icon: const Icon(Icons.sync),
                onPressed: connectivity.isConnected && !connectivity.isSyncing
                    ? _syncProducts
                    : null,
                tooltip: 'Sincronizar',
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          const ConnectivityBanner(),
          Expanded(
            child: Consumer<ProductProvider>(
              builder: (context, productProvider, child) {
                // Estado de carga
                if (productProvider.isLoading && productProvider.products.isEmpty) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                // Estado de error
                if (productProvider.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          productProvider.errorMessage ?? 'Error desconocido',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: () {
                            productProvider.clearError();
                            productProvider.loadProducts();
                          },
                          icon: const Icon(Icons.refresh),
                          label: const Text('Reintentar'),
                        ),
                      ],
                    ),
                  );
                }

                // Lista vacía
                if (productProvider.products.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No hay productos',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: Colors.grey.shade600,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Agrega tu primer producto',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey.shade500,
                              ),
                        ),
                      ],
                    ),
                  );
                }

                // Lista de productos
                return RefreshIndicator(
                  onRefresh: _refreshProducts,
                  child: ListView.builder(
                    itemCount: productProvider.products.length,
                    padding: const EdgeInsets.only(top: 8, bottom: 80),
                    itemBuilder: (context, index) {
                      final product = productProvider.products[index];
                      return ProductCard(
                        product: product,
                        onTap: () {
                          // Ver detalles (opcional)
                        },
                        onEdit: () => _editProduct(product),
                        onDelete: () => _deleteProduct(product),
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
        onPressed: _createProduct,
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Producto'),
      ),
    );
  }

  void _createProduct() {
    ProductFormModal.show(context);
  }

  void _editProduct(product) {
    ProductFormModal.show(context, product: product);
  }

  Future<void> _deleteProduct(product) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de eliminar "${product.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final productProvider = context.read<ProductProvider>();
      final success = await productProvider.deleteProduct(product.id!);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              success
                  ? 'Producto eliminado'
                  : productProvider.errorMessage ?? 'Error al eliminar',
            ),
            backgroundColor: success ? Colors.green : Colors.red,
          ),
        );
      }
    }
  }
}
