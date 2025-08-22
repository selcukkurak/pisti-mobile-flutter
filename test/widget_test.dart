import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pisti_mobile_flutter/main.dart';

void main() {
  testWidgets('App starts and shows main menu', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(PistiApp());

    // Verify that the main menu appears
    expect(find.text('Pişti'), findsOneWidget);
    expect(find.text('Geleneksel Türk Kart Oyunu'), findsOneWidget);
    expect(find.text('Tek Oyuncu'), findsOneWidget);
    expect(find.text('Çok Oyunculu'), findsOneWidget);
    expect(find.text('İstatistikler'), findsOneWidget);
    expect(find.text('Ayarlar'), findsOneWidget);
  });

  testWidgets('Can navigate to single player game', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(PistiApp());

    // Tap the single player button
    await tester.tap(find.text('Tek Oyuncu'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the game page
    // Note: This might need adjustment based on the actual game page content
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('Can navigate to settings', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(PistiApp());

    // Tap the settings button
    await tester.tap(find.text('Ayarlar'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the settings page
    expect(find.text('Ayarlar'), findsAtLeastNWidgets(1));
    expect(find.text('Görünüm'), findsOneWidget);
    expect(find.text('Karanlık Tema'), findsOneWidget);
  });

  testWidgets('Can navigate to statistics', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(PistiApp());

    // Tap the statistics button
    await tester.tap(find.text('İstatistikler'));
    await tester.pumpAndSettle();

    // Verify that we navigated to the statistics page
    expect(find.text('İstatistikler'), findsAtLeastNWidgets(1));
    expect(find.text('Genel İstatistikler'), findsOneWidget);
  });
}