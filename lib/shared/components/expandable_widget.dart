import 'package:flutter/material.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;
  const ExpandableTextWidget({Key? key, required this.text,}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText = true;
  double textHeight = 120;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.text.length > textHeight)
    {
      firstHalf = widget.text.substring(0, textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    }else
    {
      firstHalf = widget.text;
      secondHalf = '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty ? Text(firstHalf,  style: TextStyle(fontSize: 16,color: Colors.amber,height: 1.8,), )
          : Column(
        children: [
          Text(hiddenText ? ('$firstHalf...') : (firstHalf+secondHalf), style: TextStyle(fontSize: 16, color: Colors.amber, height: 1.8,)),
          InkWell(
            onTap: ()
            {
              setState(() {
                hiddenText =! hiddenText;
              });
            },
            child: Row(
              children: [
                Text(hiddenText? 'Show more' : 'Show less', style: TextStyle(color: Colors.greenAccent, fontSize: 16),),
                SizedBox(width: 5,),
                Icon(hiddenText? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up, color: Colors.greenAccent,),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
