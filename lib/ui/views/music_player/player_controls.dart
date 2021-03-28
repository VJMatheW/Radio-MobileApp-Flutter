import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import '../../../core/models/player.dart';
import '../../../core/viewmodels/init_model.dart';
import '../../../core/viewmodels/player_view_model.dart';
import '../../../ui/utils.dart';
import '../../../locator.dart';

class PlayerControls extends StatefulWidget {
  @override
  _PlayerControlsState createState() => _PlayerControlsState();
}

class _PlayerControlsState extends State<PlayerControls> {
  MusicPlayer _player;

  @override
  void initState() {
    _player = locator<InitModel>().getMusicPlayer;
    super.initState();
  }

  IconButton getIconButton(IconData iconData, Function pressed) {
    return IconButton(
      icon: Icon(iconData),
      enableFeedback: false,
      splashColor: Colors.transparent,
      padding: EdgeInsets.all(screenAwareSize(1.0, context)),
      iconSize: screenAwareSize(17, context),
      onPressed: pressed,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PlayerViewModel>(builder: (context, model, child) {
      bool showPlayerControls = model.getShowPlayerControls;

      return Visibility(
        visible: showPlayerControls,
        maintainAnimation: true,
        maintainState: true,
        child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: screenAwareSize(45, context),
              maxHeight: screenAwareSize(45, context),
              minWidth: double.infinity,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  /** Seek bar */
                  Expanded(
                    flex: 2,
                    child: StreamBuilder(
                      stream: _player.getDurationStream,
                      builder: (context, snapshot) {
                        final duration = snapshot.data ?? Duration.zero;
                        return StreamBuilder(
                          stream: _player.getPositionStream,
                          builder: (context, snapshot) {
                            var position = snapshot.data ?? Duration.zero;
                            if (position > duration) {
                              position = duration;
                            }
                            return SeekBar(
                              position: position,
                              duration: duration,
                              onChangeEnd: (newPosition) {
                                _player.seek(newPosition);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),

                  /** Track Controls and Info */
                  Expanded(
                    flex: 2,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        /** Track Title */
                        Expanded(
                          flex: 2,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                                screenAwareSize(10, context), 0, 0, 0),
                            child: Consumer<PlayerViewModel>(
                              builder: (context, model, child) {
                                return Text(
                                  model.getCurrentTrack.title,
                                  style: Theme.of(context).textTheme.headline6,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                );
                              },
                            ),
                          ),
                        ),

                        /** Track Control Buttons */
                        Expanded(
                          flex: 1,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              getIconButton(
                                Icons.first_page,
                                () {
                                  _player.previous();
                                },
                              ),
                              StreamBuilder(
                                stream: _player.getPlayBackStream,
                                builder: (context, snapshot) {
                                  final fullState = snapshot.data;
                                  final state = fullState?.state;
                                  final buffering = fullState?.buffering;

                                  // for loading
                                  if (state == AudioPlaybackState.connecting ||
                                      buffering == true) {
                                    return Center(
                                      child: CupertinoActivityIndicator(),
                                    );
                                  }

                                  // for stopped
                                  if (state == AudioPlaybackState.completed) {
                                    _player.next();
                                    return Container();
                                  }

                                  // for playing state
                                  if (state == AudioPlaybackState.playing) {
                                    return getIconButton(
                                      Icons.pause,
                                      () {
                                        _player.pause();
                                      },
                                    );
                                  } else {
                                    return getIconButton(
                                      Icons.play_arrow,
                                      () {
                                        _player.play();
                                      },
                                    );
                                  }
                                },
                              ),
                              getIconButton(
                                Icons.last_page,
                                () {
                                  _player.next();
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
      );
    });
  }
}

class SeekBar extends StatefulWidget {
  final Duration position;
  final Duration duration;
  final Function onChangeEnd;

  SeekBar(
      {@required this.position,
      @required this.duration,
      @required this.onChangeEnd});

  @override
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {
  double _dragValue;

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.white,
        thumbColor: Theme.of(context).accentColor,
        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 5.0),
        overlayShape: RoundSliderOverlayShape(overlayRadius: 10.0),
      ),
      child: Slider(
        min: 0.0,
        max: widget.duration.inMilliseconds.toDouble(),
        activeColor: Theme.of(context).primaryColor,
        value: _dragValue ?? widget.position.inMilliseconds.toDouble(),
        onChanged: (value) {
          setState(() {
            _dragValue = value;
          });
        },
        onChangeEnd: (value) {
          _dragValue = null;
          widget.onChangeEnd(Duration(milliseconds: value.round()));
        },
        label: "Test",
      ),
    );
  }
}
