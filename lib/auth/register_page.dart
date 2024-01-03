import 'package:app_3/auth/loginpage.dart';
import 'package:app_3/helper/helper_functions.dart';
import 'package:app_3/pages/homepage.dart';
import 'package:app_3/services/auth_service.dart';
import 'package:app_3/widgets/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class Register_page extends StatefulWidget {
  const Register_page({Key? key}) : super(key: key);

  @override
  State<Register_page> createState() => _Register_pageState();
}

class _Register_pageState extends State<Register_page> {
  bool _isloading = false;
  final formkey = GlobalKey<FormState>();
  String email = "";
  String password = "";
  String fullname = "";
  AuthService authService = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _isloading
            ? Center(
                child: CircularProgressIndicator(
                color: Colors.blue,
              ))
            : SingleChildScrollView(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
                  child: Form(
                    key: formkey,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          const Text(
                            "Groupie",
                            style: TextStyle(
                                fontSize: 45, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Create a account to exploere and chat with your friends",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w400),
                          ),
                          Image.asset("assets/register page.png"),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Full_name",
                                prefix: Icon(
                                  Icons.people,
                                  color: Color.fromARGB(255, 26, 117, 222),
                                )),
                            onChanged: (val) {
                              setState(() {
                                fullname = val;
                                print(fullname);
                              });
                            },
                            validator: (val) {
                              if (val!.isNotEmpty) {
                                return null;
                              } else {
                                return "name cannot be empty";
                              }
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            decoration: textInputDecoration.copyWith(
                                labelText: "Email",
                                prefix: Icon(
                                  Icons.email_rounded,
                                  color: Color.fromARGB(255, 26, 117, 222),
                                )),
                            onChanged: (val) {
                              setState(() {
                                email = val;
                                print(email);
                              });
                            },
                            validator: (val) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(val!)
                                  ? null
                                  : "Please enter a valid email";
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          TextFormField(
                            obscureText: true,
                            decoration: textInputDecoration.copyWith(
                                labelText: "password",
                                prefix: Icon(
                                  Icons.lock,
                                  color: Color.fromARGB(255, 26, 117, 222),
                                )),
                            validator: (val) {
                              if (val!.length < 6) {
                                return "Password must atleast 6 characters";
                              }
                            },
                            onChanged: (val) {
                              setState(() {
                                password = val;
                                print(password);
                              });
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30))),
                              child: const Text(
                                "Register",
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                register();
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text.rich(TextSpan(
                              text: "Already have a Acccount?",
                              style:
                                  TextStyle(color: Colors.black, fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "Login here",
                                    style: const TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        nextscreeen(context, const LoginPage());
                                      }),
                              ]))
                        ]),
                  ),
                ),
              ));
  }

  register() async {
    if (formkey.currentState!.validate()) {
      setState(() {
        _isloading = true;
      });
      await AuthService()
          .registerUserWithEmailandPassword(fullname, email, password)
          .then((value) async {
        if (value == true) {
          // saving the shared preferencees state
          await HelperFunctions.saveUserLoggedInStatus(true);
          await HelperFunctions.saveUserEmailSF(email);
          await HelperFunctions.saveUserNameSF(fullname);
          nextscreeen(context, HomePage());
        } else {
          showSnackbar(context, Colors.red, value);
          setState(() {
            _isloading = false;
          });
        }
      });
    }
    ;
  }
}
