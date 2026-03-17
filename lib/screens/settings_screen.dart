import 'package:flutter/material.dart';
import '../services/settings_service.dart';
import '../screens/favorites_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Mirror the notifier values locally so setState triggers rebuilds
  late bool _isDark;
  late String _country;
  late String _category;
  late double _fontSize;

  static const List<Map<String, String>> _countries = [
    {'code': 'us', 'name': '🇺🇸  United States'},
    {'code': 'gb', 'name': '🇬🇧  United Kingdom'},
    {'code': 'in', 'name': '🇮🇳  India'},
    {'code': 'au', 'name': '🇦🇺  Australia'},
    {'code': 'ca', 'name': '🇨🇦  Canada'},
    {'code': 'de', 'name': '🇩🇪  Germany'},
    {'code': 'fr', 'name': '🇫🇷  France'},
    {'code': 'jp', 'name': '🇯🇵  Japan'},
    {'code': 'sg', 'name': '🇸🇬  Singapore'},
    {'code': 'za', 'name': '🇿🇦  South Africa'},
  ];

  static const List<String> _categories = [
    'general',
    'business',
    'entertainment',
    'health',
    'science',
    'sports',
    'technology',
  ];

  @override
  void initState() {
    super.initState();
    _isDark = SettingsService.isDarkMode;
    _country = SettingsService.countryNotifier.value;
    _category = SettingsService.categoryNotifier.value;
    _fontSize = SettingsService.fontSizeNotifier.value;
  }

  // ─── helpers ────────────────────────────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.2,
          color: Theme.of(context).brightness == Brightness.dark
              ? const Color(0xFFF9AA33)
              : const Color(0xFF344955),
        ),
      ),
    );
  }

  Widget _divider() => const Divider(height: 1, indent: 16, endIndent: 16);

  // ─── actions ────────────────────────────────────────────────────────────────

  Future<void> _clearSaved() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear saved articles?'),
        content: const Text(
            'All saved articles will be removed. This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      setState(() => FavoritesScreen.savedArticles.clear());
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Saved articles cleared')),
        );
      }
    }
  }

  // ─── build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isDarkCtx = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDarkCtx
        ? const Color(0xFF1E1E1E)
        : Colors.white;
    final textColor = isDarkCtx ? Colors.white : const Color(0xFF232F34);
    final subtitleColor =
        isDarkCtx ? const Color(0xFFB0BEC5) : const Color(0xFF4A6572);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          // ── Appearance ──────────────────────────────────────────────────────
          _sectionHeader('Appearance'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: cardColor,
            child: SwitchListTile(
              secondary: Icon(
                _isDark ? Icons.dark_mode : Icons.light_mode,
                color: const Color(0xFFF9AA33),
              ),
              title: Text('Dark Mode', style: TextStyle(color: textColor)),
              subtitle: Text(
                _isDark ? 'Dark theme active' : 'Light theme active',
                style: TextStyle(color: subtitleColor, fontSize: 13),
              ),
              value: _isDark,
              activeThumbColor: const Color(0xFFF9AA33),
              onChanged: (val) {
                setState(() => _isDark = val);
                SettingsService.setDarkMode(val);
              },
            ),
          ),

          // ── Content ─────────────────────────────────────────────────────────
          _sectionHeader('Content'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: cardColor,
            child: Column(
              children: [
                // Country
                ListTile(
                  leading: const Icon(Icons.public, color: Color(0xFF4A6572)),
                  title: Text('Country', style: TextStyle(color: textColor)),
                  subtitle: Text(
                    'News source country',
                    style: TextStyle(color: subtitleColor, fontSize: 13),
                  ),
                  trailing: DropdownButton<String>(
                    value: _country,
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: cardColor,
                    items: _countries
                        .map(
                          (c) => DropdownMenuItem(
                            value: c['code'],
                            child: Text(
                              c['name']!,
                              style: TextStyle(
                                  fontSize: 14, color: textColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => _country = val);
                      SettingsService.setCountry(val);
                    },
                  ),
                ),
                _divider(),
                // Default Category
                ListTile(
                  leading: const Icon(Icons.category, color: Color(0xFF4A6572)),
                  title: Text('Default Category',
                      style: TextStyle(color: textColor)),
                  subtitle: Text(
                    'Category to open on launch',
                    style: TextStyle(color: subtitleColor, fontSize: 13),
                  ),
                  trailing: DropdownButton<String>(
                    value: _category,
                    underline: const SizedBox(),
                    borderRadius: BorderRadius.circular(12),
                    dropdownColor: cardColor,
                    items: _categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c,
                            child: Text(
                              c[0].toUpperCase() + c.substring(1),
                              style: TextStyle(
                                  fontSize: 14, color: textColor),
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      if (val == null) return;
                      setState(() => _category = val);
                      SettingsService.setDefaultCategory(val);
                    },
                  ),
                ),
              ],
            ),
          ),

          // ── Reading ─────────────────────────────────────────────────────────
          _sectionHeader('Reading'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: cardColor,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.text_fields, color: Color(0xFF4A6572)),
                      const SizedBox(width: 16),
                      Text('Font Size',
                          style: TextStyle(
                              color: textColor, fontSize: 16)),
                      const Spacer(),
                      Text(
                        _fontSize == 12
                            ? 'Small'
                            : _fontSize == 14
                                ? 'Medium'
                                : 'Large',
                        style: TextStyle(
                            color: const Color(0xFFF9AA33),
                            fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _fontSizeButton('A', 12, 13),
                      _fontSizeButton('A', 14, 15),
                      _fontSizeButton('A', 16, 17),
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Preview text
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: isDarkCtx
                          ? Colors.white.withValues(alpha: 0.05)
                          : const Color(0xFF344955).withValues(alpha: 0.04),
                    ),
                    child: Text(
                      'Preview: The quick brown fox jumps over the lazy dog.',
                      style: TextStyle(
                        fontSize: _fontSize,
                        color: subtitleColor,
                        height: 1.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Data ────────────────────────────────────────────────────────────
          _sectionHeader('Data'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: cardColor,
            child: ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.redAccent),
              title: Text('Clear Saved Articles',
                  style: TextStyle(color: Colors.redAccent)),
              subtitle: Text(
                '${FavoritesScreen.savedArticles.length} article(s) saved',
                style: TextStyle(color: subtitleColor, fontSize: 13),
              ),
              onTap: _clearSaved,
            ),
          ),

          // ── About ───────────────────────────────────────────────────────────
          _sectionHeader('About'),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            color: cardColor,
            child: Column(
              children: [
                ListTile(
                  leading:
                      const Icon(Icons.info_outline, color: Color(0xFF4A6572)),
                  title: Text('App Version', style: TextStyle(color: textColor)),
                  trailing: Text(
                    '1.0.0',
                    style: TextStyle(color: subtitleColor, fontSize: 14),
                  ),
                ),
                _divider(),
                ListTile(
                  leading:
                      const Icon(Icons.api, color: Color(0xFF4A6572)),
                  title: Text('Powered by', style: TextStyle(color: textColor)),
                  trailing: Text(
                    'NewsAPI.org',
                    style: TextStyle(color: subtitleColor, fontSize: 14),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _fontSizeButton(String label, double size, double displaySize) {
    final isSelected = _fontSize == size;
    return GestureDetector(
      onTap: () {
        setState(() => _fontSize = size);
        SettingsService.setFontSize(size);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 72,
        height: 44,
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFFF9AA33)
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white.withValues(alpha: 0.07)
                  : const Color(0xFF344955).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFF9AA33)
                : Colors.transparent,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            fontSize: displaySize,
            fontWeight: FontWeight.bold,
            color: isSelected ? Colors.white : const Color(0xFF4A6572),
          ),
        ),
      ),
    );
  }
}
