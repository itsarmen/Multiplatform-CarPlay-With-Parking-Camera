import 'package:flutter/material.dart';
import 'package:yaru/yaru.dart';


import 'layout/app_shell.dart';
import 'settings/settings_store.dart';
import 'yaru_gallery/tokens.dart';

Future<void> main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = await SettingsStore.open();
  runApp(
    CarPlayApp(
      store: store,
      initialSection: args.isNotEmpty ? args.first : store.lastSection,
      initialItem: args.length > 1 ? args[1] : null,
    ),
  );
}

/// A 920 x 473 desktop music app with a Teams-inspired layout and Yaru styling.
class CarPlayApp extends StatelessWidget {
  const CarPlayApp({super.key, this.store, this.initialSection, this.initialItem});

  /// Persistent settings, or null when running without storage (e.g. tests).
  final SettingsStore? store;

  final String? initialSection;
  final String? initialItem;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CarPlay',
      theme: yaruLight.copyWith(
        textTheme: yaruLight.textTheme.apply(
          fontFamily: YaruGallery.fontFamily,
        ),
      ),
      darkTheme: yaruDark,
      home: AppShell(
        store: store,
        initialSection: initialSection ?? 'home',
        initialItem: initialItem,
      ),
    );
  }
}
