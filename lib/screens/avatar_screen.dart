import 'package:final_year_project/services/user_service.dart';
import 'package:flutter/material.dart';
import 'welcome_screen.dart';

class AvatarScreen extends StatefulWidget {
  final String username;
  const AvatarScreen({super.key, required this.username});

  @override
  State<AvatarScreen> createState() => _AvatarScreenState();
}

class _AvatarScreenState extends State<AvatarScreen>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  bool _saving = false;  
  late AnimationController _animCtrl;
  late Animation<double> _fadeIn;

  final List<Map<String, dynamic>> _avatars = [
    {'emoji': '👦', 'color': const Color(0xFFBBDEFB), 'name': 'Boy'},
    {'emoji': '👧', 'color': const Color(0xFFF8BBD9), 'name': 'Girl'},
    {'emoji': '🦸', 'color': const Color(0xFFE8D5FB), 'name': 'Hero'},
    {'emoji': '🧙', 'color': const Color(0xFFFFCDD2), 'name': 'Wizard'},
    {'emoji': '🧑‍🚀', 'color': const Color(0xFFFFE0B2), 'name': 'Astronaut'},
    {'emoji': '🦊', 'color': const Color(0xFFFFCCBC), 'name': 'Fox'},
    {'emoji': '🐱', 'color': const Color(0xFFFFF9C4), 'name': 'Cat'},
    {'emoji': '🐸', 'color': const Color(0xFFC8E6C9), 'name': 'Frog'},
  ];

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fadeIn = CurvedAnimation(parent: _animCtrl, curve: Curves.easeIn);
    _animCtrl.forward();
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    if (_saving) return;
    setState(() => _saving = true);

    try {
      final av = _avatars[_selectedIndex];

      final profile = UserProfile(
        uid: UserService.instance.uid!,
        username: widget.username,
        avatarIndex: _selectedIndex,
        avatarEmoji: av['emoji'] as String,
        avatarName: av['name'] as String,
        avatarColour: '0x${((av['color'] as Color).value.toRadixString(16)).padLeft(8, '0')}',
      );

      // This will throw the exception from UserService if the name is taken
      await UserService.instance.saveProfile(profile);

      if (!mounted) return;
      
      // If we got here, it means the name is NOT taken
      Navigator.of(context).pushAndRemoveUntil(
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 600),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const WelcomeFlash(),
          transitionsBuilder: (context, anim, secondaryAnim, child) =>
              FadeTransition(opacity: anim, child: child),
        ),
        (route) => false,
      );
    } catch (e) {
      setState(() => _saving = false);
      if (!mounted) return;
      
      // Clean up the error message for the user
      String errorMessage = e.toString().replaceAll('Exception: ', '');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = _avatars[_selectedIndex];

    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeIn,
          child: Column(
            children: [
              Container(
                color: Colors.white,
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    Row(children: [
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: 38, height: 38,
                          decoration: BoxDecoration(
                              color: const Color(0xFFEFF4FB),
                              borderRadius: BorderRadius.circular(12)),
                          child: const Icon(Icons.arrow_back,
                              color: Color(0xFF1A2E45), size: 20),
                        ),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4A90D9).withOpacity(0.12),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color(0xFF4A90D9).withOpacity(0.3)),
                        ),
                        child: const Text('Step 2 of 2',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF4A90D9))),
                      ),
                    ]),
                    const SizedBox(height: 20),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                      width: 100, height: 100,
                      decoration: BoxDecoration(
                        color: selected['color'] as Color,
                        borderRadius: BorderRadius.circular(28),
                        border:
                            Border.all(color: const Color(0xFF4A90D9), width: 3),
                        boxShadow: [
                          BoxShadow(
                            color: (selected['color'] as Color).withOpacity(0.5),
                            blurRadius: 20,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                          child: Text(selected['emoji'] as String,
                              style: const TextStyle(fontSize: 54))),
                    ),
                    const SizedBox(height: 14),
                    Text(widget.username,
                        style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF1A2E45))),
                    const SizedBox(height: 4),
                    Text(selected['name'] as String,
                        style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xFF7A9BB5),
                            fontWeight: FontWeight.w600)),
                    const SizedBox(height: 4),
                    const Text("Choose your avatar",
                        style:
                            TextStyle(fontSize: 15, color: Color(0xFF5A7A95))),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.85,
                    ),
                    itemCount: _avatars.length,
                    itemBuilder: (_, i) {
                      final av = _avatars[i];
                      final bool isSelected = i == _selectedIndex;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedIndex = i),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? (av['color'] as Color)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(
                              color: isSelected
                                  ? const Color(0xFF4A90D9)
                                  : const Color(0xFFDDE8F2),
                              width: isSelected ? 2.5 : 1.5,
                            ),
                            boxShadow: isSelected
                                ? [
                                    BoxShadow(
                                        color: const Color(0xFF4A90D9)
                                            .withOpacity(0.25),
                                        blurRadius: 12,
                                        offset: const Offset(0, 4))
                                  ]
                                : [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.04),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2))
                                  ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(av['emoji'] as String,
                                  style: const TextStyle(fontSize: 32)),
                              const SizedBox(height: 4),
                              Text(av['name'] as String,
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? const Color(0xFF1A2E45)
                                        : const Color(0xFF9AABBF),
                                  )),
                              if (isSelected)
                                const Padding(
                                  padding: EdgeInsets.only(top: 3),
                                  child: Icon(Icons.check_circle,
                                      color: Color(0xFF4A90D9), size: 14),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saving ? null : _finish,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1A2E45),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      elevation: 0,
                    ),
                    child: _saving
                        ? const SizedBox(
                            height: 20, width: 20,
                            child: CircularProgressIndicator(
                                color: Colors.white, strokeWidth: 2),
                          )
                        : const Text("Let's Go! 🚀",
                            style: TextStyle(
                                fontSize: 17, fontWeight: FontWeight.w800)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}