import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../constant/color.dart';
import '../../../data/models/juz.dart' as juz;
import '../../../data/models/surah.dart';
import '../controllers/detail_juz_controller.dart';

class DetailJuzView extends GetView<DetailJuzController> {
  final juz.Juz? detailJuz = Get.arguments["juz"];
  final List<Surah> allSurahInThisJuz = Get.arguments["surah"];
  DetailJuzView({super.key, required detailJuz});
  @override
  Widget build(BuildContext context) {
    for (var element in allSurahInThisJuz) {
      print(element.name.transliteration.id);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('JUZ ${detailJuz?.juz}', style: TextStyle(color: appWhite),),
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(20),
        itemCount: detailJuz!.verses.length,
        itemBuilder: (context, index) {
          if (detailJuz?.verses == null || detailJuz!.verses.isEmpty) {
            return Center(
              child: Text("Tidak ada data"),
            );
          }
          juz.Verse? ayat = detailJuz?.verses[index];
          if(index != 0) {
            if(ayat?.number.inSurah == 1) {
              controller.index++;
            }
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              if (ayat?.number.inSurah == 1)
                GestureDetector(
                  onTap: () => Get.defaultDialog(
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 10,
                    ),
                    title: allSurahInThisJuz[controller.index].name.transliteration.id.toUpperCase(),
                    titleStyle: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                    content: Text(
                      allSurahInThisJuz[controller.index].tafsir.id,
                      textAlign: TextAlign.justify,
                    ),
                  ),
                  child: Container(
                    width: Get.width,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                          colors: [appPurpleLight1, appPurpleLight2]
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Text(
                            allSurahInThisJuz[controller.index].name.transliteration.id.toUpperCase(),
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: appWhite,
                            ),
                          ),
                          Text(
                            allSurahInThisJuz[controller.index].name.translation.id.toUpperCase(),
                            style: TextStyle(
                              fontSize: 16,
                              color: appWhite,
                            ),
                          ),
                          SizedBox(height: 10,),
                          Text(
                            "${allSurahInThisJuz[controller.index].numberOfVerses} Ayat | ${allSurahInThisJuz[controller.index].revelation.id}",
                            style: TextStyle(
                              fontSize: 16,
                              color: appWhite,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(1),
                    color: appPurpleLight2.withOpacity(0.3),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 5,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              height: 35,
                              width: 35,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage(Get.isDarkMode ? "assets/images/list_dark.png" : "assets/images/list.png"),
                                  fit: BoxFit.contain,
                                ),
                              ),
                              child: Center(child: Text("${ayat?.number.inSurah}")),
                            ),
                            Text(allSurahInThisJuz[controller.index].name.transliteration.id,
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 16,
                              )
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            IconButton(onPressed: () {}, icon: Icon(Icons.bookmark_add_outlined)),
                            IconButton(onPressed: () {}, icon: Icon(Icons.play_arrow)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("${ayat?.text.arab}", textAlign: TextAlign.end, style: TextStyle(fontSize: 25)),
                ),
                SizedBox(height: 10),
                Text("${ayat?.text.transliteration.en}", textAlign: TextAlign.start, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                SizedBox(height: 25),
                Text("${ayat?.translation.id}", textAlign: TextAlign.start, style: TextStyle(fontSize: 18)),
                SizedBox(height: 50),
            ],
          );
        }
      ),
    );
  }
}
