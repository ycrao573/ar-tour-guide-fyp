import 'package:flutter/material.dart';
import 'credentials.dart';
import 'package:googleapis/vision/v1.dart';
import 'dart:convert';
import 'dart:io';

class RecognizeProvider {
  var _client = CredentialsProvider().client;

  Future<WebLabel> searchWebImageBestGuessedLabel(String image) async {
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

  // String? base64Convert(Material.Image image){
  //   var image = const Material.Image(
  //     image: Material.NetworkImage('https://thesmartlocal.com/wp-content/uploads/2021/08/image2-min-1.jpg'),
  //   );
  //   return Convert.base64Encode(image.readAsBytesSync());
  // }

  Future<String> searchWebImageReturnInfo(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {"type": "WEB_DETECTION"}
          ]
          // "imageContext": {
          //   "webDetectionParams": {"includeGeoResults": true}
          // }
        }
      ]
    }));

    late var _responseInfo;
    _response.responses!.forEach((data) {
      var _responseTest = data.webDetection;
      if (_responseTest != null) {
        try {
          String? _entityName = data.webDetection!.webEntities![0].description;
          var _fullMatchedImage = data.webDetection!.fullMatchingImages;
          String? _fullMatchedImageUrl =
              (_fullMatchedImage != null) ? _fullMatchedImage[0].url : null;
          var _partialMatchedImage = data.webDetection!.partialMatchingImages;
          String? _partialMatchedImageUrl = (_partialMatchedImage != null)
              ? _partialMatchedImage[0].url
              : null;
          var _matchedPage = data.webDetection!.pagesWithMatchingImages;
          String? _matchedPageUrl =
              (_matchedPage != null) ? _matchedPage[0].url : null;
          String? _label =
              data.webDetection!.bestGuessLabels!.single.label.toString();
          _responseInfo = {
            "description": _entityName,
            "fullMatchedImageUrl": _fullMatchedImageUrl,
            "partialMatchedImageUrl": _partialMatchedImageUrl,
            "matchedPageUrl": _matchedPageUrl,
            "label": _label,
            "type": "web"
          };
        } catch (e) {
          throw new Exception("We don't find any result");
        }
      }
    });
    return json.encode(_responseInfo);
  }

  Future<String> searchLandmarkReturnInfo(String image) async {
    var _vision = VisionApi(await _client);
    var _api = _vision.images;
    var _response = await _api.annotate(BatchAnnotateImagesRequest.fromJson({
      "requests": [
        {
          "image": {"content": image},
          "features": [
            {
              "type": "LANDMARK_DETECTION",
              "maxResults": 5,
            }
          ]
        }
      ]
    }));

    late var _responseInfo;
    _response.responses!.forEach((data) {
      String? _landmarkName = data.landmarkAnnotations![0].description;
      double? _latitude =
          data.landmarkAnnotations![0].locations![0].latLng!.latitude;
      double? _longitude =
          data.landmarkAnnotations![0].locations![0].latLng!.longitude;
      _responseInfo = {
        "landmarkName": _landmarkName,
        "latitude": _latitude,
        "longitude": _longitude,
        "type": "landmark"
      };
    });
    return json.encode(_responseInfo);
  }
}
