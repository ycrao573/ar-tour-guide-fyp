import 'credentials.dart';
import 'package:googleapis/vision/v1.dart';

class RecognizeProvider {
  var _client = CredentialsProvider().client;

  Future<WebLabel> search(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {"type": "WEB_DETECTION"}
          ]
        }
      ]
    }));

    late WebLabel _bestGuessLabel;
    _response.responses!.forEach((data) {
      var _label = data.webDetection!.bestGuessLabels;
      _bestGuessLabel = _label!.single;
    });
    return _bestGuessLabel;
  }
}