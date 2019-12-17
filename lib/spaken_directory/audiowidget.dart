import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioWidget extends StatefulWidget{

  final String url;

  AudioWidget({this.url});

  @override
  State<StatefulWidget> createState() {
    return _AudioWidgetState();
  }
}

class _AudioWidgetState extends State<AudioWidget>
{
  AudioPlayer audioPlayer;

  @override
  void initState() {
    super.initState();
    //AudioPlayer.logEnabled = true;
    audioPlayer = AudioPlayer();
  }

  @override
  Widget build(BuildContext context) {
    play();
    return Container();
  }

  void play() async{
    int result = await audioPlayer.play(widget.url);
    {
      if (result == 1)
        {
          print("Audio played successfully");
        }
    }
  }

  @override
  void dispose() {
    audioPlayer.release();
    audioPlayer.dispose();
    super.dispose();
  }

}
