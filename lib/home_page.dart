import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> audioUrlList = [
    "https://raag.fm/files/mp3/128/Hindi/24451/Nouka%20Doobi%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Roshni%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Zara%20Hat%20Ke%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Nouka%20Doobi%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Roshni%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Zara%20Hat%20Ke%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Nouka%20Doobi%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Roshni%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Zara%20Hat%20Ke%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Nouka%20Doobi%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Roshni%20-%20(Raag.Fm).mp3",
    "https://raag.fm/files/mp3/128/Hindi/24451/Zara%20Hat%20Ke%20-%20(Raag.Fm).mp3",
  ];
  late AudioPlayer player;

  bool isLoading = false;
  Duration? totalDuration = Duration.zero;
  Duration? currentDuration = Duration.zero;
  Duration? bufferDuration = Duration.zero;

  var audioUrl =
      "https://raag.fm/files/mp3/128/Hindi-Singles/24006/Besharam%20Rang%20(Pathaan)%20-%20(Raag.Fm).mp3";
  @override
  void initState() {
    super.initState();
    player = AudioPlayer();
    setUpAudio(audioUrlList[0]);
  }

  void setUpAudio(String audioUrl) async {
    try {
      totalDuration = await player.setUrl(audioUrl);
      player.playbackEventStream.listen((event) {
        if (event.processingState == ProcessingState.loading) {
          isLoading = true;
          setState(() {});
        } else if (event.processingState == ProcessingState.ready) {
          isLoading = false;
          setState(() {});
        }
      });
      player.positionStream.listen((event) {
        print(event.inSeconds);
        currentDuration = event;
        setState(() {});
      });
      player.bufferedPositionStream.listen((event) {
        bufferDuration = event;
        setState(() {});
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
              : Padding(
                  padding: const EdgeInsets.all(11.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: ListView.builder(
                        itemCount: audioUrlList.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              onTap: () {
                                setUpAudio(audioUrlList[index]);
                              },
                              leading: Container(
                                height: 35,
                                width: 35,
                                child: Image.asset(
                                    "assets/images/Lost-Movie-Shreya-Ghoshal.jpg"),
                              ),
                              title: Text("Song- $index"),
                            ),
                          );
                        },
                      )),
                      ProgressBar(
                        thumbColor: Colors.red,
                        thumbGlowColor: Colors.red.withOpacity(0.4),
                        bufferedBarColor: Colors.red.shade200,
                        progressBarColor: Colors.red,
                        baseBarColor: Colors.grey,
                        buffered: bufferDuration,
                        progress: currentDuration!,
                        total: totalDuration!,
                        onSeek: (value) {
                          player.seek(value);
                          setState(() {});
                        },
                      ),
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
                ),
        ));
  }
}
