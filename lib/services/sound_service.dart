import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();

  static void init() {
    AudioLogger.logLevel = AudioLogLevel.none;
  }

  static Future<void> playClick() async {
    try {
      await _player.stop();
      await _player.play(AssetSource('sounds/button_click.mp3'));
    } catch (_) {
    }
  }

  static Future<void> playCatHappy() async {
    try {
      await _player.stop();
      await _player.setVolume(-0.1);
      await _player.play(AssetSource('sounds/cat_meow_1.mp3'));
    } catch (_) {}
  }

  static Future<void> playCatIncorrect() async {
    try {
      await _player.stop();
      await _player.setVolume(0.1);
      await _player.play(AssetSource('sounds/cat_meow_2.mp3'));
    } catch (_) {}
  }
}