import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({required this.videoUrl});

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;
  late InterstitialAd _interstitialAd;
  bool _isAdLoaded = false;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _playVideoWithAd();
      });

    _interstitialAd = InterstitialAd(
      adUnitId: 'ca-app-pub-3940256099942544/1033173712',
      request: AdRequest(),
      listener: AdListener(
        onAdLoaded: (ad) {
          // Interstitial ad loaded
          setState(() {
            _isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          // Interstitial ad failed to load
        },
        onAdClosed: (ad) {
          // Interstitial ad closed
          _playVideo();
          _interstitialAd.dispose();
        },
      ),
    );
    _interstitialAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? Stack(
            children: [
              AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              ),
              if (_controller.value.isPlaying) SizedBox.shrink(),
              if (!_controller.value.isPlaying && _isAdLoaded)
                Center(
                  child: ElevatedButton(
                    onPressed: _showAd,
                    child: Text('Play Ad'),
                  ),
                ),
            ],
          )
        : const CircularProgressIndicator();
  }

  void _playVideoWithAd() {
    if (_isAdLoaded) {
      _showAd();
    } else {
      _playVideo();
    }
  }

  void _playVideo() {
    _controller.play();
  }

  void _showAd() {
    if (_isAdLoaded) {
      _interstitialAd.show();
      setState(() {
        _isAdLoaded = false;
      });
    } else {
      _playVideo();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _interstitialAd.dispose();
    super.dispose();
  }
}