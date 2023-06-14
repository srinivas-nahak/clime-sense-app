import 'package:flutter/material.dart';

import '../screens/weather_screen.dart';
import '../utilities/constants.dart';
import 'google_places_flutter.dart';

class GoogleTextField extends StatefulWidget {
  GoogleTextField({this.sendData, super.key});

  final TextEditingController controller = TextEditingController();

  SendData? sendData;

  @override
  State<StatefulWidget> createState() {
    return GoogleTextFieldState();
  }
}

class GoogleTextFieldState extends State<GoogleTextField> {
  var circularBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none);

  var semiCircularBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      borderSide: BorderSide.none);

  var giveBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none);

  var textFieldBackGroundColor = kCardColor.withOpacity(0.25);

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
        textEditingController: widget.controller,
        googleAPIKey: kGoogleMapApi,
        onClick: () {
          setState(() {
            if (widget.controller.text.isEmpty) {
              //Changing the SearchBar Color
              textFieldBackGroundColor = kCardColor.withOpacity(0.6);
            }
          });
        },
        shapeChange: (value) {
          setState(() {
            if (value) {
              giveBorder = semiCircularBorder;
            } else {
              //Changing the SearchBar Color
              textFieldBackGroundColor = kCardColor.withOpacity(0.25);

              giveBorder = circularBorder;

              //Closing the keyboard if it's open
              if (FocusManager.instance.primaryFocus!.hasFocus) {
                FocusManager.instance.primaryFocus?.unfocus();
              }
            }
          });
        },
        inputDecoration: InputDecoration(
            hintText: "Enter the city",
            hintStyle: TextStyle(color: kBackgroundColor.withOpacity(0.4)),
            filled: true,
            fillColor: textFieldBackGroundColor,
            border: giveBorder,
            isDense: true,
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.search,
              size: 25,
              color: kBackgroundColor.withOpacity(0.2),
            )),
        debounceTime: 250,
        isLatLngRequired: true,
        getPlaceDetailsWithLatLng: (prediction) async {
          // this method will return latlng with place detail

          //Closing Keyboard

          if (FocusManager.instance.primaryFocus!.hasFocus) {
            FocusManager.instance.primaryFocus?.unfocus();
          } else {
            FocusManager.instance.primaryFocus?.hasFocus;
          }

          var weatherData = await networkHelper.getNetworkData(
              lat: double.parse(prediction.lat!),
              lon: double.parse(prediction.lng!));

          widget.sendData!(weatherData, prediction.description!);
        }, // this callback is called when isLatLngRequired is true
        itemClick: (prediction) {
          widget.controller.text = prediction.description!;
          int offsetNum = prediction.description?.length ?? 0;
          widget.controller.selection =
              TextSelection.fromPosition(TextPosition(offset: offsetNum));
        });
  }
}
