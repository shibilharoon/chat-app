import 'package:chathub/controller/firebase_provider.dart';
import 'package:chathub/services/auth_services.dart';
import 'package:chathub/view/pages/chat_page.dart';
import 'package:chathub/view/pages/login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    Provider.of<FirebaseProvider>(context, listen: false).getAllUsers();
  }

  FirebaseAuthServices service = FirebaseAuthServices();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Column(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.only(left: 320, right: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LoginPage()));
                      },
                      icon: const Icon(
                        Icons.logout,
                        color: Colors.white,
                      ))
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
            child: Consumer<FirebaseProvider>(
              builder: (context, values, child) => TextFormField(
                onChanged: (value) {
                  values.searchUser(value);
                },
                decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.circular(30)),
                    filled: true,
                    fillColor: const Color.fromARGB(255, 255, 255, 255),
                    hintText: 'Search ',
                    prefixIcon: const Icon(Icons.search)),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Expanded(
            child: Container(
              width: size.width,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50))),
              child: Consumer<FirebaseProvider>(
                builder: (context, value, child) {
                  return ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: value.searchedusers.length,
                    itemBuilder: (context, index) {
                      final userdetails = value.searchedusers[index];

                      if (userdetails.uid !=
                          FirebaseAuth.instance.currentUser?.uid) {
                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                splashColor:
                                    const Color.fromRGBO(41, 15, 102, .3),
                                onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          ChatScreen(user: userdetails),
                                    )),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    radius: 35,
                                    backgroundImage:
                                        AssetImage("assets/images/user.jpg"),
                                  ),
                                  title: Text(
                                    userdetails.name ?? userdetails.email!,
                                    style: GoogleFonts.poppins(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  subtitle: const Text(
                                    " Tap to Chat",
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: Divider(
                                height: 1,
                                color: Colors.grey.withOpacity(0.5),
                              ),
                            )
                          ],
                        );
                      } else {
                        return const SizedBox();
                      }
                    },
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
