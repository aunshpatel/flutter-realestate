import 'package:flutter/material.dart';
import 'package:realestate/models/user_model.dart';
import 'package:realestate/view/widgets/rounded_buttons.dart';
import 'package:realestate/view/widgets/side_drawer.dart';

import '../consts.dart';
import '../controllers/user_controller.dart';
class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  String email = '', pwd = '';
  String loginEmailID = '', loginPassword = '';
  bool showSpinner = false;
  bool _passwordVisible = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
          endDrawerEnableOpenDragGesture: false,
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
                Text('Registration ', style:TextStyle(color: kLightTitleColor),),
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
                  controller: usernameController,
                  keyboardType: TextInputType.text,
                  onChanged:(value){
                    email = usernameController.text;
                  },
                  style: const TextStyle(color: kThemeBlueColor),
                  decoration: emailInputDecoration('Enter your username',),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  onChanged:(value){
                    email = emailController.text;
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
                  title:'Register',
                  onPress:() async {
                    if(usernameController.text != '' && emailController.text != '' && passwordController.text != '') {
                      try{
                        final user = UserRegister(username: usernameController.text, email: emailController.text, password: passwordController.text);
                        final success = await UserController.registerUser(user);
                        if(success == 'success'){
                          _registrationMessage();
                        } else{
                          print("success: $success");
                          if(success.toString().contains("username_1 dup key")){
                            _errorMessage("Username already exists!","Please enter a different username.");
                          }
                          else if(success.toString().contains("email_1 dup key")){
                            _errorMessage("Email id already exists!", "Please enter a different email id or login using this one.");
                          }
                          print("Registration failed");
                        }
                        // _registrationMessage();
                        print("success: $success");
                      } catch(e){
                        setState(() {
                          showSpinner = false;
                        });
                        return _showMyDialog('Warning!','${e.toString()}');
                      }
                    }
                    else if(passwordController.text.isEmpty && emailController.text.isNotEmpty && usernameController.text.isNotEmpty){
                      _showMyDialog('Warning!','No password entered. Please enter the your password.');
                    }
                    else if(passwordController.text.isNotEmpty && emailController.text.isEmpty && usernameController.text.isNotEmpty){
                      _showMyDialog('Warning!','No email id entered. Please enter your email id.');
                    }
                    else if(passwordController.text.isNotEmpty && emailController.text.isNotEmpty && usernameController.text.isEmpty){
                      _showMyDialog('Warning!','No username entered. Please enter your email id.');
                    }
                    else if(emailController.text.isEmpty && passwordController.text.isEmpty && usernameController.text.isEmpty){
                      _showMyDialog('Warning!','All fields are empty. Please enter them to register.');
                    }
                    else if(passwordController.text.isEmpty && emailController.text.isEmpty && usernameController.text.isNotEmpty){
                      _showMyDialog('Warning!','No email id and password entered. Please enter your email id and password to register.');
                    }
                    else if(passwordController.text.isNotEmpty && emailController.text.isEmpty && usernameController.text.isEmpty){
                      _showMyDialog('Warning!','No email id and username entered. Please enter your email id and username to register.');
                    }
                    else if(passwordController.text.isEmpty && emailController.text.isNotEmpty && usernameController.text.isEmpty){
                      _showMyDialog('Warning!','No username and password entered. Please enter your username and password to register.');
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
        )
    );
  }

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

  Future<void> _registrationMessage() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Registration Successful!', style: TextStyle(color: kDarkTitleColor, fontSize: 20.0)),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Congratulations! You have registered successfully and you can login now!', style: TextStyle(color: kLightTitleColor)),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('OK', style: TextStyle(color: kLightTitleColor),),
              onPressed: () {
                Navigator.pushNamed(context, '/login_screen');
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _errorMessage(String messageTitle, String messageBody) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(messageTitle, style: TextStyle(color: kDarkTitleColor, fontSize: 20.0)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(messageBody, style: const TextStyle(color: kLightTitleColor)),
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
}
