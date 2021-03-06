import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_media_metadata/flutter_media_metadata.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicProvider extends ChangeNotifier {
  final _player = AudioPlayer();
  Directory dir = Directory('C:/Users/rafal/Desktop/car_computer_audio/');
  final List<MusicTrack> _musicList = [];
  MusicTrack? _currentTrack;
  late SharedPreferences _preferences;
  // AudioSource? _playlist;

  MusicProvider() {
    setup();
  }

  void setup() async {
    final List<FileSystemEntity> entities = await dir.list().toList();
    final Iterable<File> files = entities.whereType<File>();
    await Future.forEach<File>(files, (element) async {
      await MetadataRetriever.fromFile(element).then((value) {
        _musicList.add(MusicTrack(
            absolutePathToFile: element.path,
            metadata: value,
            audioSource: AudioSource.uri(Uri.parse(element.path))));
      });
    });
    _musicList
        .sort((a, b) => b.metadata.trackName!.compareTo(a.metadata.trackName!));
    var loadStored = 0;
    await SharedPreferences.getInstance().then((value) {
      _preferences = value;
      if (_preferences.containsKey("MusicSettings")) {
        String string = _preferences.getString("MusicSettings")!;
        Map<String, dynamic> userMap =
            jsonDecode(string) as Map<String, dynamic>;
        try {
          _currentTrack = _musicList.firstWhere(
              (element) => element.absolutePathToFile == userMap["path"]);
          loadStored = int.parse(userMap["position"]);
        } catch (e) {
          _currentTrack = _musicList[0];
        }
      } else {
        _currentTrack = _musicList[0];
      }
    });
    _player.positionStream.listen((event) {
      if (_currentTrack != null && event != Duration.zero) {
        _preferences.setString(
            "MusicSettings",
            jsonEncode({
              "path": _currentTrack!.absolutePathToFile,
              "position": event.inMilliseconds.toString()
            }));
      }
    });
    await _player.setFilePath(_currentTrack!.absolutePathToFile);
    if (loadStored != 0) {
      _player.seek(Duration(milliseconds: loadStored));
    }
    notifyListeners();
    _player.setVolume(0.05);
  }

  void playAudio() async {
    await _player.play();
  }

  void pauseAudio() async {
    await _player.pause();
  }

  void stopAudio() async {
    await _player.stop();
  }

  void previousTrack() async {
    if (!isFirstTrack) {
      var index = trackListIndex(_currentTrack!);
      selectTrack(_musicList[index - 1]);
    }
  }

  void nextTrack() async {
    if (!isLastTrack) {
      var index = trackListIndex(_currentTrack!);
      selectTrack(_musicList[index + 1]);
    }
  }

  void rewindTrack(Duration position) async {
    await _player.seek(position);
  }

  void selectTrack(MusicTrack track) async {
    if (_player.playerState.processingState == ProcessingState.loading) return;
    if (_player.playing) {
      _player.stop();
    }
    await _player.setFilePath(track.absolutePathToFile);
    if (!_player.playing) {
      Future.delayed(const Duration(milliseconds: 200)).then((value) async {
        await _player.play();
      });
    }
    await _player.play();
    _currentTrack = track;
    notifyListeners();
  }

  int trackListIndex(MusicTrack track) {
    return _musicList.indexOf(track);
  }

  AudioPlayer get getPlayer {
    return _player;
  }

  List<MusicTrack> get getTrackList {
    return _musicList;
  }

  MusicTrack? get getCurrentTrack {
    return _currentTrack;
  }

  bool get isFirstTrack {
    if (_currentTrack != null) {
      return trackListIndex(_currentTrack!) == 0;
    } else {
      return false;
    }
  }

  bool get isLastTrack {
    if (_currentTrack != null) {
      return trackListIndex(_currentTrack!) == _musicList.length - 1;
    } else {
      return false;
    }
  }

  String milisToTrackMinutes(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inMinutes)}:$twoDigitSeconds";
  }
}

class MusicTrack {
  final String absolutePathToFile;
  final Metadata metadata;
  final AudioSource audioSource;

  MusicTrack(
      {required this.absolutePathToFile,
      required this.metadata,
      required this.audioSource});
}
