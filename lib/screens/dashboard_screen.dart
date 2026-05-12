import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/ai_service.dart';
import '../services/edge_compute_service.dart';
import '../utils/app_theme.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        title: const Text('DASHBOARD', style: TextStyle(letterSpacing: 3, fontSize: 14)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: Consumer2<EdgeComputeService, AIService>(
        builder: (context, edge, ai, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // System status header
                _buildStatusHeader(edge),
                const SizedBox(height: 20),

                // Stats grid
                _buildSectionLabel('LIVE METRICS'),
                const SizedBox(height: 12),
                _buildStatsGrid(edge, ai),
                const SizedBox(height: 24),

                // Network health
                _buildSectionLabel('NETWORK HEALTH'),
                const SizedBox(height: 12),
                _buildNetworkHealth(edge),
                const SizedBox(height: 24),

                // AI Capabilities
                _buildSectionLabel('AI CAPABILITIES'),
                const SizedBox(height: 12),
                _buildCapabilities(edge),
                const SizedBox(height: 24),

                // Recent metrics
                if (ai.metricsHistory.isNotEmpty) ...[
                  _buildSectionLabel('RECENT REQUESTS'),
                  const SizedBox(height: 12),
                  _buildRecentMetrics(ai),
                ],
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatusHeader(EdgeComputeService edge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: AppGradients.primaryGlow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'EDGE NETWORK STATUS',
                  style: TextStyle(
                    color: AppTheme.bgDark,
                    fontSize: 11,
                    letterSpacing: 2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${edge.onlineNodes}/${edge.nodes.length} Nodes Online',
                  style: const TextStyle(
                    color: AppTheme.bgDark,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.bgDark.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🌐', style: TextStyle(fontSize: 24)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        color: AppTheme.textMuted,
        fontSize: 10,
        letterSpacing: 2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildStatsGrid(EdgeComputeService edge, AIService ai) {
    final stats = [
      _StatData(
        label: 'AVG LATENCY',
        value: '${edge.avgLatency.toStringAsFixed(0)}ms',
        icon: Icons.speed_rounded,
        color: AppTheme.primary,
        sublabel: 'Edge optimized',
      ),
      _StatData(
        label: 'SUCCESS RATE',
        value: '${edge.successRate.toStringAsFixed(1)}%',
        icon: Icons.check_circle_outline_rounded,
        color: AppTheme.accent,
        sublabel: 'Last 24h',
      ),
      _StatData(
        label: 'TOTAL REQUESTS',
        value: '${edge.totalRequestsToday.toStringAsFixed(0)}',
        icon: Icons.bolt_rounded,
        color: AppTheme.secondary,
        sublabel: 'Today',
      ),
      _StatData(
        label: 'CHAT MESSAGES',
        value: '${ai.messages.length}',
        icon: Icons.chat_bubble_outline_rounded,
        color: AppTheme.warning,
        sublabel: 'This session',
      ),
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.4,
      ),
      itemCount: stats.length,
      itemBuilder: (_, i) => _StatCard(stat: stats[i]),
    );
  }

  Widget _buildNetworkHealth(EdgeComputeService edge) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        children: [
          _HealthRow(
            label: 'Online Nodes',
            value: edge.onlineNodes,
            total: edge.nodes.length,
            color: AppTheme.accent,
          ),
          const SizedBox(height: 12),
          _HealthRow(
            label: 'Busy Nodes',
            value: edge.busyNodes,
            total: edge.nodes.length,
            color: AppTheme.warning,
          ),
          const SizedBox(height: 12),
          _HealthRow(
            label: 'Offline Nodes',
            value: edge.offlineNodes,
            total: edge.nodes.length,
            color: AppTheme.error,
          ),
        ],
      ),
    );
  }

  Widget _buildCapabilities(EdgeComputeService edge) {
    final caps = edge.getCapabilities();
    return Column(
      children: caps.map((cap) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Text(cap.icon, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cap.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      cap.description,
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppTheme.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
                ),
                child: Text(
                  cap.category,
                  style: const TextStyle(
                    color: AppTheme.primary,
                    fontSize: 9,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRecentMetrics(AIService ai) {
    final recent = ai.metricsHistory.reversed.take(5).toList();
    return Column(
      children: recent.map((m) {
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.bgCard,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: AppTheme.border),
          ),
          child: Row(
            children: [
              Icon(Icons.bolt_rounded, color: AppTheme.primary, size: 16),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  m.computeNode,
                  style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
                ),
              ),
              Text(
                '${m.latencyMs.toInt()}ms',
                style: TextStyle(
                  color: m.latencyMs < 2000 ? AppTheme.accent : AppTheme.warning,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${m.tokensUsed}t',
                style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _StatData {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String sublabel;

  _StatData({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.sublabel,
  });
}

class _StatCard extends StatelessWidget {
  final _StatData stat;
  const _StatCard({required this.stat});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(stat.icon, color: stat.color, size: 16),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  stat.label,
                  style: const TextStyle(
                    color: AppTheme.textMuted,
                    fontSize: 9,
                    letterSpacing: 1,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          Text(
            stat.value,
            style: TextStyle(
              color: stat.color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            stat.sublabel,
            style: const TextStyle(color: AppTheme.textMuted, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

class _HealthRow extends StatelessWidget {
  final String label;
  final int value;
  final int total;
  final Color color;

  const _HealthRow({
    required this.label,
    required this.value,
    required this.total,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0 ? value / total : 0.0;
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: const TextStyle(color: AppTheme.textSecondary, fontSize: 12),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 6,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          '$value/$total',
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
