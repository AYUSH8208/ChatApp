import 'package:app_3/auth/loginpage.dart';
import 'package:app_3/pages/homepage.dart';
import 'package:app_3/services/auth_service.dart';
import 'package:app_3/widgets/widgets.dart';
import 'package:flutter/material.dart';

class Profilepage extends StatefulWidget {
  String userName;
  String email;
  Profilepage({Key?key,required this.userName,required this.email}):super(key: key);
  @override
  State<Profilepage> createState() => _ProfilepageState();
}

class _ProfilepageState extends State<Profilepage> {
  AuthService authService = AuthService();
  

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.orange,
      elevation: 0,
      title: const Text("Profile",style: TextStyle(color: Colors.white,fontSize: 27,fontWeight: FontWeight.bold),textAlign: TextAlign.center,),
      ),
      drawer:   Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
          children: <Widget>[
            Icon(
              Icons.account_circle,
              size: 150,
              color: Colors.grey,
            ),
            Text(
              widget.userName,
              textAlign: TextAlign.center,
              style:
                  TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
            ),
            const SizedBox(
              height: 20,
            ),
            const Divider(
              height: 2,
            ),
            ListTile(
              onTap: () { nextscreeen(context, HomePage());},
              
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.group),
              title: const Text(
                "Groups",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () {
               
              },
              selectedColor: Colors.orange,
              selected: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.person_2_outlined),
              title: const Text(
                "Profile",
                style: TextStyle(color: Colors.black),
              ),
            ),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("LOGOUT"),
                        content: const Text("Are you sure to logout?"),
                        actions: [
                          IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                                color: Colors.red,
                              )),
                          IconButton(
                              onPressed: ()async {
                                await authService.signout();
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context)=> const LoginPage()), (route) => false);
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
                
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.logout),
              title: const Text(
                "Logout",
                style: TextStyle(color: Colors.black),
              ),
            )
          ],
        ),
      ),

      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 40,vertical: 150),
        child:Column(children: [

          Icon(Icons.account_circle_outlined,size: 200,shadows: [],color: Colors.orange,),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Full Name",style: TextStyle(fontSize: 17),),
              Text(widget.userName,style: TextStyle(fontSize: 17),)
            ],
          ),
          Divider(
            height: 40,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Email ID",style: TextStyle(fontSize: 17),),
              Text(widget.email,style: TextStyle(fontSize: 17),)
            ],
          ),


        ],)
                        


      ),
      



    );
  }
}