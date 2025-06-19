import 'package:devfolio_genai/Providers/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;
    late SharedPreferences sharedPreferences;

    setUp(() async {
      // Mock SharedPreferences
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      themeProvider = ThemeProvider();
      // Ensure the ThemeProvider has loaded the initial theme if it's async
      await themeProvider.toggleTheme(false); // Initialize to light
      await sharedPreferences.clear(); // Clear any previous test values
    });

    test('initializes with light theme by default', () async {
      // Re-initialize to test constructor loading
      SharedPreferences.setMockInitialValues({});
      sharedPreferences = await SharedPreferences.getInstance();
      themeProvider = ThemeProvider();
      // Wait for _loadTheme to complete
      await Future.delayed(Duration.zero);
      expect(themeProvider.themeMode, ThemeMode.light);
    });

    test('toggleTheme updates themeMode and saves to SharedPreferences',
        () async {
      // Toggle to dark mode
      await themeProvider.toggleTheme(true);
      expect(themeProvider.themeMode, ThemeMode.dark);
      expect(sharedPreferences.getBool('isDarkMode'), true);

      // Toggle back to light mode
      await themeProvider.toggleTheme(false);
      expect(themeProvider.themeMode, ThemeMode.light);
      expect(sharedPreferences.getBool('isDarkMode'), false);
    });

    test('loads theme from SharedPreferences on initialization', () async {
      // Set a preference for dark mode
      await sharedPreferences.setBool('isDarkMode', true);

      // Create a new instance of ThemeProvider to trigger _loadTheme
      final newThemeProvider = ThemeProvider();
      // Wait for _loadTheme to complete
      await Future.delayed(Duration.zero);

      expect(newThemeProvider.themeMode, ThemeMode.dark);

      // Set a preference for light mode
      await sharedPreferences.setBool('isDarkMode', false);
      final anotherThemeProvider = ThemeProvider();
      await Future.delayed(Duration.zero);
      expect(anotherThemeProvider.themeMode, ThemeMode.light);
    });

    test('toggleTheme notifies listeners', () async {
      bool listenerCalled = false;
      themeProvider.addListener(() {
        listenerCalled = true;
      });

      await themeProvider.toggleTheme(true);
      expect(listenerCalled, true);
    });
  });
}
