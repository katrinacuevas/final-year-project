import 'dart:async';
import 'package:flutter/material.dart';
import 'package:final_year_project/services/user_service.dart';
import '../services/sound_service.dart';
import 'avatar_screen.dart';

class UsernameScreen extends StatefulWidget {
  const UsernameScreen({super.key});

  @override
  State<UsernameScreen> createState() => _UsernameScreenState();
}

class _UsernameScreenState extends State<UsernameScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _ctrl = TextEditingController();
  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;

  bool _hasText = false;
  bool _checking = false;
  bool _navigating = false;
  bool? _isAvailable;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
    _ctrl.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final text = _ctrl.text.trim();
    setState(() {
      _hasText = text.isNotEmpty;
      _isAvailable = null;
    });

    _debounce?.cancel();
    if (text.isEmpty) return;
    setState(() => _checking = true);

    _debounce = Timer(const Duration(milliseconds: 600), () async {
      if (!mounted) return;
      try {
        final taken = await UserService.instance.isUsernameTaken(text);
        if (!mounted) return;
        if (_ctrl.text.trim() != text) return;
        setState(() {
          _checking = false;
          _isAvailable = !taken;
        });
      } catch (_) {
        if (!mounted) return;
        setState(() {
          _checking = false;
          _isAvailable = null;
        });
      }
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _ctrl.removeListener(_onTextChanged);
    _ctrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (!_hasText || _checking || _navigating) return;
    if (_isAvailable == false) return;
    SoundService.playClick();

    if (_isAvailable == null) {
      setState(() => _navigating = true);
      try {
        final taken = await UserService.instance.isUsernameTaken(_ctrl.text.trim());
        if (!mounted) return;
        if (taken) {
          setState(() {
            _isAvailable = false;
            _navigating = false;
          });
          return;
        }
      } catch (e) {
        if (!mounted) return;
        setState(() => _navigating = false);
        return;
      }
    }

    setState(() => _navigating = false);
    if (!mounted) return;

    Navigator.of(context).push(PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, a, b) => AvatarScreen(username: _ctrl.text.trim()),
      transitionsBuilder: (_, anim, __, child) => SlideTransition(
        position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
            .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
        child: child,
      ),
    ));
  }

  Color get _borderColor {
    if (!_hasText) return Colors.transparent;
    if (_checking) return const Color(0xFF4A90D9);
    if (_isAvailable == true) return const Color(0xFF00C9A7);
    if (_isAvailable == false) return const Color(0xFFFF6B9D);
    return const Color(0xFF4A90D9);
  }

  Widget? get _suffixIcon {
    if (!_hasText) return null;
    if (_checking) {
      return const Padding(
        padding: EdgeInsets.all(14),
        child: SizedBox(
          width: 18, height: 18,
          child: CircularProgressIndicator(
              strokeWidth: 2.5, color: Color(0xFF4A90D9)),
        ),
      );
    }
    if (_isAvailable == true) {
      return const Icon(Icons.check_circle_rounded,
          color: Color(0xFF00C9A7), size: 24);
    }
    if (_isAvailable == false) {
      return const Icon(Icons.cancel_rounded,
          color: Color(0xFFFF6B9D), size: 24);
    }
    return null;
  }

  bool get _canProceed =>
      _hasText && !_checking && !_navigating && _isAvailable != false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideIn,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90D9).withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                          color: const Color(0xFF4A90D9).withOpacity(0.3)),
                    ),
                    child: const Text('Step 1 of 2',
                        style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF4A90D9))),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                            color: const Color(0xFF4A90D9).withOpacity(0.2),
                            blurRadius: 20,
                            offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Center(
                        child: Text('✏️', style: TextStyle(fontSize: 58))),
                  ),
                  const SizedBox(height: 24),
                  const Text("What's your name?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF1A2E45))),
                  const SizedBox(height: 10),
                  Text(
                    "Pick a cool username for your profile.\nDon't use your real name!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 15,
                        color: Colors.grey.shade600,
                        height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4))
                      ],
                    ),
                    child: TextField(
                      controller: _ctrl,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2E45)),
                      decoration: InputDecoration(
                        hintText: 'e.g. StarNinja42',
                        hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontWeight: FontWeight.w400,
                            fontSize: 16),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16, right: 8),
                          child: Text('👤', style: TextStyle(fontSize: 22)),
                        ),
                        prefixIconConstraints:
                            const BoxConstraints(minWidth: 0, minHeight: 0),
                        suffixIcon: _suffixIcon,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide(color: _borderColor, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: _hasText
                              ? BorderSide(color: _borderColor, width: 2)
                              : BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 18),
                      ),
                      onSubmitted: (_) => _next(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, anim) => SlideTransition(
                      position: Tween<Offset>(
                              begin: const Offset(0, -0.3), end: Offset.zero)
                          .animate(CurvedAnimation(
                              parent: anim, curve: Curves.easeOut)),
                      child: FadeTransition(opacity: anim, child: child),
                    ),
                    child: _buildStatusBanner(),
                  ),
                  const SizedBox(height: 36),
                  AnimatedOpacity(
                    opacity: _canProceed ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _canProceed ? _next : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A2E45),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF1A2E45),
                          disabledForegroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _navigating
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(
                                    color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Next → Pick your avatar',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    if (!_hasText || _isAvailable == null) {
      return const SizedBox.shrink(key: ValueKey('none'));
    }

    if (_isAvailable == true) {
      return Container(
        key: const ValueKey('available'),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFE6FBF7),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: const Color(0xFF00C9A7).withOpacity(0.35), width: 1.5),
          boxShadow: [
            BoxShadow(
                color: const Color(0xFF00C9A7).withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3)),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 36, height: 36,
              decoration: BoxDecoration(
                color: const Color(0xFF00C9A7).withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: const Center(
                  child: Text('✅', style: TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Username available!',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF00856E))),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      key: const ValueKey('taken'),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEBF3),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: const Color(0xFFFF6B9D).withOpacity(0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
              color: const Color(0xFFFF6B9D).withOpacity(0.12),
              blurRadius: 10,
              offset: const Offset(0, 3)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: const Color(0xFFFF6B9D).withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: const Center(
                child: Text('😬', style: TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Username already taken!',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w900,
                        color: Color.fromARGB(255, 214, 48, 48))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}