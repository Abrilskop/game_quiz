// lib/services/audio_service.dart
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioPlayer _sfxPlayer = AudioPlayer();
  static final AudioPlayer _musicPlayer = AudioPlayer();

  // Configurar el modo de liberación para que los recursos se liberen cuando no se usen (opcional pero bueno)
  // _sfxPlayer.setReleaseMode(ReleaseMode.release);
  // _musicPlayer.setReleaseMode(ReleaseMode.release);


  static Future<void> playCorrectSound() async {
    // Podrías tener una configuración para habilitar/deshabilitar sonidos
    // if (!soundIsEnabled) return;
    try {
      // Usamos AudioCache para reproducir desde assets.
      // La primera vez podría tener un pequeño delay mientras cachea.
      // Source.asset ya no es el método recomendado, usar AssetSource.
      await _sfxPlayer.play(AssetSource('audio/correct_uwu.mp3'));
    } catch (e) {
      print("Error al reproducir sonido correcto: $e");
    }
  }

  static Future<void> playIncorrectSound() async {
    // if (!soundIsEnabled) return;
    try {
      await _sfxPlayer.play(AssetSource('audio/incorrect_uwu.mp3'));
    } catch (e) {
      print("Error al reproducir sonido incorrecto: $e");
    }
  }

  static Future<void> playBackgroundMusic() async {
    // if (!musicIsEnabled) return;
    try {
      // Configurar para bucle
      await _musicPlayer.setReleaseMode(ReleaseMode.loop); // Asegura que se repita
      await _musicPlayer.play(AssetSource('audio/background_music.mp3'));
      // Ajustar volumen si es necesario
      // await _musicPlayer.setVolume(0.5);
    } catch (e) {
      print("Error al reproducir música de fondo: $e");
    }
  }

  static Future<void> stopBackgroundMusic() async {
    try {
      await _musicPlayer.stop();
    } catch (e) {
      print("Error al detener música de fondo: $e");
    }
  }

  // Podrías añadir métodos para pausar, reanudar, controlar volumen, etc.

  // Es buena idea liberar los reproductores cuando la app se cierra o ya no se necesitan,
  // aunque el sistema operativo suele manejarlos.
  // Para un juego, podrías llamarlo en el dispose del widget principal de tu app.
  static void disposePlayers() {
    _sfxPlayer.dispose();
    _musicPlayer.dispose();
  }
}