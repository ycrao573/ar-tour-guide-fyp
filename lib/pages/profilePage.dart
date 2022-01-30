import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wikitude_flutter_app/pages/achievementScreen.dart';
import 'package:wikitude_flutter_app/pages/loginPage.dart';
import 'package:wikitude_flutter_app/pages/settingsPage.dart';
import 'package:wikitude_flutter_app/service/googleSignIn.dart';
import 'package:wikitude_flutter_app/widgets/counter.dart';

class ProfilePage extends StatefulWidget {
  final String iconlink;
  final String name;
  final String email;
  final String loginMethod;

  const ProfilePage(
      {Key? key,
      required this.iconlink,
      required this.name,
      required this.email,
      required this.loginMethod})
      : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                "https://images.unsplash.com/photo-1516685304081-de7947d419d5?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTN8fHRyYXZlbGVyfGVufDB8fDB8fA%3D%3D&w=1000&q=80"),
            colorFilter: ColorFilter.mode(Colors.black12, BlendMode.srcATop),
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
                SizedBox(
                  height: 69,
                ),
                SizedBox(
                  height: 80,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40.0),
                    child: Image(
                      image: NetworkImage(widget.iconlink),
                    ),
                  ),
                ),
                SizedBox(height: 8.0),
                Text(widget.name,
                    style: TextStyle(
                        fontSize: 17.5,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                SizedBox(height: 2.0),
                Text(widget.email,
                    style: TextStyle(fontSize: 14, color: Colors.white)),
                SizedBox(height: 12.0),
                SizedBox(
                    height: 34,
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellow[700]),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18.0),
                            ))),
                        onPressed: () => {},
                        child: Text("View Full Profile"))),
                SizedBox(height: 12.0),
                Divider(color: Colors.amberAccent),
                SizedBox(height: 12.0),
                SizedBox(
                  height: 45,
                  width: 330,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.yellow),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        )),
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AchievementScreen(
                                icon: widget.iconlink, name: widget.name))),
                    icon: FaIcon(FontAwesomeIcons.trophy,
                        color: Colors.orange[700], size: 18),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text("Achievement",
                          style: TextStyle(
                              fontSize: 16.5,
                              color: Colors.orange[900],
                              fontWeight: FontWeight.w600)),
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                SizedBox(
                  height: 45,
                  width: 330,
                  child: ElevatedButton.icon(
                      style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xd2ffffff)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          )),
                      onPressed: () => {},
                      icon: Icon(
                        Icons.star,
                        size: 24,
                        color: Colors.yellow[700],
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("Saved", style: TextStyle(fontSize: 16)),
                      )),
                ),
                SizedBox(height: 12.0),
                SizedBox(
                    height: 45,
                    width: 330,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xd2ffffff)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          )),
                      onPressed: () => {},
                      icon: FaIcon(FontAwesomeIcons.solidHeart,
                          size: 20, color: Colors.red),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child:
                            Text(" Favorites", style: TextStyle(fontSize: 16)),
                      ),
                    )),
                SizedBox(height: 12.0),
                SizedBox(
                    height: 45,
                    width: 330,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xd2ffffff)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          )),
                      onPressed: () => {},
                      icon: Icon(
                        Icons.support_agent,
                        color: Colors.greenAccent[700],
                      ),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("Help & Support",
                            style: TextStyle(fontSize: 16)),
                      ),
                    )),
                SizedBox(height: 12.0),
                SizedBox(
                  height: 45,
                  width: 330,
                  child: ElevatedButton.icon(
                    style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        backgroundColor:
                            MaterialStateProperty.all(Color(0xd2ffffff)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        )),
                    onPressed: () => {
                      Share.share(
                          'Check out my GitHub page! https://github.com/ycrao573')
                    },
                    icon: Icon(Icons.person_add, color: Colors.indigo),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0),
                      child: Text("Invite a Friend",
                          style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ),
                SizedBox(height: 12.0),
                SizedBox(
                    height: 45,
                    width: 330,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                          alignment: Alignment.centerLeft,
                          backgroundColor:
                              MaterialStateProperty.all(Color(0xd2ffffff)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                          )),
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SettingPage())),
                      icon: Icon(Icons.settings),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("Settings", style: TextStyle(fontSize: 16)),
                      ),
                    )),
                SizedBox(height: 12.0),
                SizedBox(
                    height: 45,
                    width: 330,
                    child: ElevatedButton.icon(
                      style: ButtonStyle(
                        alignment: Alignment.centerLeft,
                        backgroundColor:
                            MaterialStateProperty.all(Colors.redAccent[100]),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                      ),
                      onPressed: () => (widget.loginMethod != "Google")
                          ? logout(context)
                          : google_logout(context),
                      icon: Icon(Icons.exit_to_app, color: Colors.red[900]),
                      label: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text("Sign Out",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[900])),
                      ),
                    )),
                SizedBox(height: 12.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }

  Future<void> google_logout(BuildContext context) async {
    final provider = Provider.of<GoogleSignInProvider>(context, listen: false);
    provider.logout();
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
