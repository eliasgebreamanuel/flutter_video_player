import 'package:flutter/material.dart';
import 'package:flutter_video_player/screens/VideoPlayerScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:flutter_video_player/model/video.dart';

class VideoLists extends StatefulWidget {
  const VideoLists({Key? key}) : super(key: key);

  @override
  State<VideoLists> createState() => _VideoListsState();
}

class _VideoListsState extends State<VideoLists> {
  List<Video> videos = [];
  Color? scaffoldBackgroundColor;

  @override
  void initState() {
    super.initState();
    fetchVideos();
  }

  Future<void> fetchVideos() async {
    try {
      final response = await http.get(
        Uri.parse('https://app.et/devtest/list.json'),
        // Add any additional headers if required
      );
      if (response.statusCode == 200) {
        try {
          final jsonString = response.body;
          final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
          var backgroundColorHex = jsonData["appBackgroundHexColor"];
          setState(() {
            videos = (jsonData['videos'] as List)
                .map((entry) => Video.fromJson(entry as Map<String, dynamic>))
                .toList();
            scaffoldBackgroundColor = Color(
                int.parse(backgroundColorHex.replaceFirst("#", ""), radix: 16));
          });
        } catch (error) {
          throw Exception('Failed to decode videos: $error');
        }
      } else {
        throw Exception('Failed to fetch videos');
      }
    } catch (error) {
      throw Exception('Failed to make the HTTP request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Video List'),
      ),
      body: ListView.builder(
        itemCount: videos.length,
        itemBuilder: (context, index) {
          final video = videos[index];
          return ListTile(
            title: Text(video.videoTitle),
            subtitle: Text(video.videoDescription ?? ''),
            leading: video.videoThumbnail != null
                ? Image.network(video.videoThumbnail!)
                : null,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      VideoPlayerScreen(videoUrl: video.videoUrl),
                ),
              );
            },
          );
        },
      ),
    );
  }
}