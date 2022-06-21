import 'package:flutter/material.dart';

class Tutorial extends StatelessWidget {
  const Tutorial({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        children: [
          const Text(
            'Petunjuk',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                color: Colors.black),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text("Klik  benda - benda yang ada di kelas"),
          const SizedBox(
            height: 30,
          ),
          Card(
            child: InkWell(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Image.asset(
                  "assets/objects/buku.jpg",
                  fit: BoxFit.cover,
                  height: 70,
                  width: 70,
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          const Text("Klik  tombol mulai untuk memulai pengenalan suara"),
          const SizedBox(
            height: 30,
          ),
          ElevatedButton.icon(
            icon: const Icon(Icons.mic),
            label: const Text("Mulai"),
            onPressed: () {},
          ),
          const SizedBox(
            height: 30,
          ),
          const Text("Klik  bermain mulai untuk memulai permainan"),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, '/home')},
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Text('BERMAIN'),
              )),
          const SizedBox(height: 20),
          const Text(
            'Biodata TIM Pengembang',
            style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: TextDecoration.none,
                color: Colors.black),
          ),
          const Text(
            '1.	Irmawanti (Mahasiswa PLB Pascasarjana UNY 2021)',
            style:
                TextStyle(decoration: TextDecoration.none, color: Colors.black),
          ),
          const Text(
            '2.	Damar Albaribin Syamsu (Mahasiswa PTI Sarjana UNY 2021)',
            style:
                TextStyle(decoration: TextDecoration.none, color: Colors.black),
          ),
        ],
      ),
    ));
  }
}
