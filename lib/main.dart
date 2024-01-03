import 'package:app_3/auth/loginpage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:app_3/pages/homepage.dart';
import 'package:app_3/helper/helper_functions.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  future:Firebase.initializeApp();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyCX9LdZZlGU1Lz3vG1iDj6DRLESsd4lSso",
            appId: "1:207898060147:web:0a9103c5abd4326f06d106",
            messagingSenderId: "207898060147",
            projectId: "chatapp-f2b15"));
  } else{
    await Firebase.initializeApp();
  }
  runApp( const Myapp());// use MaterialApp
  
}

// void main() async {
//   await WidgetsFlutterBinding.ensureInitialized();
//   // await Firebase.initializeApp();
//   runApp(const Myapp());
// }

class Myapp extends StatefulWidget {
  const Myapp({Key? key}) : super(key: key);

  @override
  State<Myapp> createState() => _MyappState();
}

class _MyappState extends State<Myapp> {
  bool _issignedIn=false;
  
  @override
  void initState(){
    super.initState();
    getUserLogedInStatus();
  }
  getUserLogedInStatus()async{

    await HelperFunctions.getUserLogedInStatus().then((value){
      if(value!=null){
        setState(() {
           _issignedIn=value;
          
        });
        
         
          
        
        

      }


    }
    );
  }
  Widget build(BuildContext context) {
    return MaterialApp(


      debugShowCheckedModeBanner: false,

      home:_issignedIn ?   HomePage() : const LoginPage(),
      );
    
  }
}
