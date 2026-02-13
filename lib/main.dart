import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'injection_container.dart' as di;
import 'presentation/providers/product_provider.dart';
import 'presentation/providers/category_provider.dart';
import 'presentation/providers/connectivity_provider.dart';
import 'presentation/screens/product_list_screen.dart';
import 'presentation/screens/category_list_screen.dart';
import 'data/datasources/local/database_helper.dart';
import 'core/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar dependencias
  await di.initializeDependencies();
  // Aws

  // Inicializar base de datos
  await di.sl<DatabaseHelper>().database;

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => di.sl<ProductProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<CategoryProvider>(),
        ),
        ChangeNotifierProvider(
          create: (_) => di.sl<ConnectivityProvider>(),
        ),
      ],
      child: MaterialApp(
        title: 'ARAS App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        initialRoute: '/products',
        routes: {
          '/products': (context) => const ProductListScreen(),
          '/categories': (context) => const CategoryListScreen(),
        },
      ),
    );
  }
}
