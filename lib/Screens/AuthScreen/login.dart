import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:venti/Providers/auth_provider.dart';
import 'package:venti/Screens/AuthScreen/register.dart';
import 'package:venti/Screens/AuthScreen/reset.dart';
import 'package:venti/Screens/MainPages/home_page.dart';
import 'package:venti/utils.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          // decoration: BoxDecoration(color: Colors.purple),
          child: Column(
            children: [
              const SizedBox(
                height: 100,
              ),
              Text(
                "Continue to your account",
                style: TextStyle(color: Colors.white, fontSize: 17),
              ),
              const SizedBox(
                height: 100,
              ),
              Expanded(
                child: Container(
                    padding: const EdgeInsets.all(30.0),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      // color: Colors.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            CustomTextField(
                              _emailController,
                              backgroundColor: Colors.purple,
                              hint: 'Email',
                              password: false,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CustomTextField(
                              _passwordController,
                              backgroundColor: Colors.purple,
                              hint: 'Password',
                              obscure: true,
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            GestureDetector(
                              onTap: () {
                                //Forgot Password Page
                                PageRouter(context)
                                    .openNextPage(page: ResetPage());
                              },
                              child: Container(
                                  alignment: Alignment.centerRight,
                                  child:
                                      const Text("Can't remember password?")),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            if (_emailController.text.isEmpty ||
                                _passwordController.text.isEmpty) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Email or password is empty"),
                                ),
                              );
                            } else {
                              setState(() {
                                _isLoading = true;
                              });

                              AuthClass()
                                  .signInUser(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim())
                                  .then((value) {
                                if (value != "Login Sucessfully") {
                                  setState(() {
                                    _isLoading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value),
                                    ),
                                  );
                                } else {
                                  setState(() {
                                    _isLoading = false;
                                  });

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(value),
                                    ),
                                  );

                                  Future.delayed(Duration(seconds: 2), () {
                                    PageRouter(context)
                                        .openNextAndClearPrevious(
                                            page: HomePage());
                                  });
                                }
                              });
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(15.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: Colors.purple,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: _isLoading == false
                                ? Text(
                                    "Login",
                                    style: TextStyle(color: Colors.white),
                                    textAlign: TextAlign.center,
                                  )
                                : Center(
                                    child: CircularProgressIndicator(
                                      backgroundColor: Colors.purple,
                                    ),
                                  ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            //Navigate to Register Page
                            PageRouter(context)
                                .openNextPage(page: RegisterPage());
                          },
                          child: Text(
                            "Want to join?",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
