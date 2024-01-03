import 'package:app_3/pages/groupInfo.dart';
import 'package:app_3/services/auth_service.dart';
import 'package:app_3/services/database_service.dart';
import 'package:app_3/widgets/message_tile.dart';
import 'package:app_3/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class Chatpage extends StatefulWidget {

  final String userName;
  final String groupId;
  final String groupName;
  const Chatpage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<Chatpage> createState() => _ChatpageState();
}

class _ChatpageState extends State<Chatpage> {
  Stream<QuerySnapshot>?chats;
  String admin="";
  AuthService authService = AuthService();
  TextEditingController messageController=TextEditingController();
  

  
  @override


  void initState(){

    getChatAdmin();
    super.initState();
  }

  getChatAdmin(){
    DatabaseService().getChats(widget.groupId).then((val){
      setState(() {
        chats=val;
      });
    });

    DatabaseService().getChatAdmin(widget.groupId).then((value){
      setState(() {
        admin=value;
      });
    });





  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(widget.groupName),
        backgroundColor: Colors.orange,
        actions: [
          IconButton(onPressed: (){
            nextscreeen(context, GroupInfo_page(groupId: widget.groupId,groupName: widget.groupName,groupadmin: admin,));
          }, icon: Icon(Icons.info))
        ],
      ),

      body: Stack(
        children: <Widget>[
          chatMessages(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 18),
              color: Colors.grey,
              child: Row(children: [
                Expanded(child: TextFormField(
                  controller: messageController,
                  style: const TextStyle(color: Colors.white),
                  decoration: const InputDecoration(
                    hintText: "Send a message..",
                    hintStyle: TextStyle(color: Colors.white,fontSize: 16),
                    border: InputBorder.none,
                  ),
                )),
                const SizedBox(
                  width: 12,
                ),
                GestureDetector(
                  onTap: (){
                    sendMessage();
                  },
                  child: Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                      color: Colors.orange,
                      borderRadius: BorderRadius.circular(30),
                
                
                    ),
                    child: const Center(
                      child:Icon(Icons.send,
                      color:Colors.white,)
                    ),
                
                  ),
                )
              ]),
            ),
          )
        ],
      ),
   );
  }

  chatMessages(){
    return StreamBuilder(stream: chats, builder: (context,AsyncSnapshot snapshot){
      return snapshot.hasData?ListView.builder(
        itemCount: snapshot.data.docs.length,
        itemBuilder: (context,index){
          return MessageTile(message: snapshot.data.docs[index]['message'], sender: snapshot.data.docs[index]['sender'], sentbyMe: widget.userName == snapshot.data.docs[index]['sender']);


        },
      ):Container();
    });

  }
  sendMessage(){
    if (messageController.text.isNotEmpty){
      Map<String,dynamic>chatMessageMap={
        "message":messageController.text,
        "sender":widget.userName,
        "time":DateTime.now().microsecondsSinceEpoch,
      };

      DatabaseService().sendMessage(widget.groupId,chatMessageMap);
      setState(() {
        messageController.clear();
      });
    }
  }
}