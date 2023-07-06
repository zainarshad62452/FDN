import 'package:fdn/pages/widgets/loading.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

import '../../Controllers/loading.dart';
import '../../Services/Authentication.dart';
import '../../Services/Reception.dart';
import '../common/theme_helper.dart';
import '../Donor/profile_page.dart';
import '../widgets/header_widget.dart';
import '../widgets/snackbar.dart';

class EmailVerification extends StatefulWidget {
  const EmailVerification({Key? key}) : super(key: key);

  @override
  _ForgotPasswordVerificationPageState createState() => _ForgotPasswordVerificationPageState();
}

class _ForgotPasswordVerificationPageState extends State<EmailVerification> {
  final _formKey = GlobalKey<FormState>();
  bool _pinSuccess = false;

  @override
  Widget build(BuildContext context) {
    double _headerHeight = 300;

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
                    child: HeaderWidget(
                        _headerHeight, true, Icons.privacy_tip_outlined),
                  ),
                  SafeArea(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
                      padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.topLeft,
                            margin: EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Verification',
                                  style: TextStyle(
                                      fontSize: 35,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54
                                  ),
                                  // textAlign: TextAlign.center,
                                ),
                                SizedBox(height: 10,),
                                Text(
                                  'A verification Email is sent you on your email address ${FirebaseAuth.instance.currentUser!.email} \nIf you unable to find in mail check the spam folder or resend again.',
                                  style: TextStyle(
                                    // fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black54
                                  ),
                                  // textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40.0),
                          Form(
                            key: _formKey,
                            child: Column(
                              children: <Widget>[
                                SizedBox(height: 50.0),
                                Text.rich(
                                  TextSpan(
                                    children: [
                                      TextSpan(
                                        text: "If you didn't receive a mail! ",
                                        style: TextStyle(
                                          color: Colors.black38,
                                        ),
                                      ),
                                      TextSpan(
                                        text: 'Resend',
                                        recognizer: TapGestureRecognizer()
                                          ..onTap = () async {
                                          loading(true);
                                            try{
                                              final auth = FirebaseAuth.instance.currentUser!;
                                              await auth.sendEmailVerification().then((value) {
                                                snackbar("Success", "Verification send to ${auth.email}");
                                                loading(false);
                                              }).onError((error, stackTrace) {
                                                loading(false);
                                                alertSnackbar('Unable to send email');
                                              });
                                            }catch(e){
                                              loading(false);
                                              alertSnackbar('$e');
                                            }
                                          },
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.orange
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 40.0),
                                Container(
                                  decoration: ThemeHelper().buttonBoxDecoration(context),
                                  child: ElevatedButton(
                                    style: ThemeHelper().buttonStyle(),
                                    child: Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          40, 10, 40, 10),
                                      child: Text(
                                        "Verify".toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    onPressed: ()async {
                                      loading(true);
                                  final auth = FirebaseAuth.instance.currentUser!;
                                       await auth.reload();
                                       if (auth.emailVerified) {
                                            Reception().userReception();
                                      }else{
                                         alertSnackbar('Not Verified!\nCheck your Email again\n Also check spam folder');
                                         loading(false);
                                       }
                                    }
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 50.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.logout,color: Colors.black,size: 20.0,),
                              ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                  onPressed: (){
                                  Authentication().signOut();
                                  },
                                  child: Text('Logout')),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            )
        )
            :LoadingWidget(),
        LoadingWidget()
      ],
    );
  }
}

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:sizer/sizer.dart';
// import '../../Services/Reception.dart';
// import '../widgets/snackbar.dart';
//
// class EmailVerification extends StatelessWidget {
//
//   @override
//   Widget build(BuildContext context) {
//
//     // return Scaffold(
//     //
//     //     body: Column(
//     //       mainAxisAlignment: MainAxisAlignment.center,
//     //       crossAxisAlignment: CrossAxisAlignment.center,
//     //       children: [
//     //         Text(
//     //             "Verification email is sent to ${FirebaseAuth.instance.currentUser!.email} \nPlease verify that email in your inbox and then refresh",
//     //             textAlign: TextAlign.center),
//     //         SizedBox(height: 4.h),
//     //         Text("If you can't find this email please check your SPAM",
//     //             style: TextStyle(color: Colors.red)),
//     //         SizedBox(height: 4.h),
//     //         MaterialButton(
//     //             child:Text("Refresh"), onPressed: () async {
//     //           final auth = FirebaseAuth.instance.currentUser!;
//     //           await auth.reload();
//     //           if (auth.emailVerified) {
//     //             Reception().userReception();
//     //           }
//     //         }),
//     //         SizedBox(height: 4.h),
//     //         MaterialButton(child:Text("Resend"),onPressed:  () async {
//     //           final auth = FirebaseAuth.instance.currentUser!;
//     //           await auth.sendEmailVerification();
//     //           snackbar("Success", "Verification send to ${auth.email}");
//     //         }),
//     //         SizedBox(height: 4.h),
//     //       ],
//     //     ));
//   }
// }
