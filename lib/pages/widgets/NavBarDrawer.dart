import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../Services/Authentication.dart';
import '../Auth/forgot_password_page.dart';
import '../Auth/forgot_password_verification_page.dart';
import '../common/login_page.dart';
import '../Donor/profile_page.dart';
import '../common/registration_page.dart';
import '../common/splash_screen.dart';

class NavBarDrawer extends StatelessWidget {
  NavBarDrawer({
    Key? key,
  }) :  super(key: key);

  final User user=FirebaseAuth.instance.currentUser!;
  double _drawerIconSize = 24;
  double _drawerFontSize = 17;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [
                  0.0,
                  1.0
                ],
                colors: [
                  Theme.of(context).primaryColor.withOpacity(0.2),
                  Theme.of(context).hintColor.withOpacity(0.5),
                ])),
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.0, 1.0],
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).hintColor,
                  ],
                ),
              ),
              child: Container(
                alignment: Alignment.bottomLeft,
                child: Text(
                  user.email!,
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            ListTile(
              leading: Icon(
                Icons.screen_lock_landscape_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Splash Screen',
                style: TextStyle(
                    fontSize: 17, color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            SplashScreen(title: "Splash Screen")));
              },
            ),
            ListTile(
              leading: Icon(Icons.login_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor),
              title: Text(
                'Profile',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProfilePage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.login_rounded,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor),
              title: Text(
                'Login Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(Icons.person_add_alt_1,
                  size: _drawerIconSize,
                  color: Theme.of(context).hintColor),
              title: Text(
                'Registration Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.password_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Forgot Password Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.verified_user_sharp,
                size: _drawerIconSize,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Verification Page',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ForgotPasswordVerificationPage()),
                );
              },
            ),
            Divider(
              color: Theme.of(context).primaryColor,
              height: 1,
            ),
            ListTile(
              leading: Icon(
                Icons.logout_rounded,
                size: _drawerIconSize,
                color: Theme.of(context).hintColor,
              ),
              title: Text(
                'Logout',
                style: TextStyle(
                    fontSize: _drawerFontSize,
                    color: Theme.of(context).hintColor),
              ),
              onTap: () => Authentication().signOut(),
            ),
          ],
        ),
      ),
    );
  }
}