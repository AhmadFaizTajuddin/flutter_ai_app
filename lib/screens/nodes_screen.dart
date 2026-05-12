import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/ai_models.dart';
import '../services/edge_compute_service.dart';
import '../utils/app_theme.dart';

class NodesScreen extends StatelessWidget {
  const NodesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgDark,
      appBar: AppBar(
        backgroundColor: AppTheme.bgCard,
        title: const Text('EDGE NODES', style: TextStyle(letterSpacing: 3, fontSize: 14)),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: AppTheme.border),
        ),
      ),
      body: Consumer<EdgeComputeService>(
        builder: (context, edge, _) {
          return Column(
            children: [
              // Summary bar
              _buildSummaryBar(edge),

              // Node list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: edge.nodes.length,
                  itemBuilder: (_, i) => _NodeCard(node: edge.nodes[i]),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSummaryBar(EdgeComputeService edge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      decoration: const BoxDecoration(
        color: AppTheme.bgCard,
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _SummaryChip(
            count: edge.onlineNodes,
            label: 'Online',
            color: AppTheme.accent,
          ),
          _SummaryChip(
            count: edge.busyNodes,
            label: 'Busy',
            color: AppTheme.warning,
          ),
          _SummaryChip(
            count: edge.offlineNodes,
            label: 'Offline',
            color: AppTheme.error,
          ),
          _SummaryChip(
            count: edge.nodes.length,
            label: 'Total',
            color: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _SummaryChip({required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          '$count',
          style: TextStyle(
            color: color,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
        ),
      ],
    );
  }
}

class _NodeCard extends StatelessWidget {
  final EdgeNode node;

  const _NodeCard({required this.node});

  Color get _statusColor {
    switch (node.status) {
      case 'online': return AppTheme.accent;
      case 'busy': return AppTheme.warning;
      case 'offline': return AppTheme.error;
      default: return AppTheme.textMuted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isOffline = node.status == 'offline';

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isOffline ? AppTheme.border : _statusColor.withOpacity(0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              // Status dot
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _statusColor,
                  boxShadow: isOffline
                      ? null
                      : [BoxShadow(color: _statusColor.withOpacity(0.5), blurRadius: 6)],
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      node.name,
                      style: const TextStyle(
                        color: AppTheme.textPrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '${node.location} • ${node.region}',
                      style: const TextStyle(color: AppTheme.textMuted, fontSize: 11),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: _statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: _statusColor.withOpacity(0.3)),
                ),
                child: Text(
                  node.status.toUpperCase(),
                  style: TextStyle(
                    color: _statusColor,
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ],
          ),

          if (!isOffline) ...[
            const SizedBox(height: 14),
            const Divider(color: AppTheme.border, height: 1),
            const SizedBox(height: 14),

            // Metrics row
            Row(
              children: [
                Expanded(
                  child: _MetricBar(
                    label: 'LATENCY',
                    value: '${node.latency.toStringAsFixed(1)}ms',
                    progress: (node.latency / 300).clamp(0.0, 1.0),
                    color: node.latency < 50
                        ? AppTheme.accent
                        : node.latency < 150
                            ? AppTheme.warning
                            : AppTheme.error,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _MetricBar(
                    label: 'CPU LOAD',
                    value: '${(node.load * 100).toStringAsFixed(0)}%',
                    progress: node.load,
                    color: node.load < 0.6
                        ? AppTheme.accent
                        : node.load < 0.85
                            ? AppTheme.warning
                            : AppTheme.error,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            Text(
              'ID: ${node.id}',
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 10,
                fontFamily: 'monospace',
                letterSpacing: 0.5,
              ),
            ),
          ] else ...[
            const SizedBox(height: 10),
            const Text(
              'Node tidak tersedia. Maintenance dijadwalkan.',
              style: TextStyle(color: AppTheme.textMuted, fontSize: 11),
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricBar extends StatelessWidget {
  final String label;
  final String value;
  final double progress;
  final Color color;

  const _MetricBar({
    required this.label,
    required this.value,
    required this.progress,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(
                color: AppTheme.textMuted,
                fontSize: 9,
                letterSpacing: 1,
              ),
            ),
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(3),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppTheme.border,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 4,
            ),
          ),
        ),
      ],
    );
  }
}
