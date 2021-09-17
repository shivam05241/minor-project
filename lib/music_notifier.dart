import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:music_recommender/musics.dart';

class musicNotifier with ChangeNotifier {
  List<MusicData> musicDataList = [];
  MusicData _currentMusic;

  UnmodifiableListView<MusicData> get musicList =>
      UnmodifiableListView(musicDataList);

  MusicData get currentMusic => _currentMusic;

  set musicList(List<MusicData> musicDataList) {
    this.musicDataList = musicDataList;
    notifyListeners();
  }

  set currentMusic(MusicData musicData) {
    _currentMusic = musicData;
    notifyListeners();
  }
}
