import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Musicscreen extends StatefulWidget {
  const Musicscreen({super.key});

  @override
  State<Musicscreen> createState() => _MusicscreenState();
}

class _MusicscreenState extends State<Musicscreen> with WidgetsBindingObserver {
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  bool playingBeforeStop = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this); 
    loadAudio();

    // Play and pause listener
    audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlaying = state.playing;
      });
    });

    // Duration updates
    audioPlayer.durationStream.listen((newDuration) {
      setState(() {
        duration = newDuration ?? Duration.zero;
      });
    });

    // Position updates
    audioPlayer.positionStream.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  // Load Audio
  Future<void> loadAudio() async {
    try {
      await audioPlayer.setAsset('assets/bp.mp3');
    } catch (e) {
      print("Error loading audio: $e");
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      //PAUSE THE MUSIC
      if (isPlaying) {
        playingBeforeStop = true;
        audioPlayer.pause();
      }
    } else if (state == AppLifecycleState.resumed) {
      //RESUME THE MUSIC
      if (playingBeforeStop) {
        playingBeforeStop = false;
        audioPlayer.play();
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this); // Remove observer
    audioPlayer.dispose();
    super.dispose();
  }

  // Format the time display
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
        title: const Text("Horlador's Music Player", style: TextStyle(color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 0, 0, 0),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Colors.black,Color.fromARGB(255, 196, 0, 150)], 
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter)
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/bp.jpg'),
              const SizedBox(height: 20),
              const Text("Now Playing", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 10),
              const Text("BOOMBAYAH", style: TextStyle(fontSize: 18, color: Colors.white)),
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
                activeColor: const Color.fromARGB(255, 0, 0, 0),
              ),
        
              // Time Display
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(formatTime(position), style: const TextStyle(color: Colors.white),), 
                    Text(formatTime(duration - position), style: const TextStyle(color: Colors.white),), 
                  ],
                ),
              ),
              const SizedBox(height: 20),
        
              // Play/Pause Button
              CircleAvatar(
                radius: 35,
                backgroundColor: const Color.fromARGB(255, 255, 253, 253),
                child: IconButton(
                  onPressed: () async {
                    if (isPlaying) {
                      await audioPlayer.pause();
                    } else {
                      await audioPlayer.play();
                    }
                  },
                  icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow, color: const Color.fromARGB(255, 248, 27, 222)),
                  iconSize: 50,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
