import 'package:flutter/material.dart';
import 'package:rebel_girls/resources/auth_methods.dart';
import 'package:rebel_girls/responsive/mobile_screen_layout.dart';
import 'package:rebel_girls/responsive/responsive_layout_screen.dart';
import 'package:rebel_girls/responsive/web_screen_layout.dart';
import 'package:rebel_girls/screens/signup_screen.dart';
import 'package:rebel_girls/utils/colors.dart';
import 'package:rebel_girls/utils/utils.dart';
import 'package:rebel_girls/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  void loginUser() async {
    setState(() {
      _isLoading = true;
    });

    String res = await AuthMethods().loginUser(
        email: _emailController.text, password: _passwordController.text);
    if (res == "success") {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const ResponsiveLayout(
                mobileScreenLayout: MobileScreenLayout(),
                webScreenLayout: WebScreenLayout(),
              )));
    } else {
      showSnackBar(res, context);
    }
    setState(() {
      _isLoading = false;
    });
  }

  void navigatetoSignup() {
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration:
              const BoxDecoration(color: Color.fromARGB(255, 240, 240, 240)),
          padding: const EdgeInsets.symmetric(horizontal: 10),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(
                child: Container(),
                flex: 2,
              ),
              Card(
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      const Text(
                        'Rebel Girls',
                        style: TextStyle(
                            color: Colors.black,
                            fontFamily: 'Pacifico',
                            fontSize: 45),
                      ),
                      // text field input for email
                      const SizedBox(
                        height: 64,
                      ),
                      TextFieldInput(
                          textEditingController: _emailController,
                          hintText: 'Enter your email',
                          textInputType: TextInputType.emailAddress),
                      const SizedBox(
                        height: 24,
                      ),
                      // text field input for password
                      TextFieldInput(
                        textEditingController: _passwordController,
                        hintText: 'Enter your password',
                        textInputType: TextInputType.text,
                        isPass: true,
                      ),
                      const SizedBox(
                        height: 24,
                      ),
                      // button login
                      InkWell(
                        onTap: loginUser,
                        child: Container(
                          child: _isLoading
                              ? const Center(
                                  child: CircularProgressIndicator(
                                    color: whiteColor,
                                  ),
                                )
                              : const Text(
                                  'Log in',
                                  style: TextStyle(color: Colors.white),
                                ),
                          width: double.infinity,
                          alignment: Alignment.center,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: const ShapeDecoration(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(4),
                              ),
                            ),
                            color: primaryButtonColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // svg image

              const SizedBox(
                height: 12,
              ),
              Flexible(
                child: Container(),
                flex: 2,
              ),
              // Transitionong to signin up
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: const Text("Don't have an account?"),
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                  GestureDetector(
                    onTap: navigatetoSignup,
                    child: Container(
                      child: const Text(
                        "Sign up",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
