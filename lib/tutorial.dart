import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Petunjuk',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    decoration: TextDecoration.none,
                    color: Colors.black),
              ),
              ...[
                {
                  "name": "Tombol Profile",
                  "description": "Berisi biodata",
                  "icon": Icons.people
                },
                {
                  "name": "Tombol Home",
                  "description": "Menu Utama",
                  "icon": Icons.home
                },
                {
                  "name": "Tombol Mulai",
                  "description": "Mulai membaca",
                  "icon": Icons.play_arrow
                },
                {
                  "name": "Tombol Petunjuk",
                  "description": "Berisi biodata",
                  "icon": Icons.help
                },
                {
                  "name": "Tombol Bantuan",
                  "description": "Berisi biodata",
                  "icon": Icons.help
                },
                {
                  "name": "Tombol Quiz",
                  "description": "Berisi biodata",
                  "icon": Icons.quiz
                },
                {
                  "name": "Tombol Tutup",
                  "description": "Berisi biodata",
                  "icon": Icons.close
                },
                {
                  "name": "Tombol Pengaturan",
                  "description": "Berisi biodata",
                  "icon": Icons.settings
                },
                {
                  "name": "Tombol Kembali",
                  "description": "Berisi biodata",
                  "icon": Icons.close
                }
              ].map((e) => Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              ElevatedButton(
                                  onPressed: () {},
                                  child: Icon(e["icon"] as IconData)),
                              const SizedBox(width: 20),
                              Text(
                                e["name"] as String,
                                style: const TextStyle(
                                    fontSize: 24,
                                    decoration: TextDecoration.none,
                                    color: Colors.black),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            e["description"] as String,
                            style: const TextStyle(
                                fontSize: 20,
                                decoration: TextDecoration.none,
                                color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  )),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () => {Navigator.pushNamed(context, '/home')},
                  child: const Padding(
                    padding: EdgeInsets.all(5),
                    child: Text('LANJUTKAN'),
                  )),
              const SizedBox(height: 20),
            ],
          ),
        ));
  }
}
