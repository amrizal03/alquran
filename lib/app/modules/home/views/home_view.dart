import 'package:alquran/app/constant/color.dart';
import 'package:alquran/app/data/models/surah.dart';
import 'package:alquran/app/routes/app_pages.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../data/models/juz.dart' as Juz;
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.isDarkMode) {
      controller.isDark.value = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al-Quran Apps', style: TextStyle(color: appWhite),),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: ()=> {Get.toNamed(Routes.SEARCH)},
            icon: Icon(Icons.search)
          )
        ],
      ),

      body: DefaultTabController(
        length: 3,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text("Assalamualaikum", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                      colors: [appPurpleLight1, appPurpleLight2]
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () => Get.toNamed(Routes.LAST_READ),
                    borderRadius: BorderRadius.circular(20),
                    child: Stack(
                      children: [
                        Positioned(
                          bottom: -20,
                          right: 0,
                          child: Opacity(
                            opacity: 0.6,
                            child: Container(
                              width: 180,
                              height: 180,
                              child: Image.asset(
                                "assets/images/alquran.png",
                                fit: BoxFit.contain,
                              ),
                            ),
                          )
                        ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(Icons.menu_book_rounded, color: appWhite),
                                  SizedBox(width: 10),
                                  Text("Terakhir dibaca", style: TextStyle(color: appWhite)),
                                ],
                              ),
                              SizedBox(height: 30),
                              Text("Al-Fatihah", style: TextStyle(color: appWhite, fontSize: 20)),
                              Text("Juz 1 Ayat 5", style: TextStyle(color: appWhite)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              TabBar(
                tabs: [
                  Tab(
                    text: "Surah",
                  ),
                  Tab(
                    text: "Juz",
                  ),
                  Tab(
                    text: "Bookmark",
                  ),
                ]
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    FutureBuilder<List<Surah>>(
                        future: controller.getAllSurah(),
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
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                Surah surah = snapshot.data![index];
                                return ListTile(
                                  onTap: () {
                                    Get.toNamed(Routes.DETAIL_SURAH, arguments: surah);
                                  },
                                  leading: Obx(
                                    ()=>Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(controller.isDark.isTrue ? "assets/images/list_dark.png" : "assets/images/list.png")),
                                      ),
                                      child: Center(child: Text("${surah.number}")),
                                    )
                                  ),
                                  title: Text(surah.name.transliteration.id),
                                  subtitle: Text("${surah.numberOfVerses} Ayat | ${surah.revelation.id}"),
                                  trailing: Text(surah.name.short),
                                );
                              }
                          );
                        }
                    ),
                    FutureBuilder<List<Juz.Juz>>(
                      future: controller.getAllJuz(),
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
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              Juz.Juz detailJuz = snapshot.data![index];

                              String nameStart = detailJuz.juzStartInfo.split(" - ").first;
                              String nameEnd = detailJuz.juzEndInfo.split(" - ").first;

                              List<Surah> rawAllSurahInJuz = [];
                              List<Surah> allSurahInJuz = [];

                              for (Surah item in controller.allSurah) {
                                rawAllSurahInJuz.add(item);
                                if(item.name.transliteration.id == nameEnd) {
                                  break;
                                }
                              }

                              for (Surah item in rawAllSurahInJuz.reversed.toList()) {
                                allSurahInJuz.add(item);
                                if(item.name.transliteration.id == nameStart) {
                                  break;
                                }
                              }

                              return ListTile(
                                onTap: () {
                                  Get.toNamed(Routes.DETAIL_JUZ, arguments: {
                                    "juz" : detailJuz,
                                    "surah": allSurahInJuz.reversed.toList(),
                                  });
                                },
                                leading: Obx(
                                      ()=>Container(
                                    height: 35,
                                    width: 35,
                                    decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(controller.isDark.isTrue ? "assets/images/list_dark.png" : "assets/images/list.png")),
                                    ),
                                    child: Center(
                                        child: Text(
                                          "${index+1}",
                                        )
                                    ),
                                  ),
                                ),
                                title: Text('Juz ${index+1}'),
                                isThreeLine: true,
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text("Mulai dari ${detailJuz.juzStartInfo}"),
                                    Text("Sampai ${detailJuz.juzEndInfo}"),
                                  ],
                                ),
                              );
                            }
                        );
                      }
                    ),
                    Center(child: Text("page 3")),
                  ]
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.changeThemeMode(),
        child: Obx(
          ()=>Icon(
            Icons.color_lens,
            color: controller.isDark.isTrue ? appPurpleDark : appWhite,
          )
        ),
      ),


    );
  }
}
