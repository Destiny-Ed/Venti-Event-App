import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';

class AuthClass {
  FirebaseAuth _auth = FirebaseAuth.instance;


  //Create User

  Future createUser({String email, String password}) async {
    try {
      await _auth.createUserWithEmailAndPassword(
          email: email, password: password);

      return "Account Created Successfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        return 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        return 'The account already exists for that email.';
      }
    } on SocketException catch (_) {
      return 'Internet is required';
    } catch (e) {
      return "Please try again later";
    }
  }

  //Sign In User
  //
  Future signInUser({String email, String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return "Login Sucessfully";
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    } on SocketException catch (_) {
      return 'Internet is required';
    } catch (_) {
      return "Please try again later";
    }
  }

  //Reseting User Password

  Future resetPassword({String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return "Email sent succesfully";
    } on SocketException catch (_) {
      return "Internet is not available";
    } on FirebaseException catch (e) {
      return e.code;
    }
  }

  //Sign Out
  Future signOut() async {
    await _auth.signOut();
  }
}
