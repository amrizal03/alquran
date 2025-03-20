import 'package:flutter/material.dart';

import 'package:get/get.dart';
import '../../../constant/color.dart';
import '../../../data/models/detail_surah.dart' as detail;
import '../../../data/models/surah.dart';
import '../controllers/detail_surah_controller.dart';

class DetailSurahView extends GetView<DetailSurahController> {
  final Surah? surah = Get.arguments;
  DetailSurahView({super.key, required surah});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('SURAH ${surah?.name.transliteration.id.toUpperCase()}', style: TextStyle(color: appWhite),),
        centerTitle: true,
      ),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          GestureDetector(
            onTap: () => Get.defaultDialog(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              title: "Tafsir ${surah!.name.transliteration.id}",
              titleStyle: TextStyle(
                fontWeight: FontWeight.bold,
              ),
              content: Text(
                surah!.tafsir.id,
                textAlign: TextAlign.justify,
              ),
            ),
            child: Container(
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
                      surah!.name.transliteration.id.toUpperCase(),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: appWhite,
                      ),
                    ),
                    Text(
                      surah!.name.translation.id.toUpperCase(),
                      style: TextStyle(
                        fontSize: 16,
                        color: appWhite,
                      ),
                    ),
                    SizedBox(height: 10,),
                    Text(
                      "${surah?.numberOfVerses} Ayat | ${surah?.revelation.id}",
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
          SizedBox(height: 20,),
          FutureBuilder<detail.DetailSurah>(
            future: controller.getDetailSurah(surah!.number.toString()),
            builder: (context, snapshot) {
              if(snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if(!snapshot.hasData) {
                return Center(
                  child: Text("Tidak ada data."),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: snapshot.data?.verses.length ?? 0,
                itemBuilder: (context, index) {
                  if(snapshot.data!.verses.isEmpty) {
                    return SizedBox();
                  }
                  detail.Verse? ayat = snapshot.data?.verses[index];
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
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
                              Container(
                                height: 35,
                                width: 35,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(Get.isDarkMode ? "assets/images/list_dark.png" : "assets/images/list.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Center(child: Text("${index + 1}")),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      controller.playAudio(ayat!.audio.primary);
                                    },
                                    icon: Icon(Icons.bookmark_add_outlined)),
                                  IconButton(
                                    onPressed: () {
                                      controller.playAudio(ayat!.audio.primary);
                                    },
                                    icon: Icon(Icons.play_arrow)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text("${ayat?.text.arab}", textAlign: TextAlign.end, style: TextStyle(fontSize: 25)),
                      SizedBox(height: 10),
                      Text("${ayat?.text.transliteration.en}", textAlign: TextAlign.start, style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic)),
                      SizedBox(height: 25),
                      Text("${ayat?.translation.id}", textAlign: TextAlign.start, style: TextStyle(fontSize: 18)),
                      SizedBox(height: 50),
                    ],
                  );
                },
              );
            }
          )
        ],
      )
    );
  }
}
