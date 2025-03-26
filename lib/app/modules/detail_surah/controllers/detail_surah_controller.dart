import 'dart:convert';

import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/db/bookmark.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';
import 'package:sqflite/sqflite.dart';

import '../../../data/models/detail_surah.dart';

class DetailSurahController extends GetxController {
  final player = AudioPlayer();

  Verse? lastVerse;

  DatabaseManager database = DatabaseManager.instance;

  void addBookmark(bool lastRead, DetailSurah surah, Verse? ayat, int indexAyat) async {
    Database? db = await database.db;
    if (db == null) return; // Pastikan database tidak null
    bool flagExist = false;

    if(lastRead) {
      await db.delete("bookmark", where: "last_read = 1");
    } else {
      List<Map<String, Object?>> checkData = await db.query(
        "bookmark",
        where: "surah = '${surah.name.transliteration.id.replaceAll("'", "")}' and ayat = ${ayat?.number.inSurah} and juz = ${ayat?.meta.juz} and via = 'surah' and index_ayat = $indexAyat and last_read = 0"
      );

      if (checkData.length != 0) {
        flagExist = true;
      }
    }

    if (flagExist == false) {
      await db.insert(
        "bookmark",
        {
          "surah": surah.name.transliteration.id.replaceAll("'", ""),
          "ayat": ayat?.number.inSurah,
          "juz": ayat?.meta.juz,
          "via": "surah",
          "index_ayat": indexAyat,
          "last_read": lastRead == true ? 1 : 0,
        }
      );
      Get.back();
      Get.snackbar("Berhasil", "Berhasil menambahkan bookmark", colorText: appWhite);
    } else {
      Get.back();
      Get.snackbar("Terjadi Kesalahan", "Bookmark terlah tersedia", colorText: appWhite);
    }

    var data = await db.query("bookmark");
    print(data);
  }

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$id");
    var res = await http.get(url);

    Map<String, dynamic> data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }

  Future<void> stopAudio(Verse ayat) async {
    try {
      await player.stop();
      ayat.kondisiAudio = "stop";
      update();

    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak dapat stop audio",
      );
    }
  }

  Future<void> resumeAudio(Verse ayat) async {
    try {
      ayat.kondisiAudio = "playing";
      update();
      await player.play();
      ayat.kondisiAudio = "stop";
      update();

    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak dapat resume audio",
      );
    }
  }

  Future<void> pauseAudio(Verse ayat) async {
    try {
      await player.pause();
      ayat.kondisiAudio = "pause";
      update();

    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak dapat pause audio",
      );
    }
  }

  Future<void> playAudio(Verse ayat) async {
    try {
      if (lastVerse == null) {
        lastVerse = ayat;
      }
      lastVerse?.kondisiAudio = "stop";
      lastVerse = ayat;
      lastVerse?.kondisiAudio = "stop";
      update();
      await player.stop();
      await player.setUrl(ayat.audio.primary);
      ayat.kondisiAudio = "playing";
      update();
      await player.play();
      ayat.kondisiAudio = "stop";
      await player.stop();
      update();

    } on PlayerException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: e.message.toString(),
      );
    } on PlayerInterruptedException catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Connection aborted: ${e.message}",
      );
    } catch (e) {
      Get.defaultDialog(
        title: "Terjadi Kesalahan",
        middleText: "Tidak dapat memutar audio",
      );
    }

  }

  @override
  void onClose() {
    player.stop();
    player.dispose();
    super.onClose();
  }

}
