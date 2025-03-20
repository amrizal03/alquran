import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:just_audio/just_audio.dart';

import '../../../data/models/detail_surah.dart';

class DetailSurahController extends GetxController {
  final player = AudioPlayer();

  Future<DetailSurah> getDetailSurah(String id) async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah/$id");
    var res = await http.get(url);

    Map<String, dynamic> data = (json.decode(res.body) as Map<String, dynamic>)["data"];

    return DetailSurah.fromJson(data);
  }

  Future<void> playAudio(String url) async {
    try {
      await player.setUrl('https://cdn.alquran.cloud/media/audio/ayah/ar.alafasy/1');
      await player.setLoopMode(LoopMode.one); // untuk looping
      player.play();
    } catch (e) {
      print("Error playing audio: $e");
    }
    try {
      print("url= ${url}");
      await player.setUrl(url);
      await player.play();

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
