import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:Products/shared/strings.dart';
import '../../shared/constants.dart';
import '../../shared/loading.dart';
import '../../services/auth.dart';

class SignIn extends StatefulWidget {


  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  //text field state
  String email = '';
  String password = '';
  String error = '';

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
                    error != null
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
                          dynamic result = await _auth
                              .signInWithUserNameandPassword(email, password);
                          print(result);
                          setState(() {
                            loading = false;
                            error = result;
                          });
                        }
                      },
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
