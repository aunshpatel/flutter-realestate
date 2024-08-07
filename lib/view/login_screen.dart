import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:realestate/view/widgets/rounded_buttons.dart';
import 'package:realestate/view/widgets/side_drawer.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../consts.dart';
import '../controllers/user_controller.dart';
import '../models/user_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String email = '', pwd = '';
  String loginEmailID = '', loginPassword = '';
  bool showSpinner = false;
  bool _passwordVisible = false;
  bool _isRememberMe = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        drawerEnableOpenDragGesture: true,
        drawer: const SideDrawer(),
        appBar: AppBar(
          leading: Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                color: kDarkTitleColor,
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              );
            },
          ),
          actions: <Widget>[

          ],
          centerTitle: true,
          title: const Wrap(
            children: [
              Text('Login ', style:TextStyle(color: kLightTitleColor),),
              Text('Screen', style:TextStyle(color: kDarkTitleColor),),
            ],
          ),
          backgroundColor: kBackgroundColor,
        ),
        body: Padding(
          padding: const EdgeInsets.only(left:24.0,right:24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 15.0,
              ),
              Flexible(
                child: HeroLogo(height:250,image:'images/realestate-high-resolution-logo.jpeg', tag:'photo'),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                onChanged:(value){
                  email = emailController.text;
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setString('email', email);
                  },);
                },
                style: const TextStyle(color: kThemeBlueColor),
                decoration: emailInputDecoration('Enter your email',),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextField(
                controller: passwordController,
                obscureText: _passwordVisible == false ? true : false,
                onChanged:(value){
                  pwd = passwordController.text;
                  SharedPreferences.getInstance().then((prefs) {
                    prefs.setString('password', pwd);
                  },);
                },
                style: const TextStyle(color: kThemeBlueColor),
                decoration: passwordInputDecoration(
                  'Enter your password',
                  _passwordVisible,
                      (){
                    setState(() {
                      _passwordVisible = !_passwordVisible;
                    });
                  }
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                colour:kDarkTitleColor,
                title:'Login',
                onPress:() async {
                  if(emailController.text != '' && passwordController.text != '') {
                    try{
                      final user = UserLogin(email: emailController.text, password: passwordController.text);
                      final success = await UserController.loginUser(user);
                      if (success == true){
                        setState(() {
                          isLoggedIn = true;
                        });
                        prefs.setBool('isLoggedIn', isLoggedIn);
                        _loginMessage();
                      }
                      else{
                        commonAlertBox(context, 'WARNING!', 'Your email id or password is incorrect, please try again!');
                      }
                      print("success login page try catch: $success");
                    } catch(e){
                      setState(() {
                        showSpinner = false;
                        isLoggedIn = false;
                      });
                      prefs.setBool('isLoggedIn', isLoggedIn);
                      return _showMyDialog('Warning!','${e.toString()}');
                    }
                  }
                  else if(passwordController.text.isEmpty && emailController.text.isNotEmpty){
                    _showMyDialog('Warning!','No password entered. Please enter the your password.');
                  }
                  else if(passwordController.text.isNotEmpty && emailController.text.isEmpty){
                    _showMyDialog('Warning!','No email id entered. Please enter your email id.');
                  }
                  else if(emailController.text.isEmpty && passwordController.text.isEmpty){
                    _showMyDialog('Warning!','Email and password fields are empty. Please enter both values to login.');
                  }
                  else if(emailController.text == '' && passwordController.text != ''){
                    _showMyDialog('Warning!','Please enter your email id to login.');
                  }
                  else if(emailController.text != '' && passwordController.text == ''){
                    _showMyDialog('Warning!','Please enter your password to login.');
                  }
                },
              ),
              RoundedButton(
                colour:kContinueWithGoogleButton,
                title:'Continue With Google',
                onPress:() async{}
              ),
            ],
          ),
        ),
      ),
    );
  }

  actionRememberMe(bool value) {
    _isRememberMe = value;
    SharedPreferences.getInstance().then((prefs) {
      prefs.setBool("remember_me", _isRememberMe);
    },);
    setState(() {
      _isRememberMe = value;
    });
  }

  autoLogin(bool autoLogin){
    if(autoLogin == true){
      actionRememberMe(true);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('autoLogin', autoLogin);
        setState(() {
          isRememberMeDisabled = true;
        });
        prefs.setBool('isRememberMeDisabled', isRememberMeDisabled);
      },);
    }
    else{
      actionRememberMe(true);
      SharedPreferences.getInstance().then((prefs) {
        prefs.setBool('autoLogin', autoLogin);
        setState(() {
          isRememberMeDisabled = false;
        });
        prefs.setBool('isRememberMeDisabled', isRememberMeDisabled);
      },);
    }
  }


  void _loadUserEmailPassword() async {
    try {
      prefs = await SharedPreferences.getInstance();
      loginEmailID = prefs.getString('email') ?? '';
      loginPassword = prefs.getString('password') ?? '';
      bool rememberMe = prefs.getBool('remember_me') ?? false;
      automaticLogin = prefs.getBool('autoLogin') ?? false;
      isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      isRememberMeDisabled = prefs.getBool('isRememberMeDisabled') ?? false;
      if (rememberMe == true) {
        setState(() {
          _isRememberMe = true;
        });
        emailController.text = loginEmailID;
        passwordController.text = loginPassword;
      }
      else{
        setState(() {
          _isRememberMe = false;
        });
        emailController.text = '';
        loginEmailID = '';
        passwordController.text = '';
        loginPassword = '';
      }

      if(automaticLogin == true && isLoggedIn == true){

      }
      else{
        SharedPreferences.getInstance().then((prefs) {
          prefs.setBool('isLoggedIn', false);
        },);
      }
    } catch (e) {
      print(e);
    }
  }

  //Alert box
  Future<void> _showMyDialog(String title, String bodyText) async {
    String AlertText = bodyText;
    String AlertTitle = title;
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AlertTitle, style: TextStyle(color: kDarkTitleColor, fontSize: 20.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AlertText, style: TextStyle(color: kLightTitleColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: kLightTitleColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _loginMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login Successful!', style: TextStyle(color: kDarkTitleColor, fontSize: 20.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Congratulations! You have logged in successfully!', style: TextStyle(color: kLightTitleColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: kLightTitleColor),),
              onPressed: () {
                Navigator.pushNamed(context, '/main_screen');
              },
            ),
          ],
        );
      },
    );
  }
}
