import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:za_warudo/settings_provider.dart';
import 'package:za_warudo/theme_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Locale? _selectedLocale;
  ThemeMode? _selectedTheme;

  @override
  void initState() {
    super.initState();
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    _selectedLocale = settings.locale ?? const Locale('en');
    _selectedTheme = themeProvider.themeMode;
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final settings = Provider.of<SettingsProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text(loc.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(loc.language, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            DropdownButton<Locale>(
              value: _selectedLocale,
              items: [
                DropdownMenuItem(
                  value: const Locale('en'),
                  child: Text(loc.english),
                ),
                DropdownMenuItem(
                  value: const Locale('es'),
                  child: Text(loc.spanish),
                ),
              ],
              onChanged: (locale) {
                setState(() {
                  _selectedLocale = locale;
                });
              },
            ),
            const SizedBox(height: 24),
            Text(loc.theme, style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 16),
            DropdownButton<ThemeMode>(
              value: _selectedTheme,
              items: [
                DropdownMenuItem(
                  value: ThemeMode.light,
                  child: Text(loc.light),
                ),
                DropdownMenuItem(
                  value: ThemeMode.dark,
                  child: Text(loc.dark),
                ),
                DropdownMenuItem(
                  value: ThemeMode.system,
                  child: Text(loc.system),
                ),
              ],
              onChanged: (theme) {
                setState(() {
                  _selectedTheme = theme;
                });
              },
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                if (_selectedLocale != null) {
                  await settings.setLocale(_selectedLocale!);
                }
                if (_selectedTheme != null) {
                  await themeProvider.setTheme(_selectedTheme!);
                }
                if (mounted) Navigator.pop(context);
              },
              child: Text(loc.save),
            ),
          ],
        ),
      ),
    );
  }
}
