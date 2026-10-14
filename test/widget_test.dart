import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:multiplatform_carplay/main.dart';

Future<void> _loadUbuntuFonts() async {
  final loader = FontLoader('Ubuntu');
  for (final file in const [
    'assets/fonts/Ubuntu-Regular.ttf',
    'assets/fonts/Ubuntu-Bold.ttf',
  ]) {
    final bytes = File(file).readAsBytesSync();
    loader.addFont(Future.value(ByteData.view(Uint8List.fromList(bytes).buffer)));
  }
  await loader.load();
}

void main() {
  setUpAll(_loadUbuntuFonts);

  Future<void> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(920, 473);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const CarPlayApp());
  }

  testWidgets('home shows dashboard without secondary sidebar',
      (WidgetTester tester) async {
    await pumpApp(tester);

    expect(find.text('CURRENT SPEED'), findsOneWidget);
    expect(find.text('Speed Limits'), findsOneWidget);
    expect(find.text('Home'), findsNothing);
    expect(find.text('Speedometer'), findsNothing);
  });

  testWidgets('camera sections render from the nav rail',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Parking'));
    await tester.pump();
    expect(find.text('Parking camera'), findsOneWidget);
    expect(find.text('Beeper sound'), findsOneWidget);
    expect(find.text('Show lines'), findsOneWidget);
    expect(find.byTooltip('Camera settings'), findsOneWidget);
    expect(find.text('Zoom'), findsNothing);

    await tester.tap(find.byTooltip('Camera settings'));
    await tester.pump();
    expect(find.text('Zoom'), findsOneWidget);
    expect(find.text('Car width (line spacing)'), findsOneWidget);
    expect(find.text('Beeper sound'), findsNothing);

    await tester.tap(find.byTooltip('Right mirror'));
    await tester.pump();
    expect(find.text('Right mirror camera'), findsOneWidget);
    expect(find.text('Beeper sound'), findsOneWidget);
    expect(find.text('Show lines'), findsOneWidget);
    expect(find.text('Zoom'), findsNothing);
  });

  testWidgets('settings exposes camera assignment and detection',
      (WidgetTester tester) async {
    await pumpApp(tester);

    await tester.tap(find.byTooltip('Settings'));
    await tester.pump();
    expect(find.text('Camera detection'), findsOneWidget);
    expect(find.text('Assignments'), findsOneWidget);
    expect(find.text('Right mirror camera'), findsOneWidget);
  });
}
