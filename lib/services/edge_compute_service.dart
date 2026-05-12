import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';

import '../models/ai_models.dart';

class EdgeComputeService extends ChangeNotifier {
  final List<EdgeNode> _nodes = [];
  Timer? _monitorTimer;
  double _totalRequestsToday = 0;
  double _avgLatency = 0;
  double _successRate = 99.2;
  bool _isMonitoring = false;

  List<EdgeNode> get nodes => List.unmodifiable(_nodes);
  double get totalRequestsToday => _totalRequestsToday;
  double get avgLatency => _avgLatency;
  double get successRate => _successRate;
  bool get isMonitoring => _isMonitoring;

  int get onlineNodes => _nodes.where((n) => n.status == 'online').length;
  int get busyNodes => _nodes.where((n) => n.status == 'busy').length;
  int get offlineNodes => _nodes.where((n) => n.status == 'offline').length;

  EdgeComputeService() {
    _initializeNodes();
    startMonitoring();
  }

  void _initializeNodes() {
    _nodes.addAll([
      EdgeNode(
        id: 'node-sg-01',
        name: 'Singapore Prime',
        region: 'AP Southeast',
        status: 'online',
        latency: 12.4,
        load: 0.35,
        location: '🇸🇬 Singapore',
      ),
      EdgeNode(
        id: 'node-id-01',
        name: 'Jakarta Core',
        region: 'AP Southeast',
        status: 'online',
        latency: 8.1,
        load: 0.62,
        location: '🇮🇩 Indonesia',
      ),
      EdgeNode(
        id: 'node-jp-01',
        name: 'Tokyo Edge',
        region: 'AP Northeast',
        status: 'busy',
        latency: 25.3,
        load: 0.88,
        location: '🇯🇵 Japan',
      ),
      EdgeNode(
        id: 'node-us-01',
        name: 'US West Hub',
        region: 'US West',
        status: 'online',
        latency: 145.2,
        load: 0.41,
        location: '🇺🇸 United States',
      ),
      EdgeNode(
        id: 'node-eu-01',
        name: 'EU Central',
        region: 'EU Central',
        status: 'online',
        latency: 220.8,
        load: 0.29,
        location: '🇩🇪 Germany',
      ),
      EdgeNode(
        id: 'node-au-01',
        name: 'Sydney Node',
        region: 'AP Pacific',
        status: 'offline',
        latency: 0,
        load: 0,
        location: '🇦🇺 Australia',
      ),
    ]);
  }

  void startMonitoring() {
    _isMonitoring = true;
    _monitorTimer = Timer.periodic(const Duration(seconds: 3), (_) {
      _updateMetrics();
    });
    notifyListeners();
  }

  void stopMonitoring() {
    _isMonitoring = false;
    _monitorTimer?.cancel();
    notifyListeners();
  }

  void _updateMetrics() {
    final rand = Random();
    _totalRequestsToday += rand.nextDouble() * 5;
    _avgLatency = 80 + rand.nextDouble() * 40;
    _successRate = 98.5 + rand.nextDouble() * 1.5;

    // Randomly update node states
    for (int i = 0; i < _nodes.length; i++) {
      if (_nodes[i].status == 'offline') continue;

      final newLoad = (_nodes[i].load + (rand.nextDouble() - 0.5) * 0.1).clamp(0.0, 1.0);
      final newLatency = (_nodes[i].latency + (rand.nextDouble() - 0.5) * 3).clamp(1.0, 500.0);

      String newStatus = 'online';
      if (newLoad > 0.85) newStatus = 'busy';

      _nodes[i] = EdgeNode(
        id: _nodes[i].id,
        name: _nodes[i].name,
        region: _nodes[i].region,
        status: newStatus,
        latency: newLatency,
        load: newLoad,
        location: _nodes[i].location,
      );
    }

    notifyListeners();
  }

  List<AICapability> getCapabilities() {
    return [
      AICapability(
        id: 'chat',
        name: 'Conversational AI',
        description: 'Chat cerdas dengan konteks percakapan',
        icon: '💬',
        category: 'NLP',
      ),
      AICapability(
        id: 'code',
        name: 'Code Generation',
        description: 'Generate & debug kode dalam berbagai bahasa',
        icon: '⚡',
        category: 'Dev Tools',
      ),
      AICapability(
        id: 'analysis',
        name: 'Data Analysis',
        description: 'Analisis data dan ekstraksi insight',
        icon: '📊',
        category: 'Analytics',
      ),
      AICapability(
        id: 'translate',
        name: 'Multilingual NLP',
        description: 'Terjemahan dan pemrosesan bahasa alami',
        icon: '🌐',
        category: 'NLP',
      ),
      AICapability(
        id: 'summarize',
        name: 'Smart Summarization',
        description: 'Ringkasan dokumen panjang secara cepat',
        icon: '📝',
        category: 'NLP',
      ),
      AICapability(
        id: 'classify',
        name: 'Classification',
        description: 'Klasifikasi teks dan data otomatis',
        icon: '🏷️',
        category: 'ML',
      ),
    ];
  }

  @override
  void dispose() {
    _monitorTimer?.cancel();
    super.dispose();
  }
}
