import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  DatabaseService db = DatabaseService();
  var newUser;

  //create a user object based on Firebase user
  UserData _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? UserData(uid: user.uid) : null;
  }
  //Verify user account
  userFromFirebaseVerification(String emailAddress) async {
    FirebaseUser user = await _auth.currentUser();
    try {
      user.sendEmailVerification();
      return user.uid;
    } catch (e) {
      print('${this.runtimeType} sending verification failed: $e');
    }

  }

  //auth change user screen
  Stream<UserData> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in with user name and password
  Future signInWithUserNameandPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      FirebaseUser user = result.user;
      if (user.uid != null) {
        return user.uid;
      } else {
        return null;
      }
    } catch (e) {
      return e.message.toString();
    }
  }

  //register with email and password
  Future registerWithEmailandPassword(
      {String email,
      String password,
      String firstName,
      String lastName,
      String company,
      bool isActive,
      String phoneNumber,
      String countryOfResidence,
      String cityOfResidence,
      List<String> roles}) async {
    try {
      var result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      FirebaseUser user = result.user;

      print('${this.runtimeType} current user: ${user.uid}');
      if (user != null) {
        await db
            .setUserData(
                uid: user.uid,
                firstName: firstName,
                lastName: lastName,
                company: company,
                phoneNumber: phoneNumber,
                isActive: false,
                emailAddress: email,
                countryOfResidence: countryOfResidence,
                cityOfResidence: cityOfResidence ?? '',
                roles: roles)
            .then((value) {
          print(value);
        });
        Future.delayed(Duration(seconds: 3));
        user = await _auth.currentUser();
        try {
          print('${this.runtimeType} sending verification email for $user');
          await user.sendEmailVerification();
          return user.uid;
        } catch (e) {
          print('an error occured while sending verification email: $e');
        }
      }
    } catch (e) {
      print('Could not register error: ' + e.toString());
      return e.toString();
    }
  }

  //sign out
  Future signOut() async {
    try {
      print('${this.runtimeType} has signed out user: ${user.first}');
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      return '${this.runtimeType} Reset email error: $e';
    }
  }
}
