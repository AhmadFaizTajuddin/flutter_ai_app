import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/ai_models.dart';

class AIService extends ChangeNotifier {
  static const String _baseUrl = 'https://api.anthropic.com/v1';
  static const String _model = 'claude-sonnet-4-20250514';

  // 🔑 GANTI DENGAN API KEY ANDA
  // Dapatkan di: https://console.anthropic.com/
  String _apiKey = 'YOUR_ANTHROPIC_API_KEY_HERE';

  final List<ChatMessage> _messages = [];
  final List<EdgeMetrics> _metricsHistory = [];
  bool _isLoading = false;
  String? _error;
  String _systemPrompt = '''You are an intelligent AI assistant running on an edge computing node. 
You are fast, efficient, and knowledgeable. You help users with various tasks including:
- Code generation and debugging
- Data analysis and insights
- Natural language processing
- Technical problem solving
- General knowledge questions

Respond concisely and helpfully. When showing code, always use proper formatting.
You are powered by Claude AI from Anthropic, optimized for edge computing deployment.''';

  List<ChatMessage> get messages => List.unmodifiable(_messages);
  List<EdgeMetrics> get metricsHistory => List.unmodifiable(_metricsHistory);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get systemPrompt => _systemPrompt;
  bool get hasApiKey => _apiKey != 'YOUR_ANTHROPIC_API_KEY_HERE' && _apiKey.isNotEmpty;

  void setApiKey(String key) {
    _apiKey = key.trim();
    notifyListeners();
  }

  void setSystemPrompt(String prompt) {
    _systemPrompt = prompt;
    notifyListeners();
  }

  Future<void> sendMessage(String userMessage) async {
    if (userMessage.trim().isEmpty) return;

    final userMsg = ChatMessage(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      role: 'user',
      content: userMessage.trim(),
      timestamp: DateTime.now(),
    );

    _messages.add(userMsg);
    _isLoading = true;
    _error = null;
    notifyListeners();

    final startTime = DateTime.now();

    // Add placeholder assistant message for streaming effect
    final assistantMsgId = '${DateTime.now().millisecondsSinceEpoch}_assistant';
    final assistantMsg = ChatMessage(
      id: assistantMsgId,
      role: 'assistant',
      content: '',
      timestamp: DateTime.now(),
      isStreaming: true,
    );
    _messages.add(assistantMsg);
    notifyListeners();

    try {
      final response = await _callClaudeAPI();
      final endTime = DateTime.now();
      final latency = endTime.difference(startTime).inMilliseconds.toDouble();

      // Simulate typing effect
      final fullContent = response['content'];
      final tokens = response['tokens'] as int;

      await _simulateStreaming(assistantMsgId, fullContent);

      // Generate edge metrics
      final metrics = EdgeMetrics(
        latencyMs: latency,
        tokensUsed: tokens,
        computeNode: _getRandomNode(),
        cpuUsage: 20 + Random().nextDouble() * 60,
        memoryUsage: 30 + Random().nextDouble() * 40,
        modelVersion: _model,
        processedAt: DateTime.now(),
      );

      _metricsHistory.add(metrics);

      // Update message with final content and metrics
      final idx = _messages.indexWhere((m) => m.id == assistantMsgId);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(
          content: fullContent,
          metrics: metrics,
          isStreaming: false,
        );
      }
    } catch (e) {
      _error = e.toString();
      final idx = _messages.indexWhere((m) => m.id == assistantMsgId);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(
          content: '❌ Error: ${e.toString()}\n\nPastikan API key valid dan koneksi internet tersedia.',
          isStreaming: false,
        );
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> _callClaudeAPI() async {
    final messageHistory = _messages
        .where((m) => m.role == 'user' || (m.role == 'assistant' && !m.isStreaming))
        .where((m) => m.content.isNotEmpty)
        .take(_messages.length - 1) // Exclude the empty assistant placeholder
        .map((m) => m.toJson())
        .toList();

    final response = await http.post(
      Uri.parse('$_baseUrl/messages'),
      headers: {
        'Content-Type': 'application/json',
        'x-api-key': _apiKey,
        'anthropic-version': '2023-06-01',
      },
      body: jsonEncode({
        'model': _model,
        'max_tokens': 2048,
        'system': _systemPrompt,
        'messages': messageHistory,
      }),
    ).timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['content'][0]['text'] as String;
      final tokens = data['usage']['output_tokens'] as int;
      return {'content': content, 'tokens': tokens};
    } else if (response.statusCode == 401) {
      throw Exception('API Key tidak valid. Periksa konfigurasi di Settings.');
    } else if (response.statusCode == 429) {
      throw Exception('Rate limit tercapai. Coba lagi dalam beberapa detik.');
    } else {
      final data = jsonDecode(response.body);
      throw Exception(data['error']?['message'] ?? 'HTTP ${response.statusCode}');
    }
  }

  Future<void> _simulateStreaming(String msgId, String fullContent) async {
    // Simulate character-by-character streaming
    const chunkSize = 5;
    for (int i = 0; i < fullContent.length; i += chunkSize) {
      final end = (i + chunkSize).clamp(0, fullContent.length);
      final partial = fullContent.substring(0, end);
      final idx = _messages.indexWhere((m) => m.id == msgId);
      if (idx != -1) {
        _messages[idx] = _messages[idx].copyWith(content: partial);
        notifyListeners();
      }
      await Future.delayed(const Duration(milliseconds: 15));
    }
  }

  String _getRandomNode() {
    final nodes = ['edge-sg-01', 'edge-id-02', 'edge-ap-03', 'edge-us-04'];
    return nodes[Random().nextInt(nodes.length)];
  }

  void clearMessages() {
    _messages.clear();
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
