import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:nile_quest/shared/styles/colors.dart';
import 'package:video_player/video_player.dart';

class VideoPlayer extends StatefulWidget {
  final String title;
  const VideoPlayer({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  State<VideoPlayer> createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  late VideoPlayerController videoPlayerController;
  ChewieController? chewieController;
  bool isLoading = true;
  String? videoUrl;
  double? videoAspectRatio;

  @override
  void dispose() {
    super.dispose();
    videoPlayerController.dispose();
    chewieController?.dispose();
  }

  @override
  void initState() {
    super.initState();
    fetchVideoUrl();
  }

  Future<void> fetchVideoUrl() async {
    List<String> collections = [
      'Cairo',
      'Alexandria',
      'Aswan',
      'Luxor',
      'south sinai',
      'Matruh',
      'Sharm El-sheikh',
    ];
    bool videoFound = false;
    for (String collectionName in collections) {
      if (videoFound) break;
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection(collectionName)
          .where('Name', isEqualTo: widget.title)
          .get();
      for (var document in querySnapshot.docs) {
        if (document.exists) {
          videoUrl = document['Videos'];
          videoPlayerController =
              VideoPlayerController.networkUrl(Uri.parse(videoUrl!));
          await videoPlayerController.initialize();
          videoAspectRatio = videoPlayerController.value.aspectRatio;
          chewieController = ChewieController(
            materialProgressColors: ChewieProgressColors(
              playedColor: mainColor,
              bufferedColor: Color.fromRGBO(255, 255, 255, 0.3),
              handleColor: Colors.white,
            ),
            videoPlayerController: videoPlayerController,
            aspectRatio: videoAspectRatio!,
            autoInitialize: true,
            autoPlay: true,
            looping: true,
          );
          videoFound = true;
          break;
        }
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            IconButton(
              icon: const Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.7,
              child: Text(
                widget.title,
                style: const TextStyle(
                  color: Colors.white,
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            )
          ],
        ),
      ),
      body: isLoading
          ? Container(
              color: Colors.black,
              child: Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              ),
            )
          : Container(
              color: Colors.black,
              child: Center(
                child: Chewie(
                  controller: chewieController!,
                ),
              ),
            ),
    );
  }
}
