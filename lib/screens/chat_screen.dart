import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/ai_models.dart';
import '../services/ai_service.dart';
import '../utils/app_theme.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final FocusNode _focusNode = FocusNode();

  final List<String> _quickPrompts = [
    '⚡ Buat fungsi Python sorting',
    '🌐 Jelaskan edge computing',
    '📊 Analisis data JSON ini',
    '🔧 Debug kode Flutter',
    '🤖 Apa itu transformer AI?',
    '💡 Tips optimasi performa',
  ];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(AIService service, {String? text}) {
    final message = text ?? _inputController.text.trim();
    if (message.isEmpty) return;

    if (!service.hasApiKey) {
      _showApiKeyDialog();
      return;
    }

    service.sendMessage(message);
    _inputController.clear();
    _scrollToBottom();
  }

  void _showApiKeyDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Text(
          '⚠️ API Key Diperlukan',
          style: TextStyle(color: AppTheme.textPrimary, fontSize: 16),
        ),
        content: const Text(
          'Pergi ke tab Settings dan masukkan Anthropic API Key Anda untuk mulai menggunakan AI.\n\nDapatkan API Key di: console.anthropic.com',
          style: TextStyle(color: AppTheme.textSecondary, fontSize: 13, height: 1.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK', style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AIService>(
      builder: (context, aiService, _) {
        // Auto scroll when new message arrives
        if (aiService.messages.isNotEmpty) {
          _scrollToBottom();
        }

        return Scaffold(
          backgroundColor: AppTheme.bgDark,
          appBar: _buildAppBar(aiService),
          body: Column(
            children: [
              if (!aiService.hasApiKey) _buildApiKeyBanner(),
              Expanded(
                child: aiService.messages.isEmpty
                    ? _buildEmptyState()
                    : _buildMessageList(aiService),
              ),
              _buildInputArea(aiService),
            ],
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(AIService service) {
    return AppBar(
      backgroundColor: AppTheme.bgCard,
      title: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: service.hasApiKey ? AppTheme.accent : AppTheme.textMuted,
              boxShadow: service.hasApiKey
                  ? [BoxShadow(color: AppTheme.accent.withOpacity(0.5), blurRadius: 6)]
                  : null,
            ),
          ),
          const SizedBox(width: 10),
          const Text('AI CHAT', style: TextStyle(letterSpacing: 2, fontSize: 14)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppTheme.primary.withOpacity(0.15),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: AppTheme.primary.withOpacity(0.3)),
            ),
            child: const Text(
              'claude-sonnet-4',
              style: TextStyle(color: AppTheme.primary, fontSize: 9, letterSpacing: 0.5),
            ),
          ),
        ],
      ),
      actions: [
        if (service.messages.isNotEmpty)
          IconButton(
            icon: const Icon(Icons.delete_outline_rounded, size: 20),
            onPressed: () => _showClearDialog(service),
            tooltip: 'Clear chat',
          ),
        const SizedBox(width: 8),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(height: 1, color: AppTheme.border),
      ),
    );
  }

  Widget _buildApiKeyBanner() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: AppTheme.warning.withOpacity(0.1),
      child: Row(
        children: [
          const Icon(Icons.key_rounded, color: AppTheme.warning, size: 16),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              'API Key belum dikonfigurasi. Pergi ke Settings.',
              style: TextStyle(color: AppTheme.warning, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 40),
          ShaderMask(
            shaderCallback: (bounds) => AppGradients.primaryGlow.createShader(bounds),
            child: const Text('⚡', style: TextStyle(fontSize: 64)),
          ),
          const SizedBox(height: 20),
          const Text(
            'AI Edge Computing',
            style: TextStyle(
              color: AppTheme.textPrimary,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Powered by Claude AI • Optimized for Edge',
            style: TextStyle(color: AppTheme.textMuted, fontSize: 12, letterSpacing: 0.5),
          ),
          const SizedBox(height: 40),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'QUICK START',
              style: TextStyle(
                color: AppTheme.textMuted,
                fontSize: 10,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _quickPrompts.map((prompt) {
              return GestureDetector(
                onTap: () {
                  final service = context.read<AIService>();
                  _sendMessage(service, text: prompt.substring(2));
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppTheme.bgSurface,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppTheme.border),
                  ),
                  child: Text(
                    prompt,
                    style: const TextStyle(
                      color: AppTheme.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(AIService service) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(16),
      itemCount: service.messages.length,
      itemBuilder: (context, index) {
        final msg = service.messages[index];
        return _MessageBubble(message: msg);
      },
    );
  }

  Widget _buildInputArea(AIService service) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.bgCard,
        border: const Border(top: BorderSide(color: AppTheme.border)),
      ),
      padding: const EdgeInsets.all(12),
      child: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Container(
                constraints: const BoxConstraints(maxHeight: 120),
                decoration: BoxDecoration(
                  color: AppTheme.bgSurface,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppTheme.border),
                ),
                child: TextField(
                  controller: _inputController,
                  focusNode: _focusNode,
                  maxLines: null,
                  style: const TextStyle(color: AppTheme.textPrimary, fontSize: 14),
                  decoration: const InputDecoration(
                    hintText: 'Tanya sesuatu...',
                    hintStyle: TextStyle(color: AppTheme.textMuted),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onSubmitted: (_) => _sendMessage(service),
                ),
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: service.isLoading ? null : () => _sendMessage(service),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: service.isLoading ? null : AppGradients.primaryGlow,
                  color: service.isLoading ? AppTheme.bgSurface : null,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: service.isLoading
                      ? SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation(AppTheme.primary),
                          ),
                        )
                      : const Icon(Icons.send_rounded, color: AppTheme.bgDark, size: 18),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showClearDialog(AIService service) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppTheme.bgSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: AppTheme.border),
        ),
        title: const Text('Hapus Chat?', style: TextStyle(color: AppTheme.textPrimary)),
        content: const Text(
          'Semua pesan akan dihapus.',
          style: TextStyle(color: AppTheme.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal', style: TextStyle(color: AppTheme.textMuted)),
          ),
          TextButton(
            onPressed: () {
              service.clearMessages();
              Navigator.pop(context);
            },
            child: const Text('Hapus', style: TextStyle(color: AppTheme.error)),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;

  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (!isUser) ...[
                Container(
                  width: 28,
                  height: 28,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [AppTheme.primary, AppTheme.secondary],
                    ),
                  ),
                  child: const Center(child: Text('⚡', style: TextStyle(fontSize: 14))),
                ),
                const SizedBox(width: 8),
              ],
              Flexible(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: isUser ? AppTheme.primary.withOpacity(0.15) : AppTheme.bgSurface,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft: Radius.circular(isUser ? 16 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 16),
                    ),
                    border: Border.all(
                      color: isUser
                          ? AppTheme.primary.withOpacity(0.3)
                          : AppTheme.border,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (message.content.isEmpty && message.isStreaming)
                        _buildTypingIndicator()
                      else
                        SelectableText(
                          message.content,
                          style: const TextStyle(
                            color: AppTheme.textPrimary,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      if (message.isStreaming && message.content.isNotEmpty)
                        const Text('▊', style: TextStyle(color: AppTheme.primary)),
                    ],
                  ),
                ),
              ),
              if (isUser) const SizedBox(width: 8),
            ],
          ),

          // Metrics row for assistant messages
          if (!isUser && message.metrics != null) ...[
            const SizedBox(height: 6),
            Padding(
              padding: const EdgeInsets.only(left: 36),
              child: Row(
                children: [
                  _MetricChip(
                    icon: Icons.timer_outlined,
                    label: '${message.metrics!.latencyMs.toInt()}ms',
                    color: message.metrics!.latencyMs < 2000 ? AppTheme.accent : AppTheme.warning,
                  ),
                  const SizedBox(width: 6),
                  _MetricChip(
                    icon: Icons.token_outlined,
                    label: '${message.metrics!.tokensUsed} tokens',
                    color: AppTheme.textMuted,
                  ),
                  const SizedBox(width: 6),
                  _MetricChip(
                    icon: Icons.hub_outlined,
                    label: message.metrics!.computeNode,
                    color: AppTheme.secondary,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTypingIndicator() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(3, (i) {
        return Container(
          width: 6,
          height: 6,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppTheme.primary,
          ),
        );
      }),
    );
  }
}

class _MetricChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _MetricChip({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 10, color: color),
          const SizedBox(width: 3),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 10, letterSpacing: 0.3),
          ),
        ],
      ),
    );
  }
}
