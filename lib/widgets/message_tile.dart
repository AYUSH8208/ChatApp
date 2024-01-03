import 'package:flutter/material.dart';

class MessageTile extends StatefulWidget{
  final String message ;
  final String sender;
  final bool sentbyMe;
  const MessageTile({Key?key,required this.message,required this.sender,required this.sentbyMe}):super(key: key);
  

  @override
  State<MessageTile>createState() => _MessageTileState();

}

class _MessageTileState extends State<MessageTile>{
  @override
  Widget build(BuildContext context){
    return Container(
      padding: EdgeInsets.only(top: 5,bottom: 5,left: widget.sentbyMe?0:24,right: widget.sentbyMe?24:0),
      alignment: widget.sentbyMe?Alignment.centerRight:Alignment.centerLeft,
      child: Container(
        margin: widget.sentbyMe?const EdgeInsets.only(left: 50):const EdgeInsets.only(right: 50),
        padding: const EdgeInsets.only(top: 20,bottom: 17,left: 20,right: 20),
        decoration: BoxDecoration(
          borderRadius:widget.sentbyMe?const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
    
          ):const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),),
          color: widget.sentbyMe? Colors.orange:Colors.grey[700]
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.sender.toUpperCase(),textAlign: TextAlign.center,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold,color: Colors.white),),
            const SizedBox(
              height: 8,
            ),
            Text(widget.message,textAlign: TextAlign.center,style: TextStyle(fontSize: 18),)
          ],
        ),
      ),
    );
  }
}