import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wikitude_flutter_app/widgets/myheader.dart';

class CovidInfoScreen extends StatefulWidget {
  const CovidInfoScreen({Key? key}) : super(key: key);

  @override
  _CovidInfoScreenState createState() => _CovidInfoScreenState();
}

class _CovidInfoScreenState extends State<CovidInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            MyHeader(
              image: "assets/icons/coronadr.svg",
              textTop: "Get to know",
              textBottom: "About Covid-19.",
              offset: 10.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Symptoms",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SymptomCard(
                          image: "assets/images/headache.png",
                          title: "Headache",
                          isActive: true,
                        ),
                        SymptomCard(
                          image: "assets/images/caugh.png",
                          title: "Caugh",
                        ),
                        SymptomCard(
                          image: "assets/images/fever.png",
                          title: "Fever",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Prevention",
                    style: TextStyle(
                      fontFamily: "Poppins",
                      fontSize: 16.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 20),
                  PreventCard(
                    text:
                        "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                    image: "assets/images/wear_mask.png",
                    title: "Wear face mask",
                  ),
                  PreventCard(
                    text:
                        "Since the start of the coronavirus outbreak some places have fully embraced wearing facemasks",
                    image: "assets/images/wash_hands.png",
                    title: "Wash your hands",
                  ),
                  SizedBox(height: 50),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class PreventCard extends StatelessWidget {
  final String image;
  final String title;
  final String text;
  const PreventCard({
    Key? key,
    required this.image,
    required this.title,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 156,
        child: Stack(
          alignment: Alignment.centerLeft,
          children: <Widget>[
            Container(
              height: 136,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
            Image.asset(image),
            Positioned(
              left: 130,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                height: 136,
                width: MediaQuery.of(context).size.width - 170,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      title,
                    ),
                    Expanded(
                      child: Text(
                        text,
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: SvgPicture.asset("assets/icons/forward.svg"),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SymptomCard extends StatelessWidget {
  final String image;
  final String title;
  final bool isActive;
  const SymptomCard({
    Key? key,
    required this.image,
    required this.title,
    this.isActive = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          Image.asset(image, height: 75),
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
