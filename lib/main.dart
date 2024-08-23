import 'package:app_unificada/Calculadora/calculadora_page.dart';
import 'package:app_unificada/Lista/lista_tareas_page.dart';
import 'package:app_unificada/Menu/menu_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  MaterialColor createMaterialColor(Color color) {
    final List<double> strengths = <double>[.05];
    final Map<int, Color> swatch = <int, Color>{};
    final int r = color.red, g = color.green, b = color.blue;

    for (int i = 1; i < 10; i++) {
      strengths.add(0.1 * i);
    }

    for (final double strength in strengths) {
      final double ds = 0.5 - strength;
      swatch[(strength * 1000).round()] = Color.fromARGB(
        color.alpha,
        r + ((ds < 0 ? r : (255 - r)) * ds).round(),
        g + ((ds < 0 ? g : (255 - g)) * ds).round(),
        b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      );
    }

    return MaterialColor(color.value, swatch);
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Color customColor = Color.fromARGB(255, 255, 255, 255);
    final MaterialColor materialColor = createMaterialColor(customColor);
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: materialColor),
        useMaterial3: true,
      ),
      home: const Menu(),
      routes: {
        Calculadora.routeNameCalculadora: (_) => const Calculadora(),
        ListaTareas.routeNameListaTareas: (_) => const ListaTareas()
      },
    );
  }
}
