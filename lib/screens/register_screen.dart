import '../constants.dart';
import '../widgets/custom_font.dart';
import '../widgets/custom_inkwell_button.dart';
import '../widgets/custom_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/custom_dialogs.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  TextEditingController firstnameController = TextEditingController();
  TextEditingController lastnameController = TextEditingController();
  TextEditingController mobilenumController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmpasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Validation methods
  String? _validateFirstName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your first name';
    }
    if (value.length < 2) {
      return 'First name must be at least 2 characters';
    }
    return null;
  }

  String? _validateLastName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your last name';
    }
    if (value.length < 2) {
      return 'Last name must be at least 2 characters';
    }
    return null;
  }

  String? _validateMobileNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your mobile number';
    }
    if (value.length < 10) {
      return 'Mobile number must be at least 10 digits';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    // Check for uppercase, lowercase, number, and special character
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password must contain at least one lowercase letter';
    }
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password must contain at least one number';
    }
    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  void _handleRegister() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      final fullName = '${firstnameController.text} ${lastnameController.text}';

      customDialog(
        context,
        title: 'Registration Successful',
        content: 'Welcome, $fullName! Your account has been created.',
      ).then((_) {
        // Navigate to login screen after dialog
        Navigator.popAndPushNamed(context, '/login');
      });
    } else {
      // Show validation error dialog
      customDialog(
        context,
        title: 'Invalid Input',
        content: 'Please check all fields and try again.',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: ScreenUtil().screenHeight,
          width: ScreenUtil().screenWidth,
          padding: EdgeInsets.fromLTRB(
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(40),
            ScreenUtil().setWidth(25),
            ScreenUtil().setHeight(10),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                SizedBox(height: ScreenUtil().setHeight(25)),
                CustomFont(
                  text: 'Register Here',
                  fontSize: ScreenUtil().setSp(50),
                  fontWeight: FontWeight.bold,
                  color: FB_DARK_PRIMARY,
                ),
                SizedBox(height: ScreenUtil().setHeight(25)),
                CustomTextFormField(
                  height: ScreenUtil().setHeight(10),
                  width: ScreenUtil().setWidth(10),
                  onSaved: (value) => firstnameController.text = value!,
                  fontColor: FB_DARK_PRIMARY,
                  hintText: 'First name',
                  validator: _validateFirstName,
                  hintTextSize: ScreenUtil().setSp(15),
                  fontSize: ScreenUtil().setSp(15),
                  controller: firstnameController,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  height: ScreenUtil().setHeight(10),
                  width: ScreenUtil().setWidth(10),
                  onSaved: (value) => lastnameController.text = value!,
                  fontColor: FB_DARK_PRIMARY,
                  hintText: 'Last name',
                  validator: _validateLastName,
                  hintTextSize: ScreenUtil().setSp(15),
                  fontSize: ScreenUtil().setSp(15),
                  controller: lastnameController,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  maxLength: 11,
                  keyboardType: TextInputType.number,
                  height: ScreenUtil().setHeight(10),
                  width: ScreenUtil().setWidth(10),
                  onSaved: (value) => mobilenumController.text = value!,
                  fontColor: FB_DARK_PRIMARY,
                  hintText: 'Mobile Number',
                  validator: _validateMobileNumber,
                  hintTextSize: ScreenUtil().setSp(15),
                  fontSize: ScreenUtil().setSp(15),
                  controller: mobilenumController,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  height: ScreenUtil().setHeight(10),
                  width: ScreenUtil().setWidth(10),
                  onSaved: (value) => usernameController.text = value!,
                  fontColor: FB_DARK_PRIMARY,
                  hintText: 'Username',
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Enter your username';
                    }
                    if (value.length < 4) {
                      return 'Username must be at least 4 characters';
                    }
                    return null;
                  },
                  hintTextSize: ScreenUtil().setSp(15),
                  fontSize: ScreenUtil().setSp(15),
                  controller: usernameController,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  isObscure: true,
                  height: ScreenUtil().setHeight(10),
                  width: ScreenUtil().setWidth(10),
                  onSaved: (value) => passwordController.text = value!,
                  fontColor: FB_DARK_PRIMARY,
                  hintText: 'Password',
                  validator: _validatePassword,
                  hintTextSize: ScreenUtil().setSp(15),
                  fontSize: ScreenUtil().setSp(15),
                  controller: passwordController,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                Text(
                  '(Password should be 8 characters, a mixture of letter and numbers consisting of at least one special character with Uppercase and Lowercase letters.)',
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: ScreenUtil().setSp(10),
                  ),
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomTextFormField(
                  isObscure: true,
                  hintText: 'Confirm Password',
                  height: ScreenUtil().setHeight(10),
                  width: ScreenUtil().setWidth(10),
                  onSaved: (value) => confirmpasswordController.text = value!,
                  fontColor: FB_DARK_PRIMARY,
                  validator: _validateConfirmPassword,
                  hintTextSize: ScreenUtil().setSp(15),
                  fontSize: ScreenUtil().setSp(15),
                  controller: confirmpasswordController,
                ),
                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account? ",
                      style: TextStyle(
                        color: Colors.black45,
                        fontSize: ScreenUtil().setSp(15),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.popAndPushNamed(context, '/login'),
                      child: Text(
                        'Login here',
                        style: TextStyle(
                          color: FB_DARK_PRIMARY,
                          fontSize: ScreenUtil().setSp(15),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                CustomInkwellButton(
                  onTap: _handleRegister,
                  height: ScreenUtil().setHeight(45),
                  width: ScreenUtil().screenWidth,
                  fontSize: ScreenUtil().setSp(15),
                  fontWeight: FontWeight.bold,
                  buttonName: 'Submit',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
