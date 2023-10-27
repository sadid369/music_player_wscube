import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late AudioPlayer player;

  bool isLoading = false;
  Duration? totalduration = Duration.zero;
  var audioUrl =
      "https://raag.fm/files/mp3/128/Hindi-Singles/24006/Besharam%20Rang%20(Pathaan)%20-%20(Raag.Fm).mp3";
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    setUpAudio();
  }

  void setUpAudio() async {
    try {
      totalduration = await player.setUrl(audioUrl);
      player.playbackEventStream.listen((event) {
        if (event.processingState == ProcessingState.loading) {
          isLoading = true;
          setState(() {});
        } else if (event.processingState == ProcessingState.ready) {
          isLoading = false;
          setState(() {});
        }
      });
      player.play();
      setState(() {});
    } catch (e) {
      print("Error Player: ${e.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Audio Player'),
        ),
        body: Center(
          child: isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Row(
                  children: [
                    InkWell(
                        onTap: () {
                          if (player.playing) {
                            player.pause();
                          } else {
                            player.play();
                          }
                          setState(() {});
                        },
                        child: player.playing
                            ? Icon(Icons.pause)
                            : Icon(Icons.play_arrow)),
                  ],
                ),
        ));
  }
}
