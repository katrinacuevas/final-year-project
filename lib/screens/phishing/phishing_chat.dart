import 'package:flutter/material.dart';
import 'phishing_chat_models.dart';

class ChatMessageWidget extends StatelessWidget {
  final ChatMessage message;
  final bool isTyping;
  
  const ChatMessageWidget({super.key, required this.message, this.isTyping = false});

  @override
  Widget build(BuildContext context) {
    final bool isYou = message.from == 'you';
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: isYou ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isYou) ...[
            const ChatAvatar(isYou: false),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding: isTyping
                ? const EdgeInsets.symmetric(horizontal: 18, vertical: 14)
                : const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
              decoration: BoxDecoration(
                color: isYou ? const Color(0xFF4A90D9) : Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(18),
                  topRight: const Radius.circular(18),
                  bottomLeft: isYou ? const Radius.circular(18) : const Radius.circular(4),
                  bottomRight: isYou ? const Radius.circular(4) : const Radius.circular(18),
                ),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 6, offset: const Offset(0, 2))],
              ),
              child: isTyping
                ? const TypingDots()
                : Text(
                    message.text,
                    style: TextStyle(
                      fontSize: 14,
                      color: isYou ? Colors.white : const Color(0xFF1A2E45),
                      height: 1.4,
                    ),
                  ),
            ),
          ),
          if (isYou) ...[
            const SizedBox(width: 8),
            const ChatAvatar(isYou: true),
          ],
        ],
      ),
    );
  }
}

class ChatAvatar extends StatelessWidget {
  final bool isYou;
  const ChatAvatar({super.key, required this.isYou});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36, height: 36,
      decoration: BoxDecoration(
        color: isYou ? const Color(0xFFDEEAF8) : Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(Icons.person, size: 22,
          color: isYou ? const Color(0xFF4A90D9) : Colors.grey.shade500),
      ),
    );
  }
}

class TypingDots extends StatefulWidget {
  const TypingDots({super.key});

  @override
  State<TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<TypingDots> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (_, __) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            final double offset = ((_controller.value * 3) - i).clamp(0.0, 1.0);
            final double size = 6 + (offset < 0.5 ? offset : 1 - offset) * 4;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2),
              child: Container(
                width: size, height: size,
                decoration: const BoxDecoration(
                  color: Color(0xFF9AABBF),
                  shape: BoxShape.circle,
                ),
              ),
            );
          }),
        );
      },
    );
  }
}