import 'package:flutter/material.dart';
import 'password_components.dart';

class BuildPasswordStep extends StatefulWidget {
  final VoidCallback onComplete;
  const BuildPasswordStep({super.key, required this.onComplete});

  @override
  State<BuildPasswordStep> createState() => _BuildPasswordStepState();
}

class _BuildPasswordStepState extends State<BuildPasswordStep> {
  final TextEditingController _controller = TextEditingController();
  bool _obscure = true;

  bool get _hasLength => _controller.text.length >= 12;
  bool get _hasUpper => _controller.text.contains(RegExp(r'[A-Z]'));
  bool get _hasLower => _controller.text.contains(RegExp(r'[a-z]'));
  bool get _hasNumber => _controller.text.contains(RegExp(r'[0-9]'));
  bool get _hasSymbol => _controller.text.contains(RegExp(r'[!@#\$%^&*(),.?":{}|<>_\-+=\[\]\\;~/`]'));

  int get _score => [_hasLength, _hasUpper, _hasLower, _hasNumber, _hasSymbol].where((b) => b).length;
  bool get _canProceed => _score >= 4;

  String get _strengthLabel {
    if (_controller.text.isEmpty) return 'Start typing...';
    if (_score <= 1) return 'Very Weak 😬';
    if (_score == 2) return 'Weak 😕';
    if (_score == 3) return 'Getting Better 🙂';
    if (_score == 4) return 'Strong 💪';
    return 'Super Strong! 🔥';
  }

  Color get _strengthColor {
    if (_controller.text.isEmpty) return Colors.grey.shade300;
    if (_score <= 1) return const Color(0xFFE74C3C);
    if (_score == 2) return const Color(0xFFE67E22);
    if (_score == 3) return const Color(0xFFF1C40F);
    if (_score == 4) return const Color(0xFF2ECC71);
    return const Color(0xFF27AE60);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            const Text('🛠️', style: TextStyle(fontSize: 28)),
            const SizedBox(width: 10),
            const Expanded(
              child: Text('Build Your Own Password!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w800, color: Color(0xFF1A2E45))),
            ),
          ]),
          const SizedBox(height: 6),
          const Text('Use everything you\'ve learned to create a strong password. It needs to pass all 4 rules!',
            style: TextStyle(fontSize: 14, color: Color(0xFF5A7A95), height: 1.4)),
          const SizedBox(height: 20),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Type your password:',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
                const SizedBox(height: 10),
                TextField(
                  controller: _controller,
                  obscureText: _obscure,
                  onChanged: (_) => setState(() {}),
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700,
                    letterSpacing: 1.5, color: Color(0xFF1A2E45)),
                  decoration: InputDecoration(
                    hintText: 'e.g. Fluffy\$Pizza!Rocket7',
                    hintStyle: TextStyle(fontSize: 14, color: Colors.grey.shade400,
                      fontWeight: FontWeight.w400, letterSpacing: 0),
                    filled: true,
                    fillColor: const Color(0xFFEFF4FB),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 2),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey.shade500),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Strength:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF7A9BB5))),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: _strengthColor),
                      child: Text(_strengthLabel),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: _controller.text.isEmpty ? 0 : _score / 5,
                    minHeight: 10,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(_strengthColor),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          _ChecklistCard(),
          const SizedBox(height: 16),

          if (!_canProceed && _controller.text.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.amber.shade50,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.amber.shade200),
              ),
              child: Row(children: [
                const Text('💡', style: TextStyle(fontSize: 20)),
                const SizedBox(width: 10),
                Expanded(child: Text(_getHint(),
                  style: const TextStyle(fontSize: 13, color: Color(0xFF7A6020), height: 1.4))),
              ]),
            ),

          if (_canProceed)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFD5F5E3),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: const Color(0xFF82E0AA)),
              ),
              child: const Row(children: [
                Text('🎉', style: TextStyle(fontSize: 20)),
                SizedBox(width: 10),
                Expanded(child: Text('Amazing! Your password passes the rules. You\'re ready to finish!',
                  style: TextStyle(fontSize: 13, color: Color(0xFF1E8449), fontWeight: FontWeight.w600, height: 1.4))),
              ]),
            ),

          const SizedBox(height: 24),
          NextButton(
            onTap: widget.onComplete,
            enabled: _canProceed,
            label: 'Finish! 🏆',
          ),
          if (!_canProceed)
            const Padding(
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Text('Complete at least 4 rules to finish',
                  style: TextStyle(fontSize: 12, color: Color(0xFF9AABBF))),
              ),
            ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _ChecklistCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 3))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rules checklist:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45))),
          const SizedBox(height: 12),
          _CheckRow(label: 'At least 12 characters long', passed: _hasLength),
          const SizedBox(height: 8),
          _CheckRow(label: 'Has UPPERCASE letters', passed: _hasUpper),
          const SizedBox(height: 8),
          _CheckRow(label: 'Has lowercase letters', passed: _hasLower),
          const SizedBox(height: 8),
          _CheckRow(label: 'Has numbers (0–9)', passed: _hasNumber),
          const SizedBox(height: 8),
          _CheckRow(label: 'Has symbols (! @ # \$ % etc.)', passed: _hasSymbol),
        ],
      ),
    );
  }

  String _getHint() {
    if (!_hasLength) return 'Your password is too short — aim for at least 12 characters. Try adding more words!';
    if (!_hasUpper) return 'Add some UPPERCASE letters — try capitalising the start of each word.';
    if (!_hasLower) return 'Add some lowercase letters too — mix them with your capitals.';
    if (!_hasNumber) return 'Throw in a number or two — like replacing "o" with "0" or adding "7" at the end.';
    if (!_hasSymbol) return 'Nearly there! Add a symbol like ! @ # or \$ to make it super strong.';
    return 'Keep going — you\'re almost there!';
  }
}

class _CheckRow extends StatelessWidget {
  final String label;
  final bool passed;
  const _CheckRow({required this.label, required this.passed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 26, height: 26,
          decoration: BoxDecoration(
            color: passed ? const Color(0xFF2ECC71) : const Color(0xFFEFF4FB),
            shape: BoxShape.circle,
            border: Border.all(
              color: passed ? const Color(0xFF2ECC71) : const Color(0xFFCDD8E3),
              width: 2,
            ),
          ),
          child: Icon(passed ? Icons.check : Icons.remove,
            size: 15, color: passed ? Colors.white : const Color(0xFFCDD8E3)),
        ),
        const SizedBox(width: 12),
        Text(label, style: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: passed ? const Color(0xFF1A2E45) : const Color(0xFF9AABBF),
          decoration: passed ? TextDecoration.none : TextDecoration.none,
        )),
      ],
    );
  }
}