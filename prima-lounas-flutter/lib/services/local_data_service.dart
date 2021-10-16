import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:priima_lounas_flutter/model/user_saved_vote.dart';
import 'package:priima_lounas_flutter/utils/helpers.dart';

final filename = "user_saved_votes";

class UserSavedVotesService {
  Future<File> getFile() async {
    return File('${(await getApplicationDocumentsDirectory()).path}/$filename.json');
  }

  Future<bool> _saveFile(List<UserSavedVote> votes) async {
    try {
      File file = await getFile();
      await file.writeAsString(userSavedVoteToJson(votes));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<dynamic> _readFile() async {
    try {
      File file = await getFile();
      if (await file.exists() == false) {
        return <UserSavedVote>[];
      }
      String data = await file.readAsString();
      return userSavedVoteFromJson(data);
    } catch (e) {
      return null;
    }
  }

  Future<bool> addAllToFile(List<UserSavedVote> votes) async {
    var saved = await _readFile();
    if (saved is List<UserSavedVote>) {
      for (var vote in votes) {
        var obj = Helpers.findById(saved, vote.id);
        if (obj == null) {
          saved.add(vote);
        } else {
          int index = saved.indexOf(obj);
          saved[index] = vote;
        }
      }
      return await _saveFile(saved);
    }
    return false;
  }

  Future<bool> addToFile(UserSavedVote vote) async {
    var saved = await _readFile();
    if (saved is List<UserSavedVote>) {
      var obj = Helpers.findById(saved, vote.id);
      if (obj == null) {
        saved.add(vote);
      } else {
        int index = saved.indexOf(obj);
        saved[index] = vote;
      }
      return await _saveFile(saved);
    }
    return false;
  }

  Future<dynamic> readFromFile(int courseId) async {
    var saved = await _readFile();
    if (saved is List<UserSavedVote>) {
      return Helpers.findById(saved, courseId);
    } else {
      return null;
    }
  }
}
