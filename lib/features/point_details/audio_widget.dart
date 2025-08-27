import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:kazan_guide/core/presentation/colors.dart';
import 'package:kazan_guide/core/presentation/context_expentions.dart';

class AudioWidget extends StatefulWidget {
  const AudioWidget({required this.assetSource, required this.name, super.key});

  final String assetSource;
  final String name;

  @override
  State<AudioWidget> createState() => _AudioWidgetState();
}

class _AudioWidgetState extends State<AudioWidget> {
  late final StreamSubscription _playerStateSub;
  late final StreamSubscription _playerDurationSub;

  bool _isPlaying = false;
  bool _onPause = false;
  Duration _duration = Duration.zero;

  final AudioPlayer _player = AudioPlayer();

  static List<AudioPlayer> _players = [];

  static Future<void> _stopAllPlayers() async {
    for (final player in _players) {
      await player.pause();
    }
  }

  @override
  void initState() {
    _players.add(_player);
    _player.setSourceAsset(widget.assetSource);

    _playerStateSub = _player.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.paused) {
        setState(() {
          _onPause = true;
        });
      }
      if (state == PlayerState.playing) {
        setState(() {
          _onPause = false;
          _isPlaying = true;
        });
      }
      if (state == PlayerState.stopped) {
        setState(() {
          _onPause = false;
          _isPlaying = false;
        });
      }
      if (state == PlayerState.completed) {
        setState(() {
          _isPlaying = false;
        });
      }
    });
    _playerDurationSub = _player.onDurationChanged.listen((duration) {
      setState(() {
        _duration = duration;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    _playerStateSub.cancel();
    _playerDurationSub.cancel();
    _player.dispose();
    _players.remove(_player);
    super.dispose();
  }

  Future<void> _playButton() async {
    if (!_isPlaying) {
      await _stopAllPlayers();
      await _player.play(AssetSource(widget.assetSource));
      setState(() {
        _isPlaying = true;
      });
    } else {
      if (_onPause) {
        _onPause = false;
        await _stopAllPlayers();
        await _player.resume();
      } else {
        /// здесь не нужно устанавливать значение _onPause, так как
        /// оно установится в _playerStateSub
        await _player.pause();
      }
    }
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: MediaQuery.sizeOf(context).width,
    child: FittedBox(
      child: Row(
        children: [
          InkWell(
            customBorder: const CircleBorder(),
            onTap: _playButton,
            child: Container(
              height: 52,
              width: 52,
              decoration: BoxDecoration(
                color: AppColors.red,
                shape: BoxShape.circle,
              ),
              child: Icon(
                _isPlaying && !_onPause ? Icons.pause : Icons.play_arrow,
                color: Colors.white,
                size: 30,
              ),
            ),
          ),
          StreamBuilder(
            stream: _player.onPositionChanged,
            builder: (context, snapshot) {
              final value = snapshot.data?.inSeconds.toDouble() ?? 0.0;
              return Stack(
                children: [
                  Positioned(
                    bottom: 0,
                    right: 20,
                    child: Text(
                      '${_formatTime(snapshot.data?.inSeconds ?? 0)}/${_formatTime(_duration.inSeconds)}',
                      style: context.textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * 0.75,
                    child: Slider(
                      min: 0,
                      thumbColor: AppColors.red,
                      activeColor: AppColors.red,
                      max: _duration.inSeconds.toDouble(),
                      value: value,
                      onChanged: (newValue) {
                        _player.seek(Duration(seconds: newValue.toInt()));
                      },
                    ),
                  ),
                ],
              );
            },
          ),
          Text(
            widget.name,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ),
  );

  String _formatTime(int seconds) {
    final s = seconds % 60;
    final m = seconds ~/ 60;
    return '${m > 9 ? m : '0$m'}:${s > 9 ? s : '0$s'}';
  }
}
