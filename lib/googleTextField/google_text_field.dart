import 'package:flutter/material.dart';
import 'package:weather_practice/services/network_helper.dart';

import '../utilities/constants.dart';
import 'google_places_flutter.dart';

class GoogleTextField extends StatefulWidget {
  GoogleTextField({required this.sendData, super.key});

  final TextEditingController controller = TextEditingController();
  final void Function(dynamic weatherDta, String cityName) sendData;

  @override
  State<StatefulWidget> createState() {
    return GoogleTextFieldState();
  }
}

class GoogleTextFieldState extends State<GoogleTextField> {
  OutlineInputBorder circularBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none);

  OutlineInputBorder semiCircularBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30), topRight: Radius.circular(30)),
      borderSide: BorderSide.none);

  OutlineInputBorder giveBorder = const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide.none);

  Color textFieldBackGroundColor = kCardColor.withOpacity(0.08);

  @override
  Widget build(BuildContext context) {
    return GooglePlaceAutoCompleteTextField(
        textEditingController: widget.controller,
        googleAPIKey: kGoogleMapApiKey,
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
              textFieldBackGroundColor = kCardColor.withOpacity(0.08);

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
            hintStyle: TextStyle(color: kCardColor.withOpacity(0.15)),
            filled: true,
            fillColor: textFieldBackGroundColor,
            border: giveBorder,
            isDense: true,
            contentPadding: const EdgeInsets.all(15),
            suffixIcon: Icon(
              Icons.search,
              size: 25,
              color: kCardColor.withOpacity(0.15),
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

          var weatherData = await NetworkHelper().getNetworkData(
              lat: double.parse(prediction.lat!),
              lon: double.parse(prediction.lng!));

          widget.sendData(weatherData, prediction.description!);
        }, // this callback is called when isLatLngRequired is true
        itemClick: (prediction) {
          widget.controller.text = prediction.description!;
          int offsetNum = prediction.description?.length ?? 0;
          widget.controller.selection =
              TextSelection.fromPosition(TextPosition(offset: offsetNum));
        });
  }
}
