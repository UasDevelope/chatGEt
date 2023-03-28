import 'package:chat_gpt/const/constant.dart';
import 'package:chat_gpt/helper/cache.dart';
import 'package:chat_gpt/model/image_gen.dart';
import 'package:chat_gpt/resources/cache_keys.dart';
import 'package:dio/dio.dart';

class ImageGeneratorAPI {
  static Future<List<ImageGenModel>> generateImage(String prompt,
      [int count = 6]) async {
    final size = CacheHelper.getData(key: CacheKeys.imageSize) ?? "512x512";

    try {
      Dio dio = Dio(BaseOptions(
          baseUrl: "https://api.openai.com/v1",
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${Const.API_KEY}"
          },
          receiveDataWhenStatusError: true));

      final response = await dio.post("/images/generations",
          data: {"prompt": prompt, "n": count, "size": size});

      List<ImageGenModel> images = List.from((response.data!['data'] as List)
          .map((e) => ImageGenModel.fromJson(e))
          .toList());
      return images;
    } on DioError catch (e) {
      return e.response!.data['error'];
    }
  }
}
