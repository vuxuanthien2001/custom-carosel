import 'package:video_player/video_player.dart';

class Model{
  String? id;
  String? name;
  String? url;
  int? type;
  VideoPlayerController? videoPlayerController;

  Model({
    this.id,
    this.name,
    this.url,
    this.type,
    this.videoPlayerController,
  });
}