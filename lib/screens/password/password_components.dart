import 'package:flutter/material.dart';

class ProgressBar extends StatelessWidget {
  final int current;
  final int total;
  const ProgressBar({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Progress', style: TextStyle(fontSize: 12, color: Colors.grey.shade600, fontWeight: FontWeight.w600)),
            Text('$current / $total', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: LinearProgressIndicator(
            value: current / total,
            minHeight: 10,
            backgroundColor: Colors.grey.shade200,
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.green),
          ),
        ),
      ],
    );
  }
}

class NextButton extends StatelessWidget {
  final VoidCallback onTap;
  final String label;
  final bool enabled;
  const NextButton({required this.onTap, this.label = 'Next →', this.enabled = true});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF1A2E45),
          foregroundColor: Colors.white,
          disabledBackgroundColor: const Color(0xFFCDD8E3),
          disabledForegroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          elevation: 0,
        ),
        child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class InfoCard extends StatelessWidget {
  final Color color;
  final String emoji;
  final String title;
  final String body;
  const InfoCard({required this.color, required this.emoji, required this.title, required this.body});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 4),
                Text(body, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95), height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ScenarioCard extends StatelessWidget {
  final String emoji, text;
  final bool isBad;
  const ScenarioCard({required this.emoji, required this.text, required this.isBad});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isBad ? const Color(0xFFFFEBEB) : const Color(0xFFD5F5E3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isBad ? const Color(0xFFFFAAAA) : const Color(0xFF82E0AA), width: 1.2),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600,
            color: isBad ? const Color(0xFFB03030) : const Color(0xFF1E8449)))),
          Icon(isBad ? Icons.cancel : Icons.check_circle,
            color: isBad ? const Color(0xFFE74C3C) : const Color(0xFF2ECC71), size: 20),
        ],
      ),
    );
  }
}

class WeakPasswordTile extends StatelessWidget {
  final String password, reason;
  const WeakPasswordTile({required this.password, required this.reason});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: const Color(0xFFFFEBEB), borderRadius: BorderRadius.circular(8)),
            child: Text(password, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800,
              color: Color(0xFFB03030), fontFamily: 'monospace')),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(reason, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95)))),
          const Text('❌', style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

class RuleCard extends StatelessWidget {
  final String number, emoji, title, body;
  final Color color;
  const RuleCard({required this.number, required this.emoji, required this.title, required this.body, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            width: 48, height: 48,
            decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(14)),
            child: Center(child: Text(emoji, style: const TextStyle(fontSize: 24))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
                const SizedBox(height: 3),
                Text(body, style: const TextStyle(fontSize: 12, color: Color(0xFF5A7A95), height: 1.4)),
              ],
            ),
          ),
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Center(child: Text(number,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13))),
          ),
        ],
      ),
    );
  }
}

class Tag extends StatelessWidget {
  final String label;
  final Color color;
  const Tag({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)),
      child: Text(label, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: color)),
    );
  }
}

class WordBubble extends StatelessWidget {
  final String word, emoji;
  const WordBubble({required this.word, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF4A90D9).withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(height: 4),
          Text(word, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
        ],
      ),
    );
  }
}

class SummaryTile extends StatelessWidget {
  final String emoji, text;
  const SummaryTile({required this.emoji, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(children: [
        Text(emoji, style: const TextStyle(fontSize: 18)),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: Color(0xFF5A7A95)))),
        const Icon(Icons.check_circle, color: Color(0xFF2ECC71), size: 18),
      ]),
    );
  }
}