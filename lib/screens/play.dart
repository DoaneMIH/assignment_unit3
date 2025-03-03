// import 'package:flutter/material.dart';
// import 'package:just_audio/just_audio.dart';

// class MainPage extends StatefulWidget {
//   const MainPage({super.key});

//   @override
//   State<MainPage> createState() => _MainPageState();
// }

// class _MainPageState extends State<MainPage> {
//   final audioPlayer = AudioPlayer();
//   bool isPlaying = false;
//   Duration duration = Duration.zero;
//   Duration position = Duration.zero;

//   @override
//   void initState() {
//     super.initState();
//       _loadAudio();

//     // Listen to player state (play/pause)
//     audioPlayer.playerStateStream.listen((state) {
//       setState(() {
//         isPlaying = state.playing;
//       });
//     });

//     // Listen to duration changes
//     audioPlayer.durationStream.listen((newDuration) {
//       setState(() {
//         duration = newDuration ?? Duration.zero;
//       });
//     });

//     // Listen to position updates
//     audioPlayer.positionStream.listen((newPosition) {
//       setState(() {
//         position = newPosition;
//       });
//     });
//   }

//     Future<void> _loadAudio() async {
//     const url = 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3';
//     await audioPlayer.setUrl(url);
//   }

//   @override
//   void dispose() {
//     audioPlayer.dispose();
//     super.dispose();
//   }

//   String formatTime(Duration duration) {
//     String twoDigits(int n) => n.toString().padLeft(2, '0');
//     final minutes = twoDigits(duration.inMinutes.remainder(60));
//     final seconds = twoDigits(duration.inSeconds.remainder(60));
//     return "$minutes:$seconds";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         title: const Text("Doane Playlist"),
//       ),
//       body: Center(
//         child: Column(
//           children: [
//             const SizedBox(height: 32),
//             const Text("Title of song"),
//             const SizedBox(height: 32),
//             const Text("Singer"),
//             Slider(
//               min: 0,
//               max: duration.inSeconds.toDouble(),
//               value: position.inSeconds.toDouble(),
//               onChanged: (value) async {
//                 await audioPlayer.seek(Duration(seconds: value.toInt()));
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 16),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(formatTime(position)), // Current position
//                   Text(formatTime(duration - position)), // Remaining time
//                 ],
//               ),
//             ),
//             const SizedBox(height: 20),
//             CircleAvatar(
//               radius: 35,
//               child: IconButton(
//                 onPressed: () async {
//                   if (isPlaying) {
//                     await audioPlayer.pause();
//                   } else {
//                     await audioPlayer.play();
//                   }
//                 },
//                 icon: Icon(isPlaying ? Icons.pause : Icons.play_arrow),
//                 iconSize: 50,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
