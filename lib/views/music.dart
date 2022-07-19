import 'package:car_computer/providers/music_provider.dart';
import 'package:car_computer/providers/ui_provider.dart';
import 'package:car_computer/widgets/container_gradient_border.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';
import 'package:text_scroll/text_scroll.dart';

class MusicView extends StatefulWidget {
  const MusicView({Key? key}) : super(key: key);
  @override
  State<MusicView> createState() => _MusicView();
}

class _MusicView extends State<MusicView> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var musicProvider = Provider.of<MusicProvider>(context);
    return Expanded(
        child: Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MusicTrackPanel(),
          const Padding(
            padding: EdgeInsets.only(left: 8.0),
            child: Text(
              "Utwory",
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
              child: Padding(
            padding: const EdgeInsets.only(left: 8.0, top: 10, right: 15),
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: musicProvider.getTrackList.length,
                itemBuilder: (context, index) => MusicTrackWidget(
                    musicTrack: musicProvider.getTrackList[index],
                    musicProvider: musicProvider)),
          )),
        ],
      ),
    ));
  }
}

class MusicTrackPanel extends StatefulWidget {
  const MusicTrackPanel({Key? key}) : super(key: key);

  @override
  State<MusicTrackPanel> createState() => _MusicTrackPanelState();
}

class _MusicTrackPanelState extends State<MusicTrackPanel> {
  PlayerState? _playerState;
  Duration? _currentPlaytimePosition;
  Duration? _maxPlaytimePosition;

  @override
  void initState() {
    Provider.of<MusicProvider>(context, listen: false).getPlayer
      ..playerStateStream.listen((event) {
        if (mounted) {
          setState(() {
            _playerState = event;
          });
        }
      })
      ..positionStream.listen((event) {
        if (mounted) {
          setState(() {
            _currentPlaytimePosition = event;
            var mp = Provider.of<MusicProvider>(context, listen: false);
            if (getTrackPercentageComplete == 1 && !mp.isLastTrack) {
              mp.nextTrack();
            }
          });
        }
      })
      ..durationStream.listen((event) {
        if (mounted) {
          setState(() {
            _maxPlaytimePosition = event;
          });
        }
      });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var musicProvider = Provider.of<MusicProvider>(context);
    return ContainerGradientBorder(
        description: "Aktualnie odtwarzane",
        innerWidget: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              LayoutBuilder(
                builder: (context, constraints) {
                  return Container(
                    constraints:
                        BoxConstraints(maxWidth: constraints.maxWidth * 0.9),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          constraints: BoxConstraints(
                              maxWidth: constraints.maxWidth * 0.6),
                          child: TextScroll(
                            musicProvider.getCurrentTrack != null
                                ? musicProvider
                                        .getCurrentTrack!.metadata.trackName ??
                                    ""
                                : "",
                            mode: TextScrollMode.bouncing,
                            velocity:
                                const Velocity(pixelsPerSecond: Offset(100, 0)),
                            delayBefore: const Duration(milliseconds: 2000),
                            pauseBetween: const Duration(milliseconds: 2000),
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20, height: 1),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Container(
                            constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.3),
                            child: TextScroll(
                              musicProvider.getCurrentTrack != null
                                  ? musicProvider.getCurrentTrack!.metadata
                                      .trackArtistNames!
                                      .join(",")
                                  : "",
                              mode: TextScrollMode.bouncing,
                              velocity: const Velocity(
                                  pixelsPerSecond: Offset(100, 0)),
                              delayBefore: const Duration(milliseconds: 2000),
                              pauseBetween: const Duration(milliseconds: 2000),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 16, height: 1),
                            ))
                      ],
                    ),
                  );
                },
              ),
              Visibility(
                visible: musicProvider.getCurrentTrack != null,
                child: Row(
                  children: [
                    SizedBox(
                      width: 50,
                      child: Text(
                        musicProvider.milisToTrackMinutes(
                            _currentPlaytimePosition ?? Duration.zero),
                        style: TextStyle(
                            color: Provider.of<UiProvider>(context).accentColor,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        min: 0.0,
                        max: 1.0,
                        value: getTrackPercentageComplete,
                        onChangeStart: (_) {
                          musicProvider.pauseAudio();
                        },
                        onChangeEnd: (_) {
                          musicProvider.playAudio();
                        },
                        onChanged: (value) {
                          musicProvider.rewindTrack(Duration(
                              milliseconds: percetageToTrackDuration(value)));
                        },
                        activeColor:
                            Provider.of<UiProvider>(context).accentColor,
                        inactiveColor: Provider.of<UiProvider>(context)
                            .accentColor
                            .withOpacity(0.2),
                      ),
                    ),
                    SizedBox(
                        width: 50,
                        child: Text(
                            musicProvider.milisToTrackMinutes(
                                _maxPlaytimePosition ?? Duration.zero),
                            style: const TextStyle(color: Colors.grey)))
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: IconButton(
                        iconSize: 30,
                        onPressed: musicProvider.isFirstTrack ||
                                musicProvider.getCurrentTrack == null
                            ? null
                            : () {
                                musicProvider.previousTrack();
                              },
                        icon: Icon(
                          Icons.skip_previous,
                          color: musicProvider.isFirstTrack ||
                                  musicProvider.getCurrentTrack == null
                              ? Colors.grey
                              : Colors.white,
                        )),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5),
                    child: IconButton(
                        iconSize: 50,
                        onPressed: _playerState != null && _playerState!.playing
                            ? () {
                                musicProvider.pauseAudio();
                              }
                            : () {
                                musicProvider.playAudio();
                              },
                        icon: Icon(
                            _playerState != null && _playerState!.playing
                                ? Icons.pause_circle
                                : Icons.play_circle,
                            color: musicProvider.getCurrentTrack == null
                                ? Colors.grey
                                : Colors.white)),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: IconButton(
                        iconSize: 30,
                        onPressed: musicProvider.isLastTrack ||
                                musicProvider.getCurrentTrack == null
                            ? null
                            : () {
                                musicProvider.nextTrack();
                              },
                        icon: Icon(Icons.skip_next,
                            color: musicProvider.isLastTrack ||
                                    musicProvider.getCurrentTrack == null
                                ? Colors.grey
                                : Colors.white)),
                  )
                ],
              )
            ],
          ),
        ));
  }

  double get getTrackPercentageComplete {
    if (_currentPlaytimePosition != null &&
        _maxPlaytimePosition != null &&
        _currentPlaytimePosition != Duration.zero &&
        _maxPlaytimePosition != Duration.zero) {
      return ((_currentPlaytimePosition!.inMicroseconds /
                      _maxPlaytimePosition!.inMicroseconds) *
                  1000)
              .toInt() /
          1000;
    } else {
      return 0;
    }
  }

  int percetageToTrackDuration(double percentage) {
    if (_maxPlaytimePosition != null) {
      return (_maxPlaytimePosition!.inMilliseconds * percentage).toInt();
    } else {
      return 0;
    }
  }
}

class MusicTrackWidget extends StatelessWidget {
  final MusicTrack musicTrack;
  final MusicProvider musicProvider;

  const MusicTrackWidget(
      {Key? key, required this.musicTrack, required this.musicProvider})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        musicProvider.selectTrack(musicTrack);
      },
      style: ButtonStyle(
        backgroundColor: musicProvider.getCurrentTrack == musicTrack
            ? MaterialStateColor.resolveWith((states) =>
                Provider.of<UiProvider>(context, listen: false)
                    .accentColor
                    .withOpacity(0.2))
            : MaterialStateColor.resolveWith((states) => Colors.transparent),
        overlayColor: MaterialStateColor.resolveWith((states) =>
            Provider.of<UiProvider>(context, listen: false)
                .accentColor
                .withOpacity(0.2)),
      ),
      child: Container(
        decoration: BoxDecoration(
            border: Border(
                bottom: BorderSide(color: Colors.grey.withOpacity(0.6)))),
        constraints: const BoxConstraints(minHeight: 50),
        height: MediaQuery.of(context).size.height * 0.07,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: [
              const Icon(
                Icons.album,
                size: 20,
                color: Colors.white,
              ),
              Expanded(
                  child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      musicTrack.metadata.trackName ?? "",
                      style: const TextStyle(
                          color: Colors.white,
                          height: 1,
                          fontWeight: FontWeight.normal,
                          fontSize: 14),
                    ),
                    Text(musicTrack.metadata.trackArtistNames!.join(","),
                        style: const TextStyle(
                            color: Colors.grey,
                            height: 1.5,
                            fontWeight: FontWeight.bold,
                            fontSize: 10))
                  ],
                ),
              )),
              Text(
                  musicProvider.milisToTrackMinutes(Duration(
                      milliseconds: musicTrack.metadata.trackDuration ?? 1)),
                  style: const TextStyle(
                      color: Colors.grey,
                      height: 1,
                      fontWeight: FontWeight.bold,
                      fontSize: 12))
            ],
          ),
        ),
      ),
    );
  }
}
