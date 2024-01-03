import 'package:app_3/helper/helper_functions.dart';
import 'package:app_3/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth firebaseAuth=FirebaseAuth.instance;

  // login

  Future loginWithUserNameandPassword(String email,String password)async{
    try{
      User user =(await firebaseAuth.signInWithEmailAndPassword(email: email, password: password)).user!;
      if (user!=null){
        // call databaser to update the user data
       
        return true;
      };



    } on FirebaseAuthException catch (e){
     
      return e.message;
    }
  }


  // register
  Future registerUserWithEmailandPassword(String fullname,String email,String password)async{
    try{
      User user =(await firebaseAuth.createUserWithEmailAndPassword(email: email, password: password)).user!;
      if (user!=null){
        // call databaser to update the user data
        DatabaseService(uid: user.uid).updateUserData(fullname, email);
        return true;
      };



    } on FirebaseAuthException catch (e){
     
      return e.message;
    }
  }

  
  // sign out

  Future signout() async{
    try{
      await HelperFunctions.saveUserEmailSF("");
      await HelperFunctions.saveUserNameSF("");
      await HelperFunctions.saveUserLoggedInStatus(false);
      await firebaseAuth.signOut();
    }catch(e){
      return null;
    }
  }
}