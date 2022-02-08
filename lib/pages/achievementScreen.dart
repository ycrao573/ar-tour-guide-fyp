import 'package:flutter/material.dart';
import 'package:googleapis/drive/v2.dart';
import 'package:wikitude_flutter_app/widgets/counter.dart';

class AchievementScreen extends StatefulWidget {
  final String icon;
  final String name;

  const AchievementScreen({Key? key, required this.icon, required this.name})
      : super(key: key);

  @override
  _AchievementScreenState createState() => _AchievementScreenState();
}

class _AchievementScreenState extends State<AchievementScreen> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            title: Text("Achievement")),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/achievement-bg.png"),
              colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.16), BlendMode.srcATop),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 90),
                SizedBox(
                  height: 76,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(38.0),
                    child: Image(
                      image: NetworkImage(widget.icon),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(widget.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 15.0),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white70,
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(0, 2),
                          blurRadius: 3,
                          color: Colors.black38,
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Counter(
                              color: Colors.pink,
                              number: 7,
                              title: "Countries",
                            ),
                            Counter(
                              color: Colors.teal,
                              number: 26,
                              title: "Cities",
                            ),
                            Counter(
                              color: Colors.amberAccent,
                              number: 3,
                              title: "Badges",
                            ),
                          ],
                        ),
                      ],
                    )),
                SizedBox(height: 15.0),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            gotoSelectedPage(0);
                          },
                          child: Text('Achievements Medal'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            gotoSelectedPage(1);
                          },
                          child: Text('Cities Medal'),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 300.0,
                      child: SafeArea(
                        child: Container(child: new OrientationBuilder(
                            builder: (context, orientation) {
                          return PageView(
                            controller: _pageController,
                            children: <Widget>[
                              AchievedBadgeList(),
                              CitiesBadgeList(),
                            ],
                          );
                        })),
                      ),
                    ),
                  ],
                )
              ],
            )),
          ),
        ));
  }

  gotoSelectedPage(int i) {
    if (_pageController.hasClients) {
      _pageController.animateToPage(
        i,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
    // return Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //     builder: (context) => Container(height: 20, child: Text(i.toString())),
    //   ),
    // );
  }
}

class AchievedBadgeList extends StatelessWidget {
  const AchievedBadgeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://flagcdn.com/w320/sg.jpg"),
                      radius: 38.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://flagcdn.com/w320/cn.jpg"),
                      radius: 38.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://flagcdn.com/w320/gb.jpg"),
                      radius: 38.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CitiesBadgeList extends StatelessWidget {
  const CitiesBadgeList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: CustomScrollView(
        primary: false,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverGrid.count(
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 3,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://flagcdn.com/w320/my.jpg"),
                      radius: 38.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://flagcdn.com/w320/fr.jpg"),
                      radius: 38.0,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey[300],
                    radius: 60.0,
                    child: CircleAvatar(
                      backgroundImage:
                          NetworkImage("https://flagcdn.com/w320/de.jpg"),
                      radius: 38.0,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
