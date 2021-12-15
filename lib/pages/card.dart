import 'dart:ui';

import 'package:flutter/material.dart';

class CardPage extends StatefulWidget {
  const CardPage({Key? key}) : super(key: key);

  @override
  _CardPageState createState() => _CardPageState();
}

/*

            if (response["type"] != null) {
              if (response["type"] == "web") {
                "description": _entityName,
                "fullMatchedImageUrl": _fullMatchedImageUrl,
                "partialMatchedImageUrl": _partialMatchedImageUrl,
                "matchedPageUrl": _matchedPageUrl,
                "label": _label
                children = <Widget>[
                  SizedBox(height: 50),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      (response["description"] != null)
                          ? Text(response["description"],
                              style: TextStyle(
                                  fontSize: 24.0, fontWeight: FontWeight.bold))
                          : Text("Not found"),
                      SizedBox(height: 10),
                      (response["fullMatchedImageUrl"] != null)
                          ? Image.network(response["fullMatchedImageUrl"])
                          : ((response["partialMatchedImageUrl"] != null)
                              ? Image.network(
                                  response["partialMatchedImageUrl"])
                              : Text("")),
                      (response["label"] != null)
                          ? Text(response["description"],
                              style: myTheme.textTheme.caption)
                          : Text("label"),
                      SizedBox(height: 10),
                      (response["matchedPageUrl"] != null)
                          ? ElevatedButton(
                              onPressed: () =>
                                  launch(response["matchedPageUrl"]),
                              child: new Text('Click here to know more'),
                            )
                          : Text(""),
                    ],
                  )
                ];

*/

class _CardPageState extends State<CardPage> {
  @override
  Widget build(BuildContext context) {
    return Text("");
    //   return Container(
    //     width: double.infinity,
    //     height: double.infinity,
    //     decoration: BoxDecoration(
    //         image: DecorationImage(
    //             image: NetworkImage(
    //                 "https://images.unsplash.com/photo-1579202673506-ca3ce28943ef?ixlib=rb-1.2.1&ixid=eyJhcHBfaWQiOjEyMDd9&auto=format&fit=crop&w=500&q=60"),
    //             fit: BoxFit.cover)),
    //     child: BackdropFilter(
    //       filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
    //       child: Column(
    //         mainAxisAlignment: MainAxisAlignment.spaceAround,
    //         crossAxisAlignment: CrossAxisAlignment.center,
    //         children: [
    //           SizedBox(
    //             width: 330,
    //             child: Card(
    //               color: Colors.black.withOpacity(0.5),
    //               clipBehavior: Clip.antiAlias,
    //               child: Padding(
    //                 padding: const EdgeInsets.all(8.0),
    //                 child: Column(
    //                   children: [
    //                     ListTile(
    //                       leading: Icon(Icons.image_search_outlined,
    //                           color: Colors.pinkAccent, size: 36.0),
    //                       title: const Text(
    //                         'MRT Station',
    //                         style: TextStyle(
    //                             fontWeight: FontWeight.bold,
    //                             fontSize: 22.0,
    //                             color: Colors.white),
    //                       ),
    //                       subtitle: Text(
    //                         'Tourist Attractions',
    //                         style:
    //                             TextStyle(color: Colors.white.withOpacity(0.8)),
    //                       ),
    //                     ),
    //                     Padding(
    //                       padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
    //                       child: Text(
    //                         'Use a Column to display widgets in verticat>[ Icon(...), Text(...), ], ).',
    //                         style:
    //                             TextStyle(color: Colors.white.withOpacity(0.8)),
    //                       ),
    //                     ),
    //                     ClipRRect(
    //                       borderRadius: BorderRadius.circular(5.0),
    //                       child: ConstrainedBox(
    //                           constraints: BoxConstraints(
    //                             maxHeight: 200,
    //                           ),
    //                           child: Image.asset('assets/images/mall.jpg')),
    //                     ),
    //                     ButtonBar(
    //                       alignment: MainAxisAlignment.start,
    //                       children: [
    //                         TextButton.icon(
    //                           icon: Icon(
    //                             Icons.directions,
    //                             color: Colors.pinkAccent,
    //                           ),
    //                           label: Text(
    //                             'Directions',
    //                             style: TextStyle(
    //                                 color: Colors.pinkAccent, fontSize: 15.0),
    //                           ),
    //                           onPressed: () {},
    //                         ),
    //                         TextButton.icon(
    //                           icon: Icon(
    //                             Icons.read_more_outlined,
    //                             color: Colors.pinkAccent,
    //                           ),
    //                           label: Text(
    //                             'Read More',
    //                             style: TextStyle(
    //                                 color: Colors.pinkAccent, fontSize: 15.0),
    //                           ),
    //                           onPressed: () {},
    //                         ),
    //                       ],
    //                     ),
    //                   ],
    //                 ),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   );
    // }
  }
}
