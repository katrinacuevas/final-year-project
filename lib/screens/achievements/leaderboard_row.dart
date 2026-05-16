// ========================================================================
// leaderboard_row.dart 
// ------------------------------------------------------------------------
// a single row in the global leaderboard list 
// displays the users rank, avatar, username, level and xp
// ========================================================================

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'achievements_data.dart';

class LeaderboardRow extends StatelessWidget {
  final int rank;
  final LeaderboardEntry entry;
  final bool isMe; // true when this row belongs to the current user 

  const LeaderboardRow({
    super.key,
    required this.rank,
    required this.entry,
    required this.isMe,
  });

  // accent colour for the rank number/emoji - gold, silver, bronze 
  Color get _rankColor {
    switch (rank) {
      case 1: return const Color(0xFFFFC857);
      case 2: return const Color(0xFFB0BEC5);
      case 3: return const Color(0xFFFF8A65);
      default: return Colors.white24;
    }
  }

  // medal emoji for top 3, plain number string for everyone else 
  String get _rankEmoji {
    switch (rank) {
      case 1: return '🥇';
      case 2: return '🥈';
      case 3: return '🥉';
      default: return '$rank';
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarColour = Color(int.parse(entry.avatarColour));
    final isTopThree = rank <= 3;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        // current user row gets a subtle cyan tint 
        color: isMe
            ? const Color(0xFF00D1FF).withValues(alpha: 0.08)
            : const Color(0xFF161B2E),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          // current user = cyan border, top 3 = rank colour border, others = faint
          color: isMe
              ? const Color(0xFF00D1FF).withValues(alpha: 0.5)
              : isTopThree
                  ? _rankColor.withValues(alpha: 0.3)
                  : const Color(0xFF00D1FF).withValues(alpha: 0.08),
          width: isMe ? 2 : 1.5,
        ),
      ),
      child: Row(
        children: [
          // ----- rank indicator -----
          // medal emoji for top 3, plain number for the rest 
          SizedBox(
            width: 36,
            child: isTopThree
                ? Text(
                    _rankEmoji,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 22),
                  )
                : Text(
                    _rankEmoji,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.fredoka(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white24,
                    ),
                  ),
          ),
          const SizedBox(width: 10),
          // ----- avatar circle -----
          // uses the avatars accent colour for the border
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: avatarColour.withValues(alpha: 0.15),
              border: Border.all(
                color: avatarColour.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Center(
              child: Text(entry.avatarEmoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 12),
          // ----- username and level -----
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.username,
                      style: GoogleFonts.fredoka(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: isMe ? const Color(0xFF00D1FF) : Colors.white,
                      ),
                    ),
                    if (isMe) ...[
                      const SizedBox(width: 6),
                      // you badge to help the user quickly spot their own row 
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 7, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00D1FF).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: const Color(0xFF00D1FF).withValues(alpha: 0.4),
                          ),
                        ),
                        child: Text(
                          'YOU',
                          style: GoogleFonts.fredoka(
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00D1FF),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Level ${entry.level}',
                  style: GoogleFonts.fredoka(fontSize: 12, color: Colors.white38),
                ),
              ],
            ),
          ),
          // ----- xp score -----
          // top 3 use their rank accent colour, others use muted white 
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${entry.xp}',
                style: GoogleFonts.fredoka(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: isTopThree ? _rankColor : Colors.white70,
                ),
              ),
              Text(
                'XP',
                style: GoogleFonts.fredoka(
                  fontSize: 11,
                  color: isTopThree
                      ? _rankColor.withValues(alpha: 0.7)
                      : Colors.white24,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
