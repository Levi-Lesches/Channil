import "package:flutter/material.dart";
import "package:flutter/services.dart";

import "package:channil/models.dart";
import "package:channil/pages.dart";
import "package:channil/services.dart";
import "package:channil/widgets.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await services.init();
  await models.init();
  runApp(const MyApp());
}

const channilGreen = Color(0xff005A43);

class ChipLabelColor extends Color implements MaterialStateColor {
  const ChipLabelColor() : super(0xff000000);

  @override
  Color resolve(Set<MaterialState> states) {
    if (states.contains(MaterialState.selected)) {
      return Colors.white; // Selected text color
    }
    return Colors.black; // normal text color
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: "Flutter Demo",
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      useMaterial3: true,
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.black,
          minimumSize: const Size(100, 32),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          textStyle: context.textTheme.titleLarge?.copyWith(fontSize: 18),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),      
        ),
      ),
      chipTheme: ChipTheme.of(context).copyWith(
        checkmarkColor: Colors.white,
        side: const BorderSide(color: channilGreen),
        labelStyle: context.textTheme.bodyLarge?.copyWith(color: const ChipLabelColor()),
        secondaryLabelStyle: const TextStyle(color: Colors.white),
      ),
      colorScheme: const ColorScheme.light(
        primary: channilGreen,
        secondary: channilGreen,
      ),
    ),
    routerConfig: router,
  );
}
