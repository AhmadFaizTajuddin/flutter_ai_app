import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../services/storage_service.dart';
import '../utils/app_theme.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _apiKeyController = TextEditingController();
  final TextEditingController _systemPromptController = TextEditingController();
  bool _obscureApiKey = true;

  @override
  void initState() {
    super.initState();
    _loadSavedValues();
  }

  void _loadSavedValues() {
    final storage = context.read<StorageService>();
    final savedKey = storage.getApiKey();
    final savedPrompt = storage.getSystemPrompt();

    if (savedKey != null && savedKey.isNotEmpty) {
      _apiKeyController.text = savedKey;
      context.read<AIService>().setApiKey(savedKey);
    }

    if (savedPrompt != null && savedPrompt.isNotEmpty) {
      _systemPromptController.text = savedPrompt;
    } else {
      _systemPromptController.text = context.read<AIService>().systemPrompt;
    }
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    _systemPromptController.dispose();
    super.dispose();
  }

  void _saveSettings() async {
    final ai = context.read<AIService>();
    final storage = context.read<StorageService>();

    ai.setApiKey(_apiKeyController.text);
    ai.setSystemPrompt(_systemPromptController.text);

    await storage.saveApiKey(_apiKeyController.text);
    await storage.saveSystemPrompt(_systemPromptController.text);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('✅ Pengaturan tersimpan!'),
          backgroundColor: AppTheme.bgSurface,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        title: const Text('SETTINGS', style: TextStyle(letterSpacing: 3, fontSize: 14)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // API Key Section
            _buildSection(
              title: 'ANTHROPIC API KEY',
              icon: Icons.key_rounded,
              iconColor: AppTheme.primary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Dapatkan API Key dari console.anthropic.com',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _apiKeyController,
                    obscureText: _obscureApiKey,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      fontFamily: 'monospace',
                    ),
                    decoration: InputDecoration(
                      hintText: 'sk-ant-api03-...',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureApiKey ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                          color: AppTheme.textMuted,
                          size: 18,
                        ),
                        onPressed: () => setState(() => _obscureApiKey = !_obscureApiKey),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Consumer<AIService>(
                    builder: (_, ai, __) => Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: ai.hasApiKey
                            ? AppTheme.accent.withOpacity(0.1)
                            : AppTheme.warning.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: ai.hasApiKey
                              ? AppTheme.accent.withOpacity(0.3)
                              : AppTheme.warning.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            ai.hasApiKey ? Icons.check_circle_outline : Icons.warning_amber_outlined,
                            color: ai.hasApiKey ? AppTheme.accent : AppTheme.warning,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            ai.hasApiKey
                                ? 'API Key aktif. AI siap digunakan.'
                                : 'Masukkan API Key untuk mengaktifkan AI.',
                            style: TextStyle(
                              color: ai.hasApiKey ? AppTheme.accent : AppTheme.warning,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // System Prompt Section
            _buildSection(
              title: 'SYSTEM PROMPT',
              icon: Icons.psychology_outlined,
              iconColor: AppTheme.secondary,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Kustomisasi perilaku AI sesuai kebutuhan',
                    style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _systemPromptController,
                    maxLines: 6,
                    style: const TextStyle(
                      color: AppTheme.textPrimary,
                      fontSize: 13,
                      height: 1.5,
                    ),
                    decoration: const InputDecoration(
                      hintText: 'Tuliskan instruksi untuk AI...',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Model Info Section
            _buildSection(
              title: 'MODEL INFORMATION',
              icon: Icons.smart_toy_outlined,
              iconColor: AppTheme.accent,
              child: Column(
                children: [
                  _InfoRow(label: 'Model', value: 'claude-sonnet-4-20250514'),
                  _InfoRow(label: 'Provider', value: 'Anthropic'),
                  _InfoRow(label: 'Max Tokens', value: '2,048 per request'),
                  _InfoRow(label: 'Mode', value: 'Edge Optimized'),
                  _InfoRow(label: 'Context Window', value: '200K tokens'),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // App Info
            _buildSection(
              title: 'APLIKASI',
              icon: Icons.info_outline_rounded,
              iconColor: AppTheme.textMuted,
              child: Column(
                children: [
                  _InfoRow(label: 'Versi', value: '1.0.0'),
                  _InfoRow(label: 'Framework', value: 'Flutter 3.x'),
                  _InfoRow(label: 'Platform', value: 'iOS / Android / Web'),
                  _InfoRow(label: 'Architecture', value: 'Edge Computing'),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Save Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _saveSettings,
                child: const Text('SIMPAN PENGATURAN'),
              ),
            ),

            const SizedBox(height: 16),

            // Links
            Center(
              child: Text(
                'Dibuat dengan Flutter & Claude AI ⚡',
                style: TextStyle(color: AppTheme.textMuted, fontSize: 12),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required IconData icon,
    required Color iconColor,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 16),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    color: iconColor,
                    fontSize: 10,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppTheme.border),
          Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;

  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 12),
          ),
          Text(
            value,
            style: const TextStyle(
              color: AppTheme.textSecondary,
              fontSize: 12,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }
}
