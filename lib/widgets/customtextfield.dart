import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:property_broker/utils/colors.dart';
import 'package:property_broker/utils/textstyle.dart';

class CustomTextField extends StatefulWidget {
  var width, height, title;
  bool keyboardTypenumeric, number;
  bool pass = false, email = false, phone = false, whatapp = false;
  TextEditingController controller = TextEditingController();
  CustomTextField(
      {@required this.height,
      @required this.number,
      @required this.keyboardTypenumeric,
      @required this.pass,
      @required this.whatapp,
      @required this.phone,
      @required this.email,
      this.controller,
      this.title,
      this.width});
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return custom();
  }
}

class custom extends State<CustomTextField> {
  bool show = false;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      width: widget.width,
      height: widget.height,
      decoration: BoxDecoration(
        borderRadius:
            BorderRadius.circular(MediaQuery.of(context).size.width * .02),
        border: Border.all(color: Colors.grey[200]),
        color: Colors.white,
      ),
      // padding: ,
      child: TextField(
        controller: widget.controller,
        keyboardType: widget.keyboardTypenumeric == true
            ? TextInputType.numberWithOptions(signed: true, decimal: true)
            : TextInputType.text,
        // maxLength: widget.number == true ? 8 : 40,
        style: labelTextStyle.copyWith(
            // color: secondaryColor,
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.normal),
        obscureText: widget.pass == true
            ? show == false
                ? true
                : false
            : false,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(widget.width * .02),
            counterText: "",
            hintText: "${widget.title}",
            prefixIcon: widget.phone == true
                ? Icon(
                    Icons.phone,
                    color: mainColor,
                    size: 20,
                  )
                : widget.email == true
                    ? Icon(
                        Icons.mail,
                        color: mainColor,
                        size: 20,
                      )
                    : widget.pass == true
                        ? Icon(
                            Icons.lock,
                            color: mainColor,
                            size: 20,
                          )
                        : widget.whatapp == true
                            ? Icon(
                                FontAwesomeIcons.whatsapp,
                                color: mainColor,
                                size: 20,
                              )
                            : Icon(
                                Icons.people,
                                color: mainColor,
                                size: 20,
                              ),
            suffixIcon: widget.pass == true
                ? GestureDetector(
                    onTap: () {
                      setState(() {
                        show = !show;
                      });
                    },
                    child: Icon(
                      show == false ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                  )
                : Container(
                    height: 1,
                    width: 1,
                  ),
            // labelText: "${widget.title}",
            hintStyle: headingStyle.copyWith(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w300)),
      ),
    );
  }
}
