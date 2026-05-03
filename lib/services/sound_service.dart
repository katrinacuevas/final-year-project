import 'package:audioplayers/audioplayers.dart';

class SoundService {
  static final AudioPlayer _player = AudioPlayer();
  
  static Future<void> playClick() async {
    await _player.stop();
    await _player.play(AssetSource('sounds/button_click.mp3'));
  }
}