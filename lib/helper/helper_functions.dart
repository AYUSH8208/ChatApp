import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions{
  // keys 
  static String user_logedinkey="LOGINKEY";
  static String user_namekey="USERNAMEKEY";
  static String user_emailkey="USEREMAILKEY";
  // saving dta ton shared preferences
  static Future<bool> saveUserLoggedInStatus(bool isUserLoggedIn) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setBool(user_logedinkey, isUserLoggedIn) ;
   }

   static Future<bool> saveUserNameSF(String userName) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(user_namekey, userName) ;
   }

   static Future<bool> saveUserEmailSF(String userEmail) async{
    SharedPreferences sf=await SharedPreferences.getInstance();
    return await sf.setString(user_emailkey, userEmail) ;
   }
  // getting the data from shared preferences
  static Future<bool?> getUserLogedInStatus()async{
    SharedPreferences sf =await SharedPreferences.getInstance();
    return sf.getBool(user_logedinkey);
  } 
  static Future<String?> getUserNameFromSF()async{
    SharedPreferences sf =await SharedPreferences.getInstance();
    return sf.getString(user_namekey);
  } 
  static Future<String?> getUserEmailFromSF()async{
    SharedPreferences sf =await SharedPreferences.getInstance();
    return sf.getString(user_emailkey);
  } 

}

