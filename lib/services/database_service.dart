import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DatabaseService{

  final uid;
  DatabaseService({this.uid});

  // reference for our collection
  final CollectionReference userCollection =FirebaseFirestore.instance.collection("user");
  final CollectionReference groupCollection =FirebaseFirestore.instance.collection("groups");
  
  get groupName => null;

  



  // updating user data

  Future updateUserData(String fullname,String email)async{
    return await userCollection.doc(uid).set({
      "fullname":fullname,
      "email":email,
      "groups":[],
      "profilepic":"",
      'uid':uid,
      
    });

  } 


  // ceating groups

  Future createGroup(String userName, String id, String groupName) async {
    DocumentReference groupDocumentReference = await groupCollection.add({
      "groupName": groupName,
      "groupIcon": "",
      "admin": "${id}_$userName",
      "members": [],
      "groupId": "",
      "recentMessage": "",
      "recentMessageSender": "",
    });

     // update the members
    await groupDocumentReference.update({
      "members": FieldValue.arrayUnion(["${uid}_$userName"]),
      "groupId": groupDocumentReference.id,
    });

    DocumentReference userDocumentReference = userCollection.doc(uid);
    return await userDocumentReference.update({
      "groups":
          FieldValue.arrayUnion(["${groupDocumentReference.id}_$groupName"])
    });
    }



    

  // getting user data
  Future gettingUserData(String email) async{
    QuerySnapshot snapshot=await userCollection.where("email",isEqualTo: email).get();
    return snapshot;
  } 




  // get user groups

  getUserGroups()async{
    return userCollection.doc(uid).snapshots();
  }



  // getting chats

  getChats(String groupId)async{
    return groupCollection.doc(groupId).collection("messages").orderBy("time").snapshots();
  }

  Future getChatAdmin(String groupId)async{
    DocumentReference d=groupCollection.doc(groupId);
    DocumentSnapshot documentSnapshot=await d.get();
    return documentSnapshot ['admin'];
  }


  // get group members

  getGroupMembers(groupId)async{
    return groupCollection.doc(groupId).snapshots();
  }


  // search 
  searhByName(String groupName){
    return groupCollection.where("groupName",isEqualTo: groupName).get();
  }

  // function bool

   Future<bool> isUserJoined(
      String groupName, String groupId, String userName) async {
    DocumentReference userDocumentReference = userCollection.doc(uid);
    DocumentSnapshot documentSnapshot = await userDocumentReference.get();

    List<dynamic> groups = await documentSnapshot['groups'];
    if (groups.contains("${groupId}_$groupName")) {
      return true;
    } else {
      return false;
    }
  }

  // toggling the group join or exit
  Future toggleGroupJoin(String groupId,String userName,String groupName)async{
    // doc reference
    DocumentReference userDocumentReference=userCollection.doc(uid);
    DocumentReference groupDocumentReference=groupCollection.doc(groupId);

    DocumentSnapshot documentSnapshot=await userDocumentReference.get();
    List<dynamic> groups = await documentSnapshot['groups'];

    // if user has our groups then remove or re join

    if (groups.contains("${groupId}_$groupName")){
      await userDocumentReference.update({
        "groups":FieldValue.arrayRemove(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members":FieldValue.arrayRemove(["${uid}_$userName"])
      });
    }else{
      await userDocumentReference.update({
        "groups":FieldValue.arrayUnion(["${groupId}_$groupName"])
      });
      await groupDocumentReference.update({
        "members":FieldValue.arrayUnion(["${uid}_$userName"])
      });

    }

  }

  // send message

  sendMessage(String groupId,Map<String,dynamic>chatMessageData){
    groupCollection.doc(groupId).collection("messages").add(chatMessageData);
    groupCollection.doc(groupId).update({
      "recentMessage":chatMessageData['message'],
      "recentMessageSender":chatMessageData['sender'],
      "recentMessgeTime":chatMessageData['time'].toString(),
    });

  }



}