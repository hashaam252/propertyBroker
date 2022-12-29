import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';

class CustomButton extends StatefulWidget {
  var width, height, title;
  Color textColor = Colors.white;
  Color color;
  CustomButton(
      {@required this.color,
      @required this.textColor,
      this.height,
      this.title,
      this.width});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return custom();
  }
}

class custom extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Card(
      color: widget.color,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * .02),
      ),
      child: Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(MediaQuery.of(context).size.width * .02),
            color: widget.color,
            border: Border.all(color: mainColor)),
        child: Center(
          child: Text(
            "${widget.title}",
            style: headingStyle.copyWith(
                color: widget.textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}
