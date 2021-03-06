import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_button/sign_button.dart';
import 'package:travelee/pages/registrationPage.dart';
import 'package:travelee/service/googleSignIn.dart';
import 'homePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // form key
  final _formKey = GlobalKey<FormState>();

  // editing controller
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  // firebase
  final _auth = FirebaseAuth.instance;

  // string for displaying the error Message
  String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        style: TextStyle(fontSize: 15),
        onSaved: (value) {
          emailController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password (Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value!;
        },
        style: TextStyle(fontSize: 15),
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = SignInButton(
        buttonType: ButtonType.mail,
        btnColor: Color(0xff85ccd8),
        btnText: "Sign In with Email",
        padding: 10,
        onPressed: () {
          signIn(emailController.text, passwordController.text);
        });
    // Material(
    //   elevation: 5,
    //   borderRadius: BorderRadius.circular(30),
    //   color: Colors.pink[600],
    //   child: MaterialButton(
    //       padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       minWidth: MediaQuery.of(context).size.width,
    //       onPressed: () {
    //         signIn(emailController.text, passwordController.text);
    //       },
    //       child: Text(
    //         "Sign In",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //             fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
    //       )),
    // );

    final googleLoginButton = SignInButton(
        buttonType: ButtonType.google,
        btnColor: Color(0xCC76A7FA),
        padding: 10,
        onPressed: () async {
          final provider =
              Provider.of<GoogleSignInProvider>(context, listen: false);
          await provider.googleLogin();
          Fluttertoast.showToast(msg: "Login Successful");
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) => HomePage(loginMethod: "Google")));
        });

    // Material(
    //   elevation: 5,
    //   borderRadius: BorderRadius.circular(30),
    //   color: Color(0xFF4285F4),
    //   child: MaterialButton(
    //       padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
    //       minWidth: MediaQuery.of(context).size.width,
    //       onPressed: () {
    //         signIn(emailController.text, passwordController.text);
    //       },
    //       child: Text(
    //         "Sign In with Google",
    //         textAlign: TextAlign.center,
    //         style: TextStyle(
    //             fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
    //       )),
    // );

    return Scaffold(
      backgroundColor: Color(0xffc1eaed),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Color(0xffc1eaed),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 180,
                        child: Image.asset(
                          "assets/images/logo.png",
                          fit: BoxFit.contain,
                        )),
                    Text(
                      "Travelee",
                      style: TextStyle(
                        fontFamily: 'Billabong',
                        fontSize: 46.0,
                      ),
                    ),
                    SizedBox(height: 40),
                    emailField,
                    SizedBox(height: 20),
                    passwordField,
                    SizedBox(height: 42),
                    loginButton,
                    SizedBox(height: 12),
                    googleLoginButton,
                    SizedBox(height: 22),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text("Don't have an account? "),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          RegistrationPage()));
                            },
                            child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Color(0xffe07e7d),
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14),
                            ),
                          )
                        ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
                  Fluttertoast.showToast(msg: "Login Successful"),
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => HomePage(loginMethod: "Email"))),
                });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";
            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}
