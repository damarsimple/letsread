import 'package:flutter/material.dart';

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 30),
          Image.asset('assets/TagLine.png', fit: BoxFit.cover),
          const SizedBox(height: 30),
          const Text(
            'Aplikasi membaca “Sight Words FaPic (Fading Picture)” merupakan salah satu teknologi asistif untuk membantu anak berkebutuhan khusus (tunagrahita ringan) membaca dengan metode sight words melalui strategi fading pictorial.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const Text(
            'Penerapan metode sight words melalui strategi fading pictorial dipilih untuk digunakan dalam aplikasi karena sesuai dengan karakteristik anak tunagrahita ringan.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const Text(
            'Terdapat gambar (sebagai prompt/bantuan) dan kata yang diberikan di awal kemudian gambar yang berperan sebagai prompt akan dihilangkan di akhir namun secara perlahan.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          const Text(
            'Aplikasi membaca ini menggunakan prinsip memudar sehingga dapat melatih memori anak tunagrahita ringan.',
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
              onPressed: () => {Navigator.pushNamed(context, '/tutorial')},
              child: const Padding(
                padding: EdgeInsets.all(5),
                child: Text('LANJUTKAN'),
              ))
        ],
      ),
    );
  }
}
