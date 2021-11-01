import 'package:flutter/material.dart';
import 'recognize.dart';

class VisionPage extends StatefulWidget {
  final String base64;
  final String type;

  const VisionPage({Key? key, required this.base64, required this.type})
      : super(key: key);

  @override
  _VisionPageState createState() => _VisionPageState();
}

class _VisionPageState extends State<VisionPage> {
  var _recognizeProvider = new RecognizeProvider();

  @override
  Widget build(BuildContext context) {
    final Future<String> _callVisionAPI;
    if (widget.type == 'label')
      _callVisionAPI = _recognizeProvider
          .searchWebImageBestGuessedLabel(widget.base64)
          .then((e) => e.label.toString());
    else if (widget.type == 'landmark')
      _callVisionAPI = _recognizeProvider
          .searchLandmarkReturnInfo(widget.base64)
          .then((e) => e);
    else
      _callVisionAPI = _recognizeProvider
          .searchWebImageReturnInfo(widget.base64)
          .then((e) => e);

    return DefaultTextStyle(
      style: Theme.of(context).textTheme.bodyText2!,
      textAlign: TextAlign.center,
      child: FutureBuilder<String>(
        future: _callVisionAPI, // a previously-obtained Future<String> or null
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          List<Widget> children;
          if (snapshot.hasData) {
            children = <Widget>[
              SizedBox(height: 250),
              const Icon(
                Icons.check_circle_outline,
                color: Colors.green,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Result: ${snapshot.data}',
                    style: TextStyle(color: Colors.black)),
              )
            ];
          } else if (snapshot.hasError) {
            children = <Widget>[
              const Icon(
                Icons.error_outline,
                color: Colors.red,
                size: 60,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text('Error: ${snapshot.error}'),
              )
            ];
          } else {
            children = const <Widget>[
              SizedBox(
                child: CircularProgressIndicator(),
                width: 60,
                height: 60,
              ),
              Padding(
                padding: EdgeInsets.only(top: 16),
                child: Text('Awaiting result...'),
              )
            ];
          }
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: children,
            ),
          );
        },
      ),
    );
  }
}
