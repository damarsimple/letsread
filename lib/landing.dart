import 'package:flutter/material.dart';

class Landing extends StatelessWidget {
  const Landing({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 50),
          const Text(
            'Ayo Belajar Membaca',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.black,
              decoration: TextDecoration.none,
            ),
          ),
          const SizedBox(height: 50),
          Image.asset('assets/map.jpg', fit: BoxFit.cover),
          const SizedBox(height: 50),
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
