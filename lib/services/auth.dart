import 'package:firebase_auth/firebase_auth.dart';
import 'database.dart';
import '../models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  DatabaseService db = DatabaseService();
  var newUser;

  //create a user object based on Firebase user
  User _userFromFirebaseUser(FirebaseUser user) {
    return user != null ? User(uid: user.uid) : null;
  }

  //auth change user screen
  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  //sign in with user name and password
  Future signInWithUserNameandPassword(String email, String password) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password);
      FirebaseUser user = result.user;
      if (user.isEmailVerified)
        return _userFromFirebaseUser(user);
      else
        return null;
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
      bool isAdmin,
      bool isPriceAdmin,
      bool isSuperAdmin,
      String phoneNumber,
      String countryOfResidence,
      String cityOfResidence}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser user = result.user;

       print('The user id is ${user.uid}');
      await db.updateUserData(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          company: company,
          isAdmin: false,
          isPriceAdmin: isPriceAdmin,
          isSuperAdmin: false,
          phoneNumber: phoneNumber,
          emailAddress: email,
          countryOfResidence: countryOfResidence,
          cityOfResidence: cityOfResidence).then((value) {
            print(value);
          });
      Future.delayed(Duration(seconds: 3));

      try {
        await user.sendEmailVerification();
        return user.uid;
      } catch (e) {
        print('an error occured while sending verification email:');
        print(e.message);
      }

      if (user.isEmailVerified) {
        //create a new document for user with uid
        await DatabaseService(uid: user.uid).updateUserData(
            firstName: firstName,
            lastName: lastName,
            company: company,
            isAdmin: isAdmin,
            isPriceAdmin: isPriceAdmin,
            isSuperAdmin: isSuperAdmin);
        return _userFromFirebaseUser(user);
      }
    } catch (e) {
      print('Could not register error: ' + e.toString());
      return null;
    }
  }

  //sign out
  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future resetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }
}
