class ChatMessage {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;
  final EdgeMetrics? metrics;
  final bool isStreaming;

  ChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
    this.metrics,
    this.isStreaming = false,
  });

  ChatMessage copyWith({
    String? content,
    EdgeMetrics? metrics,
    bool? isStreaming,
  }) {
    return ChatMessage(
      id: id,
      role: role,
      content: content ?? this.content,
      timestamp: timestamp,
      metrics: metrics ?? this.metrics,
      isStreaming: isStreaming ?? this.isStreaming,
    );
  }

  Map<String, dynamic> toJson() => {
    'role': role,
    'content': content,
  };
}

class EdgeMetrics {
  final double latencyMs;
  final int tokensUsed;
  final String computeNode;
  final double cpuUsage;
  final double memoryUsage;
  final String modelVersion;
  final DateTime processedAt;

  EdgeMetrics({
    required this.latencyMs,
    required this.tokensUsed,
    required this.computeNode,
    required this.cpuUsage,
    required this.memoryUsage,
    required this.modelVersion,
    required this.processedAt,
  });
}

class EdgeNode {
  final String id;
  final String name;
  final String region;
  final String status; // 'online', 'busy', 'offline'
  final double latency;
  final double load;
  final String location;

  EdgeNode({
    required this.id,
    required this.name,
    required this.region,
    required this.status,
    required this.latency,
    required this.load,
    required this.location,
  });
}

class AICapability {
  final String id;
  final String name;
  final String description;
  final String icon;
  final String category;
  final bool isAvailable;

  AICapability({
    required this.id,
    required this.name,
    required this.description,
    required this.icon,
    required this.category,
    this.isAvailable = true,
  });
}
