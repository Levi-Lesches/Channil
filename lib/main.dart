import "package:flutter/material.dart";

import "package:channil/pages.dart";

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) => MaterialApp.router(
      title: "Flutter Demo",
      theme: ThemeData(
        useMaterial3: true,
      ),
      routerConfig: router,
    );
}
