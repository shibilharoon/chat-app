import 'package:chathub/controller/auth_provider.dart';
import 'package:chathub/view/pages/homescreen.dart';
import 'package:chathub/view/pages/initial_page.dart';
import 'package:chathub/view/pages/phone_login_screen.dart';
import 'package:chathub/view/pages/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Image.asset(
              "assets/images/bgimg.jpg",
              fit: BoxFit.cover,
            ),
          ),
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.black.withOpacity(0.7),
                  Colors.black.withOpacity(0.9),
                  Colors.black.withOpacity(1),
                ])),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 50),
          //   child: IconButton(
          //       onPressed: () {
          //         Navigator.of(context).push(
          //             MaterialPageRoute(builder: (context) => const InitialPage()));
          //       },
          //       icon: const Icon(
          //         Icons.arrow_back_ios_new,
          //         color: Colors.white,
          //       )),
          // ),
          Padding(
            padding: const EdgeInsets.only(top: 200, left: 20, right: 200),
            child: Text(
              "Easy Safe Secure",
              style: GoogleFonts.comfortaa(fontSize: 35, color: Colors.white),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 380, left: 20, right: 20),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                        hintText: "E-mail",
                        hintStyle:
                            const TextStyle(color: Color.fromARGB(184, 0, 0, 0)),
                        prefixIcon: const Icon(Icons.email),
                        prefixIconColor: const Color.fromARGB(175, 209, 206, 206),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: passwordController,
                    decoration: InputDecoration(
                        hintText: "Password",
                        hintStyle:
                            const TextStyle(color: Color.fromARGB(171, 0, 0, 0)),
                        prefixIcon: const Icon(Icons.star),
                        prefixIconColor: const Color.fromARGB(172, 188, 185, 185),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                              color: Color.fromARGB(255, 255, 255, 255)),
                          borderRadius: BorderRadius.circular(30),
                        )),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: signIn,
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 167, 15, 15),
                          borderRadius: BorderRadius.circular(30)),
                      child: const Center(
                          child: Text(
                        "Login",
                        style: TextStyle(color: Colors.white),
                      )),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(),
                  // Text(
                  //   "OR",
                  //   style: TextStyle(
                  //       fontSize: 15, color: Color.fromARGB(218, 255, 255, 255)),
                  // ),
                  // Divider(),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 78),
                    child: Consumer<AuthProviders>(
                      builder: (context, value, child) {
                        return Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                value.singupWithGoogle();
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(FontAwesomeIcons.google),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => PhoneLoginScreen()));
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(FontAwesomeIcons.phone),
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            GestureDetector(
                              onTap: () {
                                value.signInWithGithub(context);
                              },
                              child: Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: const Icon(FontAwesomeIcons.github),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 64),
                    child: Row(
                      children: [
                        Text(
                          "Don't have an account?",
                          style: GoogleFonts.comfortaa(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                          },
                          child: Text(
                            " Sign up",
                            style: GoogleFonts.comfortaa(color: Colors.blue),
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  void signIn() async {
    final signInServices = Provider.of<AuthProviders>(context, listen: false);
    String email = emailController.text;
    String password = passwordController.text;
    User? user = await signInServices.signInWithEmail(email, password, context);
    if (user != null) {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const HomeScreen()));
    } else {
      print('there is some error ');
    }
  }
}
