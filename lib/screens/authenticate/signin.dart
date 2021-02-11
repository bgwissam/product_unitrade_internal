import 'package:Products/screens/authenticate/register.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';
import '../../services/auth.dart';
import 'package:Products/screens/wrapper.dart';


class SignIn extends StatefulWidget {
  final String message;
  SignIn({this.message});
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading;
  bool showEmailVerification;
  //text field state
  String email = '';
  String password = '';
  String error;

  void initState() {
    super.initState();
    
    widget.message != null ? error = widget.message : error = null;
    showEmailVerification = false;
    loading = false;
    //check if signing in has an error or info message along
    widget.message != null ? error = widget.message : error = '';
  }

  //Will allow the user to send another verification email if the account is not verified
  _verifyAccount(String emailAddress) {
    print(emailAddress);
    _auth.userFromFirebaseVerification(emailAddress);
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            backgroundColor: Colors.grey[200],
            appBar: AppBar(
              backgroundColor: Colors.amber[400],
              elevation: 0.0,
              title: Text(
                SIGN_IN_TITLE,
                style: TextStyle(fontSize: 18.0, color: Colors.black),
              ),
            ),
            body: SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    Image.asset('assets/images/logo.png'),
                    SizedBox(height: 35.0),
                    //Email address or user name
                    TextFormField(
                      decoration: InputDecoration(
                        hintText: EMAIL_ADDRESS_FIELD,
                        labelText: EMAIL_ADDRESS,
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (val) =>
                          val.isEmpty ? EMAIL_ADDRESS_EMPTY : null,
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    //Password
                    TextFormField(
                      obscureText: true,
                      decoration: textInputDecoration.copyWith(
                        labelText: PASSWORD,
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (val) =>
                          val.isEmpty ? PASSWORD_EMPTY_VALIDATION : null,
                      onChanged: (val) {
                        setState(() {
                          password = val;
                        });
                      },
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    error.isNotEmpty
                        ? Container(
                            child: Text(
                              error,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.red,
                              ),
                            ),
                          )
                        : SizedBox(
                            height: 1.0,
                          ),
                    SizedBox(
                      height: 15.0,
                    ),
                    showEmailVerification
                        ? GestureDetector(
                            child: Container(
                              child: Text(VERIFY_ACCOUNT, style: textStyle7),
                            ),
                            onTap: () => email.isNotEmpty
                                ? _verifyAccount(email)
                                : error = 'Email is Empty')
                        : Container(),
                    SizedBox(
                      height: 15.0,
                    ),
                    GestureDetector(
                      child: Container(
                        child: Text(FORGOT_EMAIL_TITLE, style: textStyle7),
                      ),
                      onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ForgotEmailPage())),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        //A sign in button to sign in new users
                        RaisedButton(
                          color: Colors.brown[500],
                          child: Text(
                            LOGIN,
                            style: buttonStyle,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() {
                                loading = true;
                              });
                              dynamic result =
                                  await _auth.signInWithUserNameandPassword(
                                      email, password);
                              print(
                                  '${this.runtimeType} signing in result: $result');
                              if (result != null) {
                                if (result == 'User not verified') {
                                  setState(() {
                                    loading = false;
                                    showEmailVerification = true;
                                    error = result;
                                  });
                                } else if(result == 'User is verified') {
                                  setState(() {
                                    loading = false;
                                    Navigator.push(context, MaterialPageRoute(builder: (context) => Wrapper(),));
                                  });
                                }
                              } else {
                                error = 'Unknown error, contact developer';
                              }
                             
                            }
                          },
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        //A registeration button to register new users
                        RaisedButton(
                          color: Colors.brown[500],
                          child: Text(
                            REGISTER,
                            style: buttonStyle,
                          ),
                          onPressed: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Register()));
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class ForgotEmailPage extends StatefulWidget {
  @override
  _ForgotEmailPageState createState() => _ForgotEmailPageState();
}

//Will direct the user to a page that allows them to reset their account password
class _ForgotEmailPageState extends State<ForgotEmailPage> {
  final _formKey = GlobalKey<FormState>();
  String email;
  bool _autoValidate = false;
  final AuthService _auth = AuthService();

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(FORGOT_EMAIL_TITLE),
        backgroundColor: Colors.amber,
      ),
      body: Form(
        key: _formKey,
        autovalidate: _autoValidate,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: EMAIL_ADDRESS_FIELD,
                        labelText: EMAIL_ADDRESS,
                        filled: true,
                        fillColor: Colors.grey[100],
                        enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.grey)),
                        focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(15.0)),
                            borderSide: BorderSide(color: Colors.blue)),
                      ),
                      validator: (val) {
                        if (val.isEmpty) {
                          return EMAIL_ADDRESS_VALIDATOR;
                        }
                        if (!EmailValidator.validate(val)) {
                          return NON_VALID_EMAIL;
                        } else
                          return null;
                      },
                      onChanged: (val) {
                        setState(() {
                          email = val;
                        });
                      },
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              color: Colors.brown[500],
              child: Text(
                RESET_PASSWORD,
                style: buttonStyle,
              ),
              onPressed: () async {
                setState(() {
                  _autoValidate = true;
                });
                if (_formKey.currentState.validate()) {
                  dynamic result = await _auth.resetPassword(email);
                  if (result == null) {
                    print('failed to send reset email link');
                  }
                }
              },
            )
          ],
        ),
      ),
    );
  }
}
