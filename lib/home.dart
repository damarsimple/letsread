import 'dart:async';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class GameObject {
  String name;
  String image;

  GameObject({required this.name, required this.image});
}

class GameSession {
  List<GameObject> objects;

  String name;

  String bg;

  GameSession({required this.name, required this.objects, required this.bg});
}

class GameScore {
  int sessionId;

  GameObject object;

  bool correct;

  String answer;

  GameScore(
      {required this.object,
      required this.correct,
      required this.answer,
      required this.sessionId});
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

enum TtsState { playing, stopped, paused, continued }

class _HomeState extends State<Home> {
  bool showHartaKarun = false;

  final bgPlayer = AudioPlayer(playerId: "bgPlayer");
  final player = AudioPlayer(playerId: "effectPlayer");
  final effectPlayer = AudioPlayer(playerId: "effectPlayer");

  void handleSound(GameObject e) async {
    // await player.setVolume(1);
    // await player.play(AssetSource(e));
    // // will immediately start playing
    // debugPrint("effectPlayer $e");

    _speak(e.name);
  }

  void handleSoundEffect(String e) async {
    await player.setVolume(1);
    await player.play(AssetSource(e));
    // will immediately start playing
    debugPrint("effectPlayer $e");
  }

  void playBGM() async {
    await bgPlayer.play(
      AssetSource("sound/backsound.mp3"),
    );

    await bgPlayer.setVolume(0.1);

    await bgPlayer.setReleaseMode(ReleaseMode.loop);
  }

  void stopBGM() async {
    await bgPlayer.stop();
  }

  void stateInit() async {
    initTts();
    _initSpeech();
    playBGM();
  }

  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;

  /// This has to happen only once per app
  void _initSpeech() async {
    _speechEnabled = await _speechToText.initialize();
    setState(() {});
  }

  /// Each time to start a speech recognition session
  void _startListening() async {
    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: "id_ID",
    );
    setState(() {});
  }

  /// Manually stop the active speech recognition session
  /// Note that there are also timeouts that each platform enforces
  /// and the SpeechToText plugin supports setting timeouts on the
  /// listen method.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  String detectedWords = "";

  List<GameScore> scores = [];

  void _onSpeechResult(SpeechRecognitionResult result) {
    String res = result.recognizedWords;

    debugPrint("rec : $res");

    bool correct =
        res.toLowerCase().contains(selectedObject!.name.toLowerCase());

    debugPrint(
        "recognized: $res correct : $correct target :${selectedObject!.name.toLowerCase()}");
    if (res.isNotEmpty) {
      setState(() {
        scores = [
          ...scores,
          GameScore(
            sessionId: currentIndex,
            object: selectedObject!,
            correct: correct,
            answer: res,
          ),
        ];

        if (_speechToText.isListening) {
          _stopListening();
        }

        selectedObject = null;
      });
    }
  }

  late FlutterTts flutterTts;
  String? language;
  String? engine;
  double volume = 0.5;
  double pitch = 1.0;
  double rate = 0.5;
  bool isCurrentLanguageInstalled = false;

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  bool get isIOS => !kIsWeb && Platform.isIOS;
  bool get isAndroid => !kIsWeb && Platform.isAndroid;
  bool get isWindows => !kIsWeb && Platform.isWindows;
  bool get isWeb => kIsWeb;

  Future _setAwaitOptions() async {
    await flutterTts.awaitSpeakCompletion(true);
  }

  Future _getDefaultEngine() async {
    var engine = await flutterTts.getDefaultEngine;
    if (engine != null) {
      debugPrint(engine);
    }
  }

  bool allowTTS = true;

  Future _speak(String words) async {
    if (!allowTTS) return;

    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);

    if (words.isNotEmpty) {
      await flutterTts.speak(words);
    }
  }

  initTts() {
    flutterTts = FlutterTts();
    flutterTts.setLanguage("id-ID");
    _setAwaitOptions();

    if (isAndroid) {
      _getDefaultEngine();
    }

    flutterTts.setStartHandler(() {
      setState(() {
        debugPrint("Playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        debugPrint("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setCancelHandler(() {
      setState(() {
        debugPrint("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    if (isWeb || isIOS || isWindows) {
      flutterTts.setPauseHandler(() {
        setState(() {
          debugPrint("Paused");
          ttsState = TtsState.paused;
        });
      });

      flutterTts.setContinueHandler(() {
        setState(() {
          debugPrint("Continued");
          ttsState = TtsState.continued;
        });
      });
    }

    flutterTts.setErrorHandler((msg) {
      setState(() {
        debugPrint("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    stateInit();
  }

  Offset offset = Offset.zero;
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key

  GameObject? selectedObject;

  int currentIndex = 0;

  List<GameSession> sessions = [
    kelasSession,
    halamanSession,
    kantinSession,
    tokoSession,
    pasarSession
  ];

  void handleSelectObject(GameObject e) {
    handleSound(e);
    setState(() {
      if (_speechToText.isListening) {
        _stopListening();
      }

      selectedObject = e;
    });
  }

  bool allFinished = false;

  @override
  Widget build(BuildContext context) {
    GameSession currentSession = sessions[currentIndex];

    List<String> finishedObjects = scores.map((e) => e.object.name).toList();

    List<GameObject> objects = currentSession.objects
        .where((element) => !finishedObjects.contains(element.name))
        .toList();
    return Scaffold(
      key: _key,
      onDrawerChanged: (open) {
        if (!open) {
          playBGM();
        } else {
          stopBGM();
        }
      },
      drawer: Drawer(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Text(
              'PETI HARTA KARUN',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(
              height: 20,
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 3,
              children: scores
                  .map(
                    (e) => Card(
                      child: InkWell(
                        onTap: () => handleSound(e.object),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Image.asset(
                            e.object.image,
                            fit: BoxFit.cover,
                            height: 70,
                            width: 70,
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _key.currentState!.closeDrawer();
                },
                child: const Text('Tutup'),
              ),
            ),
            SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      allowTTS = !allowTTS;
                    });
                  },
                  child: Text(
                      '${allowTTS ? "Matikan" : "Nyalakan"} Bantuan Suara'),
                )),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _key.currentState!.openDrawer(); // <-- Opens
          bgPlayer.stop();
        },
        backgroundColor: Colors.green,
        child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.asset(
              'assets/objects/peti harta karun.jpg',
            )),
      ),
      body: Container(
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
                colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3), BlendMode.darken),
                image: AssetImage(currentSession.bg),
                fit: BoxFit.cover),
          ),
          child: SingleChildScrollView(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              selectedObject == null
                  ? Padding(
                      padding: const EdgeInsets.only(top: 90.0, bottom: 10),
                      child: allFinished
                          ? Card(
                              child: Padding(
                                  padding: const EdgeInsets.all(20),
                                  child: Column(
                                    children: [
                                      const Text(
                                          'Anda berhasil menyelesaikan semua peti harta karun ! '),
                                      ElevatedButton(
                                          onPressed: () {
                                            setState(() {
                                              allFinished = false;
                                              allowTTS = false;
                                              currentIndex = 0;
                                              scores = [];
                                            });
                                          },
                                          child: const Text(
                                              'Main Ulang Tanpa Bantuan Suara'))
                                    ],
                                  )),
                            )
                          : Column(
                              children: [
                                Text(
                                  '${objects.isEmpty ? "" : "Ayo temukan"} benda - benda yang ada di ${currentSession.name}!',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                      color: Colors.white),
                                ),
                                Text(
                                  objects.isEmpty
                                      ? "Rekam kamu selesai!"
                                      : 'Masukkan benda - benda ke harta karun !',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.none,
                                      color: Colors.white),
                                )
                              ],
                            ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(
                          top: 120.0, bottom: 20, right: 20, left: 20),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(children: [
                            const Text(
                              'Coba Ucapkan kata',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(
                              selectedObject!.name,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Image.asset(
                              selectedObject!.image,
                              fit: BoxFit.cover,
                              height: 100,
                              width: 100,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Text(detectedWords),
                            const SizedBox(
                              height: 20,
                            ),
                            _speechEnabled
                                ? isPlaying
                                    ? const CircularProgressIndicator()
                                    : ElevatedButton.icon(
                                        onPressed: () {
                                          if (_speechToText.isNotListening) {
                                            _startListening();
                                          } else {
                                            _stopListening();
                                          }
                                        },
                                        icon: const Icon(Icons.mic),
                                        label: Text(_speechToText.isListening
                                            ? "Berhenti"
                                            : "Mulai"))
                                : const Text('Tidak ada microfon terdeteksi'),
                          ]),
                        ),
                      ),
                    ),
              selectedObject == null && !allFinished
                  ? objects.isNotEmpty
                      ? GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 3,
                          children: objects
                              .map(
                                (e) => Card(
                                  child: InkWell(
                                    onTap: () => {handleSelectObject(e)},
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Image.asset(
                                        e.image,
                                        fit: BoxFit.cover,
                                        height: 70,
                                        width: 70,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                              .toList(),
                        )
                      : Card(
                          child: SingleChildScrollView(
                            physics: const ScrollPhysics(),
                            child: Column(
                              children: [
                                ListView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    itemCount: scores.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      GameScore e = scores.elementAt(index);

                                      return ListTile(
                                        title: Text(e.object.name),
                                        onLongPress: () {
                                          handleSelectObject(e.object);

                                          setState(() {
                                            detectedWords = e.answer;
                                          });
                                        },
                                        trailing: Checkbox(
                                          value: e.correct,
                                          onChanged: (bool? value) {},
                                        ),
                                        onTap: () {
                                          _speak(e.answer);
                                          debugPrint("speak ${e.answer}");
                                        },
                                      );
                                    }),
                                ElevatedButton(
                                    onPressed: () {
                                      _key.currentState!.closeDrawer();
                                      setState(() {
                                        if (sessions.length > currentIndex) {
                                          currentIndex = currentIndex + 1;
                                          detectedWords = "";
                                        } else {
                                          allFinished = true;
                                        }
                                      });
                                    },
                                    child: const Text("Selanjutnya"))
                              ],
                            ),
                          ),
                        )
                  : Container(),
            ]),
          )),
    );
  }
}

GameSession kelasSession = GameSession(
    name: "Ruang Kelas",
    objects: [
      GameObject(
        name: "Kursi",
        image: "assets/objects/kelas/kursi kartun.jpg",
      ),
      GameObject(
        name: "Papan Tulis",
        image: "assets/objects/kelas/papan tulis.jpg",
      ),
      GameObject(
        name: "Buku",
        image: "assets/objects/kelas/buku.jpg",
      ),
      GameObject(
        name: "Anak Memakai Tas",
        image: "assets/objects/kelas/anak memakai tas.png",
      ),
      GameObject(
        name: "Tas Sekolah",
        image: "assets/objects/kelas/tas sekolah.jpg",
      ),
      GameObject(
        name: "Penggaris",
        image: "assets/objects/kelas/penggaris.jpg",
      ),
      GameObject(
        name: "Pensil",
        image: "assets/objects/kelas/pensil.jpg",
      ),
    ],
    bg: 'assets/bg/ruang_kelas.jpg');

GameSession kantinSession = GameSession(
    name: "Kantin",
    objects: [
      GameObject(
        name: "Tisu",
        image: "assets/objects/kantin/tisu.jpg",
      ),
      GameObject(
        name: "Donat",
        image: "assets/objects/kantin/donat.jpg",
      ),
      GameObject(
        name: "Permen",
        image: "assets/objects/kantin/permen.jpg",
      ),
      GameObject(
        name: "Botol",
        image: "assets/objects/kantin/botol.jpg",
      ),
    ],
    bg: 'assets/bg/kantin_sekolah.jpg');

GameSession pasarSession = GameSession(
    name: "Pasar",
    objects: [
      GameObject(
        name: "Daging",
        image: "assets/objects/pasar/daging.webp",
      ),
      GameObject(
        name: "Telur Ayam",
        image: "assets/objects/pasar/telur ayam.jpg",
      ),
      GameObject(
        name: "Buah Jeruk",
        image: "assets/objects/pasar/buah jeruk.webp",
      ),
    ],
    bg: 'assets/bg/pasar.jpg');

GameSession tokoSession = GameSession(
    name: "Pasar",
    objects: [
      GameObject(
        name: "Sepeda",
        image: "assets/objects/toko/sepeda.webp",
      ),
      GameObject(
        name: "Celana",
        image: "assets/objects/toko/celana.jpg",
      ),
      GameObject(
        name: "kaos",
        image: "assets/objects/toko/kaos.webp",
      ),
      GameObject(
        name: "Gunting",
        image: "assets/objects/toko/gunting",
      ),
    ],
    bg: 'assets/bg/gambar_toko.jpg');

GameSession halamanSession = GameSession(
    name: "Halaman Sekolah",
    objects: [
      GameObject(
        name: "Rumput",
        image: "assets/objects/halaman sekolah/rumput.jpg",
      ),
      GameObject(
        name: "Jendela",
        image: "assets/objects/halaman sekolah/jendela.jpg",
      ),
      GameObject(
        name: "Pohon",
        image: "assets/objects/halaman sekolah/pohon.jpg",
      ),
      GameObject(
        name: "Pot Bunga",
        image: "assets/objects/halaman sekolah/pot bunga.jpg",
      ),
      GameObject(
        name: "Bendera merah Putih",
        image: "assets/objects/halaman sekolah/bendera merah putih.jpg",
      ),
    ],
    bg: 'assets/bg/taman_sekolah.jpg');
