import 'package:app_3/helper/helper_functions.dart';
import 'package:app_3/pages/chat_page.dart';
import 'package:app_3/services/auth_service.dart';
import 'package:app_3/services/database_service.dart';
import 'package:app_3/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  AuthService authService = AuthService();
  TextEditingController SearchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapshot;
  bool hasUserSearched = false;
  String userName = "";
  User? user;
  bool isJoined=false;

  @override
  void initState() {
    super.initState();
    getCurrentUserIdandName();
  }

  getCurrentUserIdandName() async {
    await HelperFunctions.getUserNameFromSF().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }
   String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.orange,
        title: const Text(
          "Search",
          style: TextStyle(
              fontSize: 27, fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
        ),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.orange,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(children: [
              Expanded(
                child: TextField(
                  controller: SearchController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search groups",
                      hintStyle: TextStyle(fontSize: 12, color: Colors.white)),
                ),
              ),
              GestureDetector(
                onTap: () {
                  initiateSearchMethod();
                },
                child: Container(
                  width: 40,
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.white12,
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: const Icon(
                    Icons.search_sharp,
                    color: Colors.white,
                  ),
                ),
              )
            ]),
          ),
          _isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                  ),
                )
              : groupList(),
        ],
      ),
    );
  }

  initiateSearchMethod() async {
    if (SearchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searhByName(SearchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapshot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapshot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapshot!.docs[index]['groupName'],
                searchSnapshot!.docs[index]['groupId'],
                searchSnapshot!.docs[index]['admin'],
              );
            })
        : Container();
  }
  joinedOrNot( String userName, String groupName, String groupId, String admin)async{
    await DatabaseService(uid: user!.uid).isUserJoined(groupName, groupId, userName).then((value){
      setState(() {
        isJoined=value;
      });
    });
  }

  Widget groupTile(
      String userName, String groupName, String groupId, String admin) {
        // functions to check whether user is already in the group or not
        joinedOrNot(userName,groupName,groupId,admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10,vertical: 5),
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.orange,
        child: Text(groupName.substring(0,1).toUpperCase(),style: const TextStyle(color: Colors.white),),
      ),
      title: Text(groupName,style: const TextStyle(fontWeight: FontWeight.w600),),
      subtitle: Text("Admin: ${getName(admin)}"),
      trailing: InkWell(
        onTap: ()async{
          await DatabaseService(uid: user!.uid).toggleGroupJoin(groupId, userName, groupName);
          if(isJoined){
            setState(() {
              isJoined=!isJoined;
            });
            showSnackbar(context, Colors.green,("Succesfully joined the Group"));
            Future.delayed(const Duration(seconds: 2),(){
              nextscreeen(context, Chatpage(groupId: groupId, groupName: groupName, userName: userName));
            });
          }else{
            setState(() {
              isJoined=!isJoined;
            });
            showSnackbar(context, Colors.red,("left the Group $groupName"));
          }
        },
        child: isJoined? Container(

          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
            border: Border.all(color: Colors.white,width: 1),

          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("Joined",style: TextStyle(color: Colors.white),),
        ):Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.orange,
            border: Border.all(color: Colors.white,width: 1),

          ),
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: const Text("Join",style: TextStyle(color: Colors.white),),
        ),
      ),
    );
  }
}
