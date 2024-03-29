import 'package:app_3/pages/homepage.dart';
import 'package:app_3/services/auth_service.dart';
import 'package:app_3/services/database_service.dart';
import 'package:app_3/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo_page extends StatefulWidget {
  final String groupadmin;
  final String groupId;
  final String groupName;
  const GroupInfo_page(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.groupadmin})
      : super(key: key);
  @override
  State<GroupInfo_page> createState() => _GroupInfo_pageState();
}

class _GroupInfo_pageState extends State<GroupInfo_page> {
  Stream? members;

  AuthService authService = AuthService();

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((val) {
      setState(() {
        members = val;
      });
    });
  }

  String getName(String r){
    return r.substring(r.indexOf("_")+1);
  }


  String getId(String res) {
    return res.substring(0, res.indexOf("_"));
  }


  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text("Group Info"),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(onPressed: ()async {showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Exit"),
                        content: const Text("Are you sure to Exit the group?"),
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
                                DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid).toggleGroupJoin(widget.groupId, getName(widget.groupadmin), widget.groupName).whenComplete((){
                                  nextscreeen(context, HomePage());
                                });
                              },
                              icon: const Icon(
                                Icons.done,
                                color: Colors.green,
                              ))
                        ],
                      );
                    });
            
          }, icon:Icon(Icons.exit_to_app_rounded))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: Colors.orange.withOpacity(0.2),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    
                    radius: 30,
                    backgroundColor: Colors.orange,
                    child: Text(
                      widget.groupName.substring(0, 1).toUpperCase(),
                      style:
                          TextStyle(fontWeight: FontWeight.w400, color: Colors.white),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Group: ${widget.groupName}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(
                        height: 5,
                        ),
                      Text(
                        "Admin: ${getName(widget.groupadmin)}",
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),  
      
                    ],
                  )
                ],
              ),
            ),
            memberList(),
          ],
        ),
      ),
      
    );
  }
  memberList(){
    return StreamBuilder(stream: members, builder: (context,AsyncSnapshot snapshot){
     if (snapshot.hasData) {
          if (snapshot.data['members'] != null) {
            if (snapshot.data['members'].length != 0) {
             
                  return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder:(context,index){
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5,vertical: 30),
                        child: ListTile(
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.orange,
                            child: Text(getName(snapshot.data['members'][index]).substring(0,1).toUpperCase(),style:const TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white)),

                          ),
                          title: Text(getName(snapshot.data['members'][index])),
                          subtitle: Text(getId(snapshot.data['members'][index])),

                        ),
                      );
                    } ,
                );  
                
            } else {
              return const Center(
                child: Text("NO MEMBERS"),
              );
            }
          } else {
            return const Center(
                child: Text("NO MEMBERS"),);
          }
        } else {
          return Center(
              child: CircularProgressIndicator(
            color: Colors.orange,
          ));
        }
    });
  }
}
