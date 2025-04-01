import 'package:custom_carosel/model.dart';

class Data {
  static List<String> images = [
    "https://firebasestorage.googleapis.com/v0/b/gift-app-3274b.appspot.com/o/3HSAD0PSCV8I%2Fimages%2FIMG_2024_1_10_1704855222162.jpg?alt=media&token=4c9b610f-c4ed-4658-a2fa-c071416f14ec",
    "https://firebasestorage.googleapis.com/v0/b/gift-app-3274b.appspot.com/o/3HSAD0PSCV8I%2Fimages%2FIMG_2024_1_10_1704855289022.jpg?alt=media&token=01114bba-4700-4ab6-be49-5fb99ad51843",
    "https://firebasestorage.googleapis.com/v0/b/gift-app-3274b.appspot.com/o/JTP1C4XQDPXS%2Fimages%2FIMG_2024_1_10_1704857196589.jpg?alt=media&token=b66b61c5-dcce-4bbf-92bc-1d04b843c794",
  ];

  static List<String> videos = [
    "https://www.fluttercampus.com/video.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4",
    "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
  ];

  static List<Model> model = <Model>[
    Model(
      id: "123654789345",
      name: "Bim Bim",
      url:
          "https://firebasestorage.googleapis.com/v0/b/gift-app-3274b.appspot.com/o/3HSAD0PSCV8I%2Fimages%2FIMG_2024_1_10_1704855222162.jpg?alt=media&token=4c9b610f-c4ed-4658-a2fa-c071416f14ec",
      type: 0,
    ),
    Model(
      id: "321456987678",
      name: "Cỏ Xe Ôm",
      url:
          "https://firebasestorage.googleapis.com/v0/b/gift-app-3274b.appspot.com/o/JTP1C4XQDPXS%2Fimages%2FIMG_2024_1_10_1704857196589.jpg?alt=media&token=b66b61c5-dcce-4bbf-92bc-1d04b843c794",
      type: 0,
    ),
    Model(
      id: "987654321908",
      name: "Thỏ Phê Cỏ",
      url:
          "https://flutter.github.io/assets-for-api-docs/assets/videos/butterfly.mp4",
      type: 1,
    ),
  ];

  static int numItems = model.length;

  static int pageCurrent = 0;

  static String formatUid(String? uid){
    if (uid == null){
      return "XXXX-XXXX-XXXX";
    }
    uid = uid.replaceAllMapped(RegExp(r".{4}"), (match) => "${match.group(0)}-");
    uid = uid.substring(0, uid.length - 1);
    return  uid;
  }
}
