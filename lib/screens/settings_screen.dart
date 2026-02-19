import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/app_settings.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late TextEditingController _apiKeyController;
  bool _obscureKey = true;
  late AppSettings _draft;

  @override
  void initState() {
    super.initState();
    _draft = ref.read(settingsNotifierProvider);
    _apiKeyController = TextEditingController(text: _draft.apiKey);
  }

  @override
  void dispose() {
    _apiKeyController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final updated = _draft.copyWith(apiKey: _apiKeyController.text.trim());

    await ref.read(settingsNotifierProvider.notifier).save(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('设置已保存')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('设置'),
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('保存', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text('API 配置',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          TextField(
            controller: _apiKeyController,
            obscureText: _obscureKey,
            decoration: InputDecoration(
              labelText: '阿里云 API Key',
              hintText: 'sk-...',
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(_obscureKey ? Icons.visibility : Icons.visibility_off),
                onPressed: () => setState(() => _obscureKey = !_obscureKey),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'DashScope 端点：https://dashscope.aliyuncs.com/compatible-mode/v1',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
          ),
          const SizedBox(height: 24),
          const Text('语言设置',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13,
                  color: Colors.grey)),
          const SizedBox(height: 8),
          _LanguageDropdown(
            label: '源语言',
            value: _draft.sourceLanguage,
            items: const [
              ('ja', '日语'),
              ('en', '英语'),
              ('ko', '韩语'),
              ('zh', '中文'),
            ],
            onChanged: (v) => setState(() => _draft = _draft.copyWith(sourceLanguage: v)),
          ),
          const SizedBox(height: 12),
          _LanguageDropdown(
            label: '目标语言',
            value: _draft.targetLanguage,
            items: const [
              ('zh', '中文'),
              ('en', '英语'),
              ('ja', '日语'),
            ],
            onChanged: (v) => setState(() => _draft = _draft.copyWith(targetLanguage: v)),
          ),
        ],
      ),
    );
  }
}

class _LanguageDropdown extends StatelessWidget {
  final String label;
  final String value;
  final List<(String, String)> items;
  final void Function(String) onChanged;

  const _LanguageDropdown({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: value,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      items: items
          .map((item) => DropdownMenuItem(
                value: item.$1,
                child: Text(item.$2),
              ))
          .toList(),
      onChanged: (v) {
        if (v != null) onChanged(v);
      },
    );
  }
}
