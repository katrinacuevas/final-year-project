import 'package:flutter/material.dart';
import 'phishing_chat_models.dart';

class FeedbackPanel extends StatelessWidget {
  final FeedbackOption feedback;
  final VoidCallback onNext;
  final bool isLastScenario;
  
  const FeedbackPanel({
    super.key,
    required this.feedback,
    required this.onNext,
    required this.isLastScenario,
  });

  @override
  Widget build(BuildContext context) {
    final bool safe = feedback.safe;
    
    return Container(
      decoration: BoxDecoration(
        color: safe ? const Color(0xFFD5F5E3) : const Color(0xFFFFEBEB),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.08), blurRadius: 16, offset: const Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(feedback.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                feedback.title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: safe ? const Color(0xFF1E6B3A) : const Color(0xFFB03030),
                ),
              ),
            ),
          ]),
          const SizedBox(height: 14),
          ...feedback.points.map((p) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Container(
                margin: const EdgeInsets.only(top: 3),
                width: 6, height: 6,
                decoration: BoxDecoration(
                  color: safe ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(p,
                style: TextStyle(
                  fontSize: 13,
                  color: safe ? const Color(0xFF1A4A2A) : const Color(0xFF7A2020),
                  height: 1.4,
                ))),
            ]),
          )),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onNext,
              style: ElevatedButton.styleFrom(
                backgroundColor: safe ? const Color(0xFF27AE60) : const Color(0xFFE74C3C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: Text(
                isLastScenario ? '🏆 Finish Lesson' : 'Next Scenario →',
                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}