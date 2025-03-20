import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

import '../../../constant/color.dart';
import '../../../data/models/juz.dart';
import '../../../data/models/surah.dart';

class HomeController extends GetxController {
  List<Surah> allSurah = [];
  RxBool isDark = false.obs;

  void changeThemeMode() async {
    Get.isDarkMode ? Get.changeTheme(themeLight) : Get.changeTheme(themeDark);
    isDark.toggle();

    final box = GetStorage();

    if(Get.isDarkMode) {
      //dark -> light
      box.remove("themeDark");
    } else {
      //light -> dark
      box.write("themeDark", true);
    }
  }


  Future<List<Surah>> getAllSurah() async {
    Uri url = Uri.parse("https://api.quran.gading.dev/surah");
    var res = await http.get(url);

    List data = (json.decode(res.body) as Map<String, dynamic>)["data"];
    
    if(data.isEmpty) {
      return [];
    } else {
      allSurah = data.map((e) => Surah.fromJson(e)).toList();
      return allSurah;
    }
  }

  Future<List<Juz>> getAllJuz() async {
    List<Juz> allJuz = [];
    for (int i=1; i <=30; i++) {
      Uri url = Uri.parse("https://api.quran.gading.dev/juz/$i");
      var res = await http.get(url);

      Map<String, dynamic> data = (json.decode(res.body) as Map<String, dynamic>)["data"];

      try {
        Juz juz = Juz.fromJson(data);
        allJuz.add(juz);
        print("Juz Parsed Successfully: ${juz.juz}");
      } catch (e) {
        print("Error parsing JSON: $e");
        print("Juz: $i");
      }

    }
    return allJuz;
  }
}
