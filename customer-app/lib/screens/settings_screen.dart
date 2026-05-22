import 'package:flutter/material.dart';
import '../core/theme.dart';
import 'package:lucide_icons/lucide_icons.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  bool _emailUpdates = true;
  bool _darkMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: TextStyle(fontWeight: FontWeight.extrabold, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: AppTheme.textMain,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader('Preferences'),
          _buildToggleItem(LucideIcons.bell, 'Push Notifications', _pushNotifications, (val) => setState(() => _pushNotifications = val)),
          _buildToggleItem(LucideIcons.mail, 'Email Updates', _emailUpdates, (val) => setState(() => _emailUpdates = val)),
          _buildToggleItem(LucideIcons.moon, 'Dark Mode Theme', _darkMode, (val) => setState(() => _darkMode = val)),
          const SizedBox(height: 16),
          _buildSectionHeader('Security & Legal'),
          _buildNavigationItem(LucideIcons.shieldAlert, 'Privacy Policy', () {}),
          _buildNavigationItem(LucideIcons.fileText, 'Terms of Service', () {}),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(fontWeight: FontWeight.extrabold, fontSize: 11, color: AppTheme.textMuted, letterSpacing: 1),
      ),
    );
  }

  Widget _buildToggleItem(IconData icon, String title, bool value, Function(bool) onChanged) {
    return SwitchListTile(
      secondary: Icon(icon, color: AppTheme.primary, size: 20),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textMain)),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primary,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildNavigationItem(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppTheme.primary, size: 20),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: AppTheme.textMain)),
      trailing: const Icon(LucideIcons.chevronRight, color: AppTheme.textMuted, size: 16),
      onTap: onTap,
    );
  }
}
