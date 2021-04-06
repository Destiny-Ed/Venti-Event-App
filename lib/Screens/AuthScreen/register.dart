import 'package:flutter/material.dart';
import 'package:flutter_text_form_field/flutter_text_form_field.dart';
import 'package:venti/Providers/auth_provider.dart';
import 'package:venti/Screens/AuthScreen/login.dart';
import 'package:venti/Screens/MainPages/home_page.dart';
import 'package:venti/utils.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
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
                "Create a Venti account",
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
                              hint: 'Email',
                              backgroundColor: Colors.purple,
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
                                  .createUser(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text.trim())
                                  .then((value) {
                                if (value != "Account Created Successfully") {
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
                                      "Create account",
                                      style: TextStyle(color: Colors.white),
                                      textAlign: TextAlign.center,
                                    )
                                  : Center(
                                      child: CircularProgressIndicator(
                                        backgroundColor: Colors.purple,
                                      ),
                                    )),
                        ),
                        GestureDetector(
                          onTap: () {
                            //Navigate to Login Page
                            PageRouter(context).openNextPage(page: LoginPage());
                          },
                          child: Text(
                            "Already have account?",
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
