import 'package:flutter/material.dart';

class ChoicesPanel extends StatelessWidget {
  final String question;
  final List<String> choices;
  final Function(int) onChoiceMade;
  
  const ChoicesPanel({
    super.key,
    required this.question,
    required this.choices,
    required this.onChoiceMade,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [BoxShadow(color: Colors.black, blurRadius: 16, offset: Offset(0, -4))],
      ),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(children: [
            const Text('💬', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(question,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
          ]),
          const SizedBox(height: 14),
          ...choices.asMap().entries.map((e) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: GestureDetector(
              onTap: () => onChoiceMade(e.key),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF4FB),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD0DFF0), width: 1.5),
                ),
                child: Row(children: [
                  Container(
                    width: 26, height: 26,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90D9).withOpacity(0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Center(child: Text('${e.key + 1}',
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Color(0xFF4A90D9)))),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text(e.value,
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF1A2E45)))),
                ]),
              ),
            ),
          )),
        ],
      ),
    );
  }
}