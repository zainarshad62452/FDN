import 'package:email_validator/email_validator.dart';
import 'package:fdn/pages/widgets/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/get_utils/get_utils.dart';

import '../../Controllers/loading.dart';
import '../../Services/Authentication.dart';
import '../common/theme_helper.dart';
import '../widgets/loading.dart';
import 'forgot_password_page.dart';

import '../common/login_page.dart';
import '../widgets/header_widget.dart';

class SignupPage extends StatefulWidget {
  bool isDonor;
  bool isVolunteer;
   SignupPage({Key? key, required this.isDonor,required this.isVolunteer}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repasswordController = TextEditingController();
  final TextEditingController name = TextEditingController();
  final TextEditingController address = TextEditingController();
  final TextEditingController contactNo = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  double _headerHeight = 250;
  Key _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        !loading()?
        Scaffold(
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: _headerHeight,
                  child: HeaderWidget(_headerHeight, true,
                      Icons.login_rounded), //let's create a common header widget
                ),
                SafeArea(
                  child: Container(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      margin: EdgeInsets.fromLTRB(
                          20, 10, 20, 10), // This will be the login form
                      child: Column(
                        children: [
                          Text(
                            'Hello',
                            style: TextStyle(
                                fontSize: 60, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Sign up for your account',
                            style: TextStyle(color: Colors.grey),
                          ),
                          SizedBox(height: 30.0),
                          Form(
                              key: formKey,
                              child: Column(
                                children: [
                                  Container(
                                    child: TextFormField(
                                      controller: name,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Name', 'Enter your name'),
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                    ),
                                    decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    child: TextFormField(
                                      controller: emailController,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Email', 'Enter your email'),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (email) => email != null &&
                                              !EmailValidator.validate(email)
                                          ? 'Enter a valid email'
                                          : null,
                                    ),
                                    decoration:
                                        ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    child: TextFormField(
                                      controller: contactNo,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Contact', 'Enter your Contact No'),
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                    ),
                                    decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),Container(
                                    child: TextFormField(
                                      controller: address,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Address', 'Enter your address'),
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                    ),
                                    decoration:
                                    ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    child: TextFormField(
                                      controller: passwordController,
                                      obscureText: true,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Password', 'Enter your password'),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 6
                                              ? 'Enter min. 6 characters'
                                              : null,
                                    ),
                                    decoration:
                                        ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 30.0),
                                  Container(
                                    child: TextFormField(
                                      controller: repasswordController,
                                      obscureText: true,
                                      decoration: ThemeHelper().textInputDecoration(
                                          'Confirm Password',
                                          'Enter your password'),
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      validator: (value) =>
                                          value != null && value.length < 6
                                              ? 'Enter min. 6 characters'
                                              : null,
                                    ),
                                    decoration:
                                        ThemeHelper().inputBoxDecorationShaddow(),
                                  ),
                                  SizedBox(height: 15.0),
                                  Container(
                                    decoration:
                                        ThemeHelper().buttonBoxDecoration(context),
                                    child: ElevatedButton(
                                      style: ThemeHelper().buttonStyle(),
                                      child: Padding(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: Text(
                                          'Sign Up'.toUpperCase(),
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ),
                                      ),
                                      onPressed: () async {
                                        FocusScope.of(context).unfocus();

                                        if(formValidation()) {
                                            Authentication().createAccount(
                                                name: name.text.trim(),
                                                email: emailController.text.trim(),
                                                pass:
                                                    passwordController.text.trim(),
                                                contactNo: contactNo.text.trim(),
                                                address: address.text, isDonor: widget.isDonor,isVolunteer: widget.isVolunteer);
                                        }
                                      },
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.fromLTRB(10, 20, 10, 20),
                                    //child: Text('Don\'t have an account? Create'),
                                    child: Text.rich(TextSpan(children: [
                                      TextSpan(text: "Already have an account? "),
                                      TextSpan(
                                        text: 'Login',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        LoginPage()));
                                          },
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).hintColor),
                                      ),
                                    ])),
                                  ),
                                ],
                              )),
                        ],
                      )),
                ),
              ],
            ),
          ),
        )
            :LoadingWidget(),
        LoadingWidget(),
      ],
    );
  }
  bool formValidation() {
    if (name.text.isEmpty || passwordController.text.isEmpty) {
      alertSnackbar("All fields are required");
      return false;
    } else if (!GetUtils.isEmail(emailController.text)) {
      alertSnackbar("Email is not valid");
      return false;
    } else if (passwordController.text.length < 6) {
      alertSnackbar("Password must be of atleast 6 charachters");
      return false;
    }  else
      return true;
  }
}
