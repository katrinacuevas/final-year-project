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
  String? _errorText;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.2), end: Offset.zero)
        .animate(CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut));
    _animCtrl.forward();
    _ctrl.addListener(() {
      setState(() {
        _hasText = _ctrl.text.trim().isNotEmpty;
        _errorText = null;
      });
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _next() async {
    if (_ctrl.text.trim().isEmpty || _checking) return;
    SoundService.playClick();
    setState(() {
      _checking = true;
      _errorText = null;
    });

    try {
      final taken = await UserService.instance.isUsernameTaken(_ctrl.text.trim());
      if (!mounted) return;

      if (taken) {
        setState(() {
          _errorText = 'That username is already taken. Try another!';
          _checking = false;
        });
        return;
      }

      setState(() => _checking = false);

      Navigator.of(context).push(PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 400),
        pageBuilder: (_, a, b) => AvatarScreen(username: _ctrl.text.trim()),
        transitionsBuilder: (_, anim, __, child) => SlideTransition(
          position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
              .animate(CurvedAnimation(parent: anim, curve: Curves.easeOut)),
          child: child,
        ),
      ));
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorText = e.toString().replaceAll('Exception: ', '');
        _checking = false;
      });
    }
  }

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
                      border: Border.all(color: const Color(0xFF4A90D9).withOpacity(0.3)),
                    ),
                    child: const Text('Step 1 of 2',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF4A90D9))),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    width: 110, height: 110,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(color: const Color(0xFF4A90D9).withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 8)),
                      ],
                    ),
                    child: const Center(child: Text('✏️', style: TextStyle(fontSize: 58))),
                  ),
                  const SizedBox(height: 24),
                  const Text("What's your name?",
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, color: Color(0xFF1A2E45))),
                  const SizedBox(height: 10),
                  Text(
                    "Pick a cool username for your profile.\nDon't use your real name!",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 15, color: Colors.grey.shade600, height: 1.5),
                  ),
                  const SizedBox(height: 32),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 12, offset: const Offset(0, 4))],
                    ),
                    child: TextField(
                      controller: _ctrl,
                      autofocus: true,
                      textCapitalization: TextCapitalization.words,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: Color(0xFF1A2E45)),
                      decoration: InputDecoration(
                        hintText: 'e.g. StarNinja42',
                        hintStyle: TextStyle(color: Colors.grey.shade400, fontWeight: FontWeight.w400, fontSize: 16),
                        prefixIcon: const Padding(
                          padding: EdgeInsets.only(left: 16, right: 8),
                          child: Text('👤', style: TextStyle(fontSize: 22)),
                        ),
                        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
                        errorText: _errorText,
                        errorStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Color(0xFF4A90D9), width: 2),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(18),
                          borderSide: const BorderSide(color: Colors.redAccent, width: 2),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
                      ),
                      onSubmitted: (_) => _next(),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.amber.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.amber.shade200),
                    ),
                    child: const Row(children: [
                      Text('💡', style: TextStyle(fontSize: 18)),
                      SizedBox(width: 10),
                      Expanded(child: Text(
                        'Keep yourself safe — use a fun nickname, not your real name!',
                        style: TextStyle(fontSize: 13, color: Color(0xFF7A6020), height: 1.4),
                      )),
                    ]),
                  ),
                  const SizedBox(height: 36),
                  AnimatedOpacity(
                    opacity: _hasText ? 1.0 : 0.4,
                    duration: const Duration(milliseconds: 200),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: (_hasText && !_checking) ? _next : null,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF1A2E45),
                          foregroundColor: Colors.white,
                          disabledBackgroundColor: const Color(0xFF1A2E45),
                          disabledForegroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          elevation: 0,
                        ),
                        child: _checking
                            ? const SizedBox(
                                height: 20, width: 20,
                                child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                              )
                            : const Text('Next → Pick your avatar',
                                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
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
}