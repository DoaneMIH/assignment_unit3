import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // color: Colors.pink,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    loadAudio();

    //Play and pause
    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    //duration updates of music
    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    //position update
    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  //Load Audio or music
  Future<void> loadAudio() async {
    try {
      await audioPlayer.setAsset('assets/bp.mp3');
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  //dispose
  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  //format the time of music
  String formatTime(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Music Player", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('assets/bp.jpg'),
            const SizedBox(height: 20),
            const Text("Now Playing", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            const Text("BOOMBAYAH", style: TextStyle(fontSize: 18), ),
            const SizedBox(height: 20),
            
            // Slider
            Slider(
              min: 0,
              max: duration.inSeconds.toDouble(),
              value: position.inSeconds.toDouble(),
              onChanged: (value) async {
                final newPosition = Duration(seconds: value.toInt());
                await audioPlayer.seek(newPosition);
              },
            ),

            // Time Display
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatTime(position)),  // Current position
                  Text(formatTime(duration - position)),  // Remaining time
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Play/Pause Button
            CircleAvatar(
              radius: 35,
              backgroundColor: Colors.blueAccent,
              child: IconButton(
                onPressed: () async {
                  if (isPlaying) {
                    await audioPlayer.pause();
                  } else {
                    await audioPlayer.play();
                  }
                },
                icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: Colors.white),
                iconSize: 50,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
