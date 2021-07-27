import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flash_chat/screens/registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class LoginScreen extends StatefulWidget {
  static const String id = "login_screen";
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool showspinner = false;
  String errorMessage = '';
  int passwordLength;
  int emailLength;
  final _auth = FirebaseAuth.instance;
  String email;
  String password;
  TextButton button;

  errorButton() {
    if (errorMessage == 'User Not Found To Register') {
      return ErrorButton(route: RegistrationScreen.id, text: 'Click Here.');
    } else {
      return Container(
        child: Text(''),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showspinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              SizedBox(
                height: 48.0,
              ),
              TextField(
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    email = value;
                    emailLength = value.length;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter Your Email')),
              SizedBox(
                height: 8.0,
              ),
              TextField(
                  obscureText: true,
                  textAlign: TextAlign.center,
                  onChanged: (value) {
                    password = value;
                    passwordLength = value.length;
                  },
                  decoration: kTextFieldDecoration.copyWith(
                      hintText: 'Enter your password.')),
              Container(
                child: Row(
                  children: [
                    Text(
                      '$errorMessage',
                      style: TextStyle(color: Colors.red),
                    ),
                    errorButton(),
                  ],
                ),
              ),
              SizedBox(
                height: 24.0,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Material(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                  elevation: 5.0,
                  child: MaterialButton(
                    onPressed: () async {
                      print(emailLength);
                      setState(() {
                        showspinner = true;
                      });
                      try {
                        final loginUser =
                            await _auth.signInWithEmailAndPassword(
                                email: email, password: password);
                        if (loginUser != null) {
                          Navigator.pushNamed(context, ChatScreen.id);
                        }
                        setState(() {
                          showspinner = false;
                        });
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'invalid-email' ||
                            emailLength == null ||
                            passwordLength == null) {
                          errorMessage = 'Incorrect Email id or Password';
                          setState(() {
                            showspinner = false;
                          });
                        } else if (e.code == 'user-not-found') {
                          errorMessage = 'User Not Found To Register';
                          setState(() {
                            showspinner = false;
                          });
                        } else if (e.code == 'wrong-password') {
                          errorMessage = 'Invalid Password Try Again';
                          print('passw incoreect');
                          setState(() {
                            showspinner = false;
                          });
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: Text(
                      'Log In',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ErrorButton extends StatelessWidget {
  ErrorButton({@required this.route, @required this.text});
  final String route;
  final String text;

  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () => Navigator.pushNamed(context, RegistrationScreen.id),
        child: Text('$text'));
  }
}
