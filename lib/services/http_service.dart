import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../model/app_config.dart';

class HTTPService {
  final Dio dio = Dio();
  AppConfig? _appConfig;
  String? _base_url;

  HTTPService() {
    _appConfig = GetIt.instance.get<AppConfig>();
    _base_url = _appConfig!.COIN_API_BASE_URL;
  }

  Future<Response?> get(String _path) async {
    try {
      String _url = '$_base_url$_path';
      return await dio.get(_url);
    } catch (e) {
      print("Catch $e");
    }
  }
}
