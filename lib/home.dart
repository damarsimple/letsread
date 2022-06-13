import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  final player = AudioPlayer();

  void handleSound(String e) async {
    await player
        .play(AssetSource("buku.mp3")); // will immediately start playing

    debugPrint("handleSound");
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/classrooms.jpg"), fit: BoxFit.cover),
        ),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Ayo temukkan benda - benda yang ada di kelas kemudian simpan di peti harta karun !',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black),
              ),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 3,
                children: [
                  ...[
                    {"assets": "assets/books.jpg", "name": "Buku"},
                    {"assets": "assets/books.jpg", "name": "Buku"},
                    {"assets": "assets/books.jpg", "name": "Buku"},
                    {"assets": "assets/books.jpg", "name": "Buku"},
                    {"assets": "assets/books.jpg", "name": "Buku"},
                  ].map(
                    (e) => Card(
                      child: InkWell(
                        onTap: () => handleSound(e["name"] as String),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            e["assets"] as String,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: const [
                  // Image.asset(
                  //   'assets/books.jpg',
                  //   fit: BoxFit.cover,
                  //   height: 80,
                  //   width: 80,
                  // ),
                ],
              )
            ]));
  }
}
