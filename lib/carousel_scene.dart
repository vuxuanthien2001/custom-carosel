import 'package:custom_carosel/cig_carousel.dart';
import 'package:custom_carosel/data.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

// var loadVideoStatus = false;

class CarouselScene extends StatefulWidget {
  const CarouselScene({super.key});

  @override
  State<CarouselScene> createState() => _CarouselSceneState();
}

class _CarouselSceneState extends State<CarouselScene> {
  @override
  void initState() {
    super.initState();

    /// set VideoController
    for (int i = 0; i < Data.model.length; i++) {
      if (Data.model[i].type == 1) {
        late VideoPlayerController videoPlayerController;
        videoPlayerController =
            VideoPlayerController.networkUrl(Uri.parse(Data.model[i].url!))
              ..initialize().then((_) {
                // loadVideoStatus = true;
                videoPlayerController.setVolume(0);
                videoPlayerController.setLooping(true);
                if (Data.pageCurrent == i) {
                  videoPlayerController.play();
                } else {
                  videoPlayerController.pause();
                }
                setState(() {
                  // loadVideoStatus;
                  videoPlayerController;
                });
              });
        Data.model[i].videoPlayerController = videoPlayerController;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: CigCarousel(
        children: List.generate(
          Data.numItems,
          (index) => Container(
            // color: Colors.primaries[index % Colors.primaries.length],
            alignment: Alignment.center,
            child: Data.model[index].type == 0
                ? Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage(Data.model[index].url!),
                          fit: BoxFit.cover),
                    ),
                  )
                : VideoPlayer(Data.model[index].videoPlayerController!),
          ),
        ),
      ),
    );
  }
}
