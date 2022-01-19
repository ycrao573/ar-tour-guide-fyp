// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'package:wikitude_flutter_app/pages/visionPage.dart';

import 'recognize.dart';

class ImagePickerPage extends StatefulWidget {
  ImagePickerPage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  _ImagePickerPageState createState() => _ImagePickerPageState();
}

class _ImagePickerPageState extends State<ImagePickerPage> {
  List<XFile>? _imageFileList;

  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  String _detectionType = "label";
  dynamic _pickImageError;
  bool isVideo = false;

  VideoPlayerController? _controller;
  VideoPlayerController? _toBeDisposed;
  String? _retrieveDataError;

  final ImagePicker _picker = ImagePicker();
  final TextEditingController maxWidthController = TextEditingController();
  final TextEditingController maxHeightController = TextEditingController();
  final TextEditingController qualityController = TextEditingController();

  Future<void> _playVideo(XFile? file) async {
    if (file != null && mounted) {
      await _disposeVideoController();
      late VideoPlayerController controller;
      if (kIsWeb) {
        controller = VideoPlayerController.network(file.path);
      } else {
        controller = VideoPlayerController.file(File(file.path));
      }
      _controller = controller;
      // In web, most browsers won't honor a programmatic call to .play
      // if the video has a sound track (and is not muted).
      // Mute the video so it auto-plays in web!
      // This is not needed if the call to .play is the result of user
      // interaction (clicking on a "play" button, for example).
      final double volume = kIsWeb ? 0.0 : 1.0;
      await controller.setVolume(volume);
      await controller.initialize();
      await controller.setLooping(true);
      await controller.play();
      setState(() {});
    }
  }

  void _onImageButtonPressed(ImageSource source, String type,
      {BuildContext? context, bool isMultiImage = false}) async {
    if (_controller != null) {
      await _controller!.setVolume(0.0);
    }
    if (isVideo) {
      final XFile? file = await _picker.pickVideo(
          source: source, maxDuration: const Duration(seconds: 10));
      await _playVideo(file);
    } else if (isMultiImage) {
    } else {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 25,
        // maxWidth: maxWidth,
        // maxHeight: maxHeight,
        // imageQuality: quality,
      );
      final pickedType = type;
      setState(() {
        _imageFile = pickedFile;
        _detectionType = pickedType;
      });
      //   } catch (e) {
      //     setState(() {
      //       _pickImageError = e;
      //     });
      //   }
      // });
    }
  }

  @override
  void deactivate() {
    if (_controller != null) {
      _controller!.setVolume(0.0);
      _controller!.pause();
    }
    super.deactivate();
  }

  @override
  void dispose() {
    _disposeVideoController();
    maxWidthController.dispose();
    maxHeightController.dispose();
    qualityController.dispose();
    super.dispose();
  }

  Future<void> _disposeVideoController() async {
    if (_toBeDisposed != null) {
      await _toBeDisposed!.dispose();
    }
    _toBeDisposed = _controller;
    _controller = null;
  }

  // Widget _previewVideo() {
  //   final Text? retrieveError = _getRetrieveErrorWidget();
  //   if (retrieveError != null) {
  //     return retrieveError;
  //   }
  //   if (_controller == null) {
  //     return const Text(
  //       'You have not yet picked a video',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  //   return Padding(
  //     padding: const EdgeInsets.all(10.0),
  //     child: AspectRatioVideo(_controller),
  //   );
  // }

  String toBase64(File file) {
    return base64Encode(file.readAsBytesSync());
  }

  Widget _previewImages(String type) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (_imageFileList != null) {
      return VisionPage(
          base64: toBase64(File(_imageFileList![0].path)), type: type);
      // Column(
      //     mainAxisAlignment: MainAxisAlignment.center,
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       Semantics(
      //         label: 'image_picker_example_picked_image',
      //         child: kIsWeb?
      //              Image.network(_imageFileList![index].path)
      //             : Image.file(File(_imageFileList![index].path)),
      //       ),
      //     ]);
      // },
      // itemCount: _imageFileList!.length,
    } else if (_pickImageError != null) {
      return Container(
          width: double.infinity,
          height: double.infinity,
          color: Color(0x7d85ccd8),
          child: Text(
            'Pick image error: $_pickImageError',
            textAlign: TextAlign.center,
          ));
    } else {
      return Container(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(
              width: 320,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Landmark Detection',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: 'Billabong',
                      fontSize: 44.0,
                      color: Color(0xff081c1e),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  Image(
                    image: AssetImage(
                      'assets/images/onboarding.png',
                    ),
                    height: 240.0,
                    width: 320.0,
                  ),
                  Text(
                    'Recognize Landmarks 🏞️ \n in Your Photos 🤳 \n within few seconds',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                      color: Color(0xff081c1e),
                      height: 1.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: 40),
            Text(
              'Pick a photo from:  ',
              style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.red[400],
                  fontWeight: FontWeight.w600),
              textAlign: TextAlign.left,
            ),
            SizedBox(height: 110),
          ],
        ),
      );
      // return const Text(
      //   'Search with Your Image!',
      //   textAlign: TextAlign.center,
      // );
    }
  }

  Future<void> retrieveLostData() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      if (response.type == RetrieveType.video) {
        isVideo = true;
        await _playVideo(response.file);
      } else {
        isVideo = false;
        setState(() {
          _imageFile = response.file;
          _imageFileList = response.files;
        });
      }
    } else {
      _retrieveDataError = response.exception!.code;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x8885ccd8),
      body: Center(
        child: !kIsWeb && defaultTargetPlatform == TargetPlatform.android
            ? FutureBuilder<void>(
                future: retrieveLostData(),
                builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.none:
                    case ConnectionState.waiting:
                      return const Text(
                        '',
                        textAlign: TextAlign.center,
                      );
                    case ConnectionState.done:
                      return _previewImages(_detectionType);
                    default:
                      if (snapshot.hasError) {
                        return Text(
                          'Pick image/video error: ${snapshot.error}}',
                          textAlign: TextAlign.center,
                        );
                      } else {
                        return const Text(
                          '',
                          textAlign: TextAlign.center,
                        );
                      }
                  }
                },
              )
            : _previewImages(_detectionType),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
        child: Wrap(
          runSpacing: 5.0,
          spacing: 5.0,
          children: <Widget>[
            // Padding(
            //   padding: const EdgeInsets.only(top: 6.0),
            //   child: FloatingActionButton.extended(
            //     onPressed: () {
            //       isVideo = false;
            //       _onImageButtonPressed(ImageSource.camera, "landmark",
            //           context: context);
            //     },
            //     label: const Text('Camera'),
            //     heroTag: 'image1',
            //     tooltip: 'Take a Photo and do landmark detection',
            //     icon: const Icon(Icons.landscape_sharp),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6.0),
            //   child: FloatingActionButton.extended(
            //     onPressed: () {
            //       isVideo = false;
            //       _onImageButtonPressed(ImageSource.gallery, "landmark",
            //           context: context);
            //     },
            //     heroTag: 'image2',
            //     label: const Text('Gallery'),
            //     tooltip: 'Pick a Photo and do landmark detection',
            //     icon: const Icon(Icons.landscape),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6.0),
            //   child: FloatingActionButton.extended(
            //     backgroundColor: Colors.red,
            //     onPressed: () {
            //       isVideo = false;
            //       _onImageButtonPressed(ImageSource.camera, "web",
            //           context: context);
            //     },
            //     label: const Text('Camera'),
            //     heroTag: 'image3',
            //     tooltip: 'Take a Photo and do web detection',
            //     icon: const Icon(Icons.image_search),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6.0),
            //   child: FloatingActionButton.extended(
            //     backgroundColor: Colors.red,
            //     onPressed: () {
            //       isVideo = false;
            //       _onImageButtonPressed(ImageSource.gallery, "web",
            //           context: context);
            //     },
            //     label: const Text('Gallery'),
            //     heroTag: 'image4',
            //     tooltip: 'Pick a Photo and do web detection',
            //     icon: const Icon(Icons.image_search_sharp),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FloatingActionButton.extended(
                backgroundColor: Color(0xfff08e8d),
                foregroundColor: Color(0xfffafafa),
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.gallery, "mixed",
                      context: context);
                },
                label: const Text('Gallery',
                    style: TextStyle(
                        fontWeight: FontWeight.w500, color: Color(0xfffafafa))),
                heroTag: 'image5',
                tooltip: 'Pick a Photo from Gallery',
                icon: const Icon(Icons.photo_album),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(2.0),
              child: FloatingActionButton.extended(
                backgroundColor: Color(0xfff08e8d),
                foregroundColor: Color(0xfffafafa),
                onPressed: () {
                  isVideo = false;
                  _onImageButtonPressed(ImageSource.camera, "mixed",
                      context: context);
                },
                label: const Text('Camera',
                    style: TextStyle(fontWeight: FontWeight.w500)),
                heroTag: 'image6',
                tooltip: 'Pick a Photo from Camera',
                icon: const Icon(Icons.camera),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6.0),
            //   child: FloatingActionButton(
            //     backgroundColor: Colors.red,
            //     onPressed: () {
            //       isVideo = true;
            //       _onImageButtonPressed(ImageSource.gallery);
            //     },
            //     heroTag: 'video0',
            //     tooltip: 'Pick Video from gallery',
            //     child: const Icon(Icons.video_library),
            //   ),
            // ),
            // Padding(
            //   padding: const EdgeInsets.only(top: 6.0),
            //   child: FloatingActionButton(
            //     backgroundColor: Colors.red,
            //     onPressed: () {
            //       isVideo = true;
            //       _onImageButtonPressed(ImageSource.camera);
            //     },
            //     heroTag: 'video1',
            //     tooltip: 'Take a Video',
            //     child: const Icon(Icons.videocam),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Text? _getRetrieveErrorWidget() {
    if (_retrieveDataError != null) {
      final Text result = Text(_retrieveDataError!);
      _retrieveDataError = null;
      return result;
    }
    return null;
  }
}
//   Future<void> _displayPickImageDialog(
//       BuildContext context, OnPickImageCallback onPick) async {
//     return showDialog(
//         context: context,
//         builder: (context) {
//           return AlertDialog(
//             title: Text('Add optional parameters'),
//             content: Column(
//               // children: <Widget>[
//               //   TextField(
//               //     controller: maxWidthController,
//               //     keyboardType: TextInputType.numberWithOptions(decimal: true),
//               //     decoration:
//               //         InputDecoration(hintText: "Enter maxWidth if desired"),
//               //   ),
//               //   TextField(
//               //     controller: maxHeightController,
//               //     keyboardType: TextInputType.numberWithOptions(decimal: true),
//               //     decoration:
//               //         InputDecoration(hintText: "Enter maxHeight if desired"),
//               //   ),
//               //   TextField(
//               //     controller: qualityController,
//               //     keyboardType: TextInputType.number,
//               //     decoration:
//               //         InputDecoration(hintText: "Enter quality if desired"),
//               //   ),
//               // ],
//             ),
//             actions: <Widget>[
//               // TextButton(
//               //   child: const Text('CANCEL'),
//               //   onPressed: () {
//               //     Navigator.of(context).pop();
//               //   },
//               // ),
//               TextButton(
//                   child: const Text('PICK'),
//                   onPressed: () {
//                     // double? width = maxWidthController.text.isNotEmpty
//                     //     ? double.parse(maxWidthController.text)
//                     //     : null;
//                     // double? height = maxHeightController.text.isNotEmpty
//                     //     ? double.parse(maxHeightController.text)
//                     //     : null;
//                     // int? quality = qualityController.text.isNotEmpty
//                     //     ? int.parse(qualityController.text)
//                     //     : null;
//                     onPick(null, null, null);
//                     Navigator.of(context).pop();
//                   }),
//             ],
//           );
//         });
//   }
// }

// typedef void OnPickImageCallback(
//     double? maxWidth, double? maxHeight, int? quality);

// class AspectRatioVideo extends StatefulWidget {
//   AspectRatioVideo(this.controller);

//   final VideoPlayerController? controller;

//   @override
//   AspectRatioVideoState createState() => AspectRatioVideoState();
// }

// class AspectRatioVideoState extends State<AspectRatioVideo> {
//   VideoPlayerController? get controller => widget.controller;
//   bool initialized = false;

//   void _onVideoControllerUpdate() {
//     if (!mounted) {
//       return;
//     }
//     if (initialized != controller!.value.isInitialized) {
//       initialized = controller!.value.isInitialized;
//       setState(() {});
//     }
//   }

//   @override
//   void initState() {
//     super.initState();
//     controller!.addListener(_onVideoControllerUpdate);
//   }

//   @override
//   void dispose() {
//     controller!.removeListener(_onVideoControllerUpdate);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (initialized) {
//       return Center(
//         child: AspectRatio(
//           aspectRatio: controller!.value.aspectRatio,
//           child: VideoPlayer(controller!),
//         ),
//       );
//     } else {
//       return Container();
//     }
//   }
// }