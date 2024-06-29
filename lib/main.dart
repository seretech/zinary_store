import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zinary/classes/app_color.dart';
import 'package:zinary/screens/home.dart';

import 'classes/custom_material_color.dart';

main() async {
  await GetStorage.init();

  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zinary',
      theme: ThemeData(
          splashFactory: NoSplash.splashFactory,
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          cardColor: Colors.white,
          dialogBackgroundColor: Colors.white,
          cardTheme: const CardTheme(
            color: Colors.white,
            surfaceTintColor: Colors.white,
          ),
          dialogTheme: const DialogTheme(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white
          ),
          datePickerTheme: const DatePickerThemeData(
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white
          ),
          textSelectionTheme: const TextSelectionThemeData(
            selectionColor: Colors.black,
            selectionHandleColor: Colors.black,
          ),
          primarySwatch: customMaterialColor(AppColor.colorApp),
      ),
      home: const HomeMain(),
    );
  }
}
