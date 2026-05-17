// ========================================================================
// sound_service.dart
// ------------------------------------------------------------------------
// handles all in-app sound effects 
// resuable methods for button clicks and character sound effects using the 
// audioplayers package 
// ========================================================================

import 'package:audioplayers/audioplayers.dart';

class SoundService {
  // shared audio player instance 
  static final AudioPlayer _player = AudioPlayer();

  // ----- initialise audio settings -----
  static void init() {
    AudioLogger.logLevel = AudioLogLevel.none;
  }

  // ----- button click sound -----
  static Future<void> playClick() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/button_click.mp3'));
    } catch (_) {
      // ignore playback errors silently 
    }
  }

  // ----- happy cat sound -----
  // positive feedback sound effect 
  static Future<void> playCatHappy() async {
    try {
      await _player.stop();
      await _player.setVolume(0.08); 
      await _player.play(AssetSource('sounds/cat_meow_1.mp3'));
    } catch (_) {
      // ignore playback errors silently 
    }
  }

  // ----- sad cat sound -----
  // incorrect feedback sound effect 
  static Future<void> playCatIncorrect() async {
    try {
      await _player.stop();
      await _player.setVolume(0.08); 
      await _player.play(AssetSource('sounds/cat_meow_2.mp3'));
    } catch (_) {
      // ignore playback errors silently 
    }
  }
}