import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';

class PropertyTextField extends StatefulWidget {
  var width, height, title;
  bool keyboardTypenumeric, number;
  bool description = false;
  TextEditingController controller = TextEditingController();
  PropertyTextField(
      {@required this.height,
      @required this.number,
      @required this.description,
      @required this.keyboardTypenumeric,
      this.controller,
      this.title,
      this.width});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return custom();
  }
}

class custom extends State<PropertyTextField> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: widget.width,
      // height: widget.height,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * .02),
        border: Border.all(color: Colors.grey[200]),
        color: Colors.white,
      ),
      // padding: ,
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.done,
        keyboardType: widget.keyboardTypenumeric == true
            ? TextInputType.number
            : widget.description == true
                ? TextInputType.multiline
                : TextInputType.text,
        inputFormatters: widget.keyboardTypenumeric == true
            ? <TextInputFormatter>[
                FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ]
            : <TextInputFormatter>[
                // FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
              ],
        // maxLength: widget.number == true ? 8 : 40,
        style: labelTextStyle.copyWith(
            // color: secondaryColor,
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal),

        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(widget.width * .02),
            counterText: "",
            // hintText: "${widget.title}",
            labelText: "${widget.title}",

            // labelText: "${widget.title}",
            hintStyle: headingStyle.copyWith(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
