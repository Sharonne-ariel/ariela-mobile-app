import 'package:flutter/material.dart';

import '../../app/petal_logo.dart';
import '../../app/theme.dart';
import '../../l10n/generated/app_localizations.dart';
import 'ai_repository.dart';
import 'chat_message.dart';

class AiAssistantScreen extends StatefulWidget {
  const AiAssistantScreen({super.key});

  @override
  State<AiAssistantScreen> createState() => _AiAssistantScreenState();
}

class _AiAssistantScreenState extends State<AiAssistantScreen> {
  final List<ChatMessage> _messages = [];
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isLoading = false;
  String? _currentSource;

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
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

  Future<void> _send(String text) async {
    final l10n = AppLocalizations.of(context)!;
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;

    setState(() {
      _messages.add(ChatMessage(role: ChatRole.user, content: trimmed));
      _isLoading = true;
      _inputController.clear();
      _currentSource = null;
    });
    _scrollToBottom();

    try {
      final answer = await AiRepository.instance.ask(trimmed);
      if (!mounted) return;

      setState(() {
        _messages.add(ChatMessage(
          role: ChatRole.assistant,
          content: answer.answer,
        ));
        _currentSource = answer.source.isEmpty ? null : answer.source;
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(
          role: ChatRole.assistant,
          content: l10n.aiError,
        ));
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: ArielaTheme.surfaceBg,
      appBar: AppBar(
        backgroundColor: ArielaTheme.surfaceBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded,
              color: ArielaTheme.textHeading),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            const PetalLogo(size: 28),
            const SizedBox(width: 10),
            Text(
              l10n.aiAssistantTitle,
              style: textTheme.headlineMedium?.copyWith(
                color: ArielaTheme.lavender900,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Disclaimer banner
            Container(
              width: double.infinity,
              margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: ArielaTheme.lavender50,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: ArielaTheme.lavender600),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.aiDisclaimer,
                      style: const TextStyle(
                        fontSize: 11,
                        color: ArielaTheme.textBody,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Messages list
            Expanded(
              child: _messages.isEmpty
                  ? _WelcomeView(
                      onSuggestionTap: _send,
                      l10n: l10n,
                    )
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount:
                          _messages.length + (_isLoading ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == _messages.length && _isLoading) {
                          return _ThinkingBubble(l10n: l10n);
                        }
                        final msg = _messages[index];
                        final isLastAssistant = msg.role == ChatRole.assistant &&
                            index == _messages.length - 1 &&
                            _currentSource != null;
                        return _MessageBubble(
                          message: msg,
                          source: isLastAssistant ? _currentSource : null,
                          l10n: l10n,
                        );
                      },
                    ),
            ),

            // Input bar
            Container(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              decoration: const BoxDecoration(
                color: ArielaTheme.surfaceBg,
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: ArielaTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(
                          color: const Color(0xFFEAE7E1),
                          width: 0.5,
                        ),
                      ),
                      child: TextField(
                        controller: _inputController,
                        enabled: !_isLoading,
                        onSubmitted: _send,
                        textInputAction: TextInputAction.send,
                        style: const TextStyle(
                          fontSize: 14,
                          color: ArielaTheme.textHeading,
                        ),
                        decoration: InputDecoration(
                          hintText: l10n.aiPlaceholder,
                          hintStyle: const TextStyle(
                            fontSize: 14,
                            color: ArielaTheme.textMuted,
                          ),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Material(
                    color: _isLoading
                        ? ArielaTheme.surfaceMuted
                        : ArielaTheme.lavender600,
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: _isLoading
                          ? null
                          : () => _send(_inputController.text),
                      child: Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.send_rounded,
                          size: 20,
                          color: _isLoading
                              ? ArielaTheme.textMuted
                              : Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ===========================================================================

class _WelcomeView extends StatelessWidget {
  const _WelcomeView({
    required this.onSuggestionTap,
    required this.l10n,
  });

  final ValueChanged<String> onSuggestionTap;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final suggestions = [
      l10n.aiSuggestion1,
      l10n.aiSuggestion2,
      l10n.aiSuggestion3,
    ];

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const PetalLogo(size: 64),
            const SizedBox(height: 16),
            Text(
              l10n.aiWelcome,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: ArielaTheme.textBody,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 24),
            ...suggestions.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: GestureDetector(
                    onTap: () => onSuggestionTap(s),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: ArielaTheme.surfaceCard,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: ArielaTheme.lavender200,
                          width: 0.5,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.auto_awesome_outlined,
                            size: 16,
                            color: ArielaTheme.lavender600,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 13,
                                color: ArielaTheme.textHeading,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({
    required this.message,
    required this.l10n,
    this.source,
  });

  final ChatMessage message;
  final String? source;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == ChatRole.user;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 14, vertical: 10),
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width * 0.78,
                  ),
                  decoration: BoxDecoration(
                    color: isUser
                        ? ArielaTheme.lavender600
                        : ArielaTheme.surfaceCard,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 14),
                    ),
                    border: isUser
                        ? null
                        : Border.all(
                            color: const Color(0xFFEAE7E1),
                            width: 0.5,
                          ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 14,
                      height: 1.5,
                      color: isUser
                          ? Colors.white
                          : ArielaTheme.textHeading,
                    ),
                  ),
                ),
                if (source != null) ...[
                  const SizedBox(height: 4),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      l10n.aiSource(source!),
                      style: const TextStyle(
                        fontSize: 10,
                        color: ArielaTheme.textMuted,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThinkingBubble extends StatelessWidget {
  const _ThinkingBubble({required this.l10n});
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: ArielaTheme.surfaceCard,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
                bottomRight: Radius.circular(14),
              ),
              border: Border.all(
                color: const Color(0xFFEAE7E1),
                width: 0.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                        ArielaTheme.lavender600),
                  ),
                ),
                const SizedBox(width: 10),
                Text(
                  l10n.aiThinking,
                  style: const TextStyle(
                    fontSize: 13,
                    color: ArielaTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}