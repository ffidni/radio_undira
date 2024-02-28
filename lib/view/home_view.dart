import 'dart:developer';

import 'package:audio_wave/audio_wave.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:radio_undira/config/my_colors.dart';
import 'package:radio_player/radio_player.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final RadioPlayer _radioPlayer = RadioPlayer();
  bool isPlaying = false;
  List<String>? metadata;
  bool dialogOpen = false;

  @override
  void initState() {
    super.initState();
    initRadioPlayer();
  }

  void initRadioPlayer() {
    _radioPlayer.setChannel(
      title: 'Radio Player',
      url: 'http://27.50.19.173:9000/UNDIRA1',
      // url: 'http://stream-uk1.radioparadise.com/aac-320',
      imagePath: 'assets/images/logo.png',
    );

    _radioPlayer.stateStream.listen(
      (value) {
        setState(() {
          isPlaying = value;
        });
      },
      onError: (err) {
        log("error: ${err.toString()}");
      },
    );

    _radioPlayer.metadataStream.listen(
      (value) {
        log("metadata: $value");
        setState(() {
          metadata = value;
        });
      },
      onError: (err) {
        log("error: ${err.toString()}");
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      if (isPlaying && metadata == null && !dialogOpen) {
        showDialog(
          context: context,
          builder: (context) {
            dialogOpen = true;
            return const AlertDialog(
              title: Text("Radio UNDIRA"),
              content: Text(
                "Data sedang diproses",
              ),
            );
          },
        ).then((_) {
          dialogOpen = false;
        });
      }
    });

    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                MyColors.primary,
                MyColors.primary.withOpacity(0.7),
              ]),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 48.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  "Radio UNDIRA",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12.0),
                child: Text(
                  "Santai, Ringan Dan Berbobot",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              FutureBuilder(
                future: _radioPlayer.getArtworkImage(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  Image artwork;
                  if (snapshot.hasData) {
                    artwork = snapshot.data;
                  } else {
                    artwork = Image.asset(
                      'assets/images/logo.png',
                      fit: BoxFit.cover,
                    );
                  }

                  return Center(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      height: MediaQuery.of(context).size.width * 0.6,
                      child: ClipRRect(
                        child: artwork,
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(
                height: 30.0,
              ),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0),
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (metadata != null)
                        if (metadata![0].isNotEmpty)
                          Text(
                            metadata?[0] ?? '',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 22),
                          ),
                      if (metadata != null)
                        if (metadata![0].isNotEmpty)
                          Text(
                            metadata?[1] ?? '',
                            softWrap: false,
                            overflow: TextOverflow.fade,
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                      const SizedBox(height: 5),
                      if (metadata != null) _buildAudioWave(),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: MyColors.primary,
                                width: 2,
                              ),
                            ),
                            child: IconButton(
                              iconSize: 48.0,
                              color: MyColors.primary,
                              onPressed: () {
                                isPlaying
                                    ? _radioPlayer.pause()
                                    : _radioPlayer.play();
                              },
                              tooltip: 'Control button',
                              icon: Icon(
                                isPlaying
                                    ? Icons.pause_rounded
                                    : Icons.play_arrow_rounded,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Text(
                        isPlaying ? "Pause" : "Play",
                        overflow: TextOverflow.fade,
                        style: const TextStyle(
                          fontSize: 18,
                          color: MyColors.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AudioWave _buildAudioWave() {
    return AudioWave(
      height: 38,
      width: 88,
      spacing: 2.5,
      // animationLoop: isPlaying ? null : 1,
      bars: [
        AudioWaveBar(
            heightFactor: 0.1,
            color: !isPlaying ? Colors.grey : Colors.lightBlueAccent),
        AudioWaveBar(
            heightFactor: 0.2, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.4, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.2, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.3, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.7, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 1, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.7, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.2, color: !isPlaying ? Colors.grey : Colors.orange),
        AudioWaveBar(
            heightFactor: 0.1,
            color: !isPlaying ? Colors.grey : Colors.lightBlueAccent),
        AudioWaveBar(
            heightFactor: 0.3, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.5, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.4, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.2, color: !isPlaying ? Colors.grey : Colors.orange),
        AudioWaveBar(
            heightFactor: 0.1,
            color: !isPlaying ? Colors.grey : Colors.lightBlueAccent),
        AudioWaveBar(
            heightFactor: 0.3, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.7, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.8, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.6, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 1, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.4, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.2, color: !isPlaying ? Colors.grey : Colors.orange),
        AudioWaveBar(
            heightFactor: 0.1,
            color: !isPlaying ? Colors.grey : Colors.lightBlueAccent),
        AudioWaveBar(
            heightFactor: 0.3, color: !isPlaying ? Colors.grey : Colors.blue),
        AudioWaveBar(
            heightFactor: 0.7, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.4, color: !isPlaying ? Colors.grey : Colors.black),
        AudioWaveBar(
            heightFactor: 0.1, color: !isPlaying ? Colors.grey : Colors.orange),
      ],
    );
  }
}
