import 'package:currconv2/homescreen.dart';
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return DevicePreview(
       backgroundColor: Colors.white,
      enabled: true,
      availableLocales: const [
        Locale('en', 'US'),
      ],
      tools: const [
        DeviceSection(
          model: true,
          orientation: false,
          frameVisibility: false,
          virtualKeyboard: false,
        )
      ],
      // Set a custom list of devices to display in Device Preview
      devices: [
        Devices.ios.iPhone13ProMax,
        Devices.macOS.macBookPro,
        Devices.linux.laptop,
        Devices.android.samsungGalaxyA50,
        Devices.android.samsungGalaxyS20,
        Devices.ios.iPhoneSE,
        Devices.ios.iPhone13Mini,
        Devices.ios.iPad,
        Devices.windows.laptop,
      ],
      builder: (context) =>MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Currency Converter',
        home: const HomeScreen(),
        useInheritedMediaQuery: true, // Required for device preview
        locale: DevicePreview.locale(context), // Set locale from device preview
        builder: DevicePreview.appBuilder, // Wraps app with device preview
      ),
    );
  }
}
