library google_places_flutter;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utilities/constants.dart';
import 'model/place_details.dart';
import 'model/prediction.dart';
import 'dart:ui' as ui;

import 'package:rxdart/subjects.dart';
import 'package:dio/dio.dart';
import 'package:rxdart/rxdart.dart';

class GooglePlaceAutoCompleteTextField extends StatefulWidget {
  final InputDecoration inputDecoration;
  final ItemClick? itemClick;
  final GetPlaceDetailswWithLatLng? getPlaceDetailsWithLatLng;
  final VoidCallback? onClick;
  final ShapeChange? shapeChange; //Changing the shape of search box
  final bool isLatLngRequired;

  final TextStyle textStyle;
  final String googleAPIKey;
  final int debounceTime;
  List<String>? countries = [];
  TextEditingController textEditingController = TextEditingController();

  GooglePlaceAutoCompleteTextField(
      {required this.textEditingController,
      required this.googleAPIKey,
      this.debounceTime = 600,
      this.inputDecoration = const InputDecoration(),
      this.itemClick,
      this.isLatLngRequired = true,
      this.textStyle = const TextStyle(),
      this.countries,
      this.getPlaceDetailsWithLatLng,
      this.onClick,
      this.shapeChange,
      super.key});

  @override
  State<GooglePlaceAutoCompleteTextField> createState() =>
      _GooglePlaceAutoCompleteTextFieldState();
}

class _GooglePlaceAutoCompleteTextFieldState
    extends State<GooglePlaceAutoCompleteTextField> {
  final subject = PublishSubject<String>();
  OverlayEntry? _overlayEntry;
  List<Prediction> alPredictions = [];
  late OverlayState _overlayState;

  TextEditingController controller = TextEditingController();
  final LayerLink _layerLink = LayerLink();
  bool isSearched = false;

  @override
  Widget build(BuildContext context) {
    _overlayState = Overlay.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: TextFormField(
        decoration: widget.inputDecoration,
        cursorColor: kBackgroundColor,
        style: kTextFieldTextStyle,
        onTap: widget.onClick,
        controller: widget.textEditingController,
        onChanged: (string) {
          subject.add(string);

          //Changing/Animating the search box shape dynamically
          if (string.isNotEmpty) {
            widget.shapeChange!(true);
          } else {
            widget.shapeChange!(false);
          }
        },
      ),
    );
  }

  getLocation(String text) async {
    Dio dio = Dio();
    String url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$text&key=${widget.googleAPIKey}";

    if (widget.countries != null) {
      // in

      for (int i = 0; i < widget.countries!.length; i++) {
        String country = widget.countries![i];

        if (i == 0) {
          url = "$url&components=country:$country";
        } else {
          url = "$url|country:$country";
        }
      }
    }

    Response response = await dio.get(url);
    PlacesAutocompleteResponse subscriptionResponse =
        PlacesAutocompleteResponse.fromJson(response.data);

    if (text.isEmpty) {
      alPredictions.clear();
      _overlayEntry!.remove();
      return;
    }

    isSearched = false;
    if (subscriptionResponse.predictions!.isNotEmpty) {
      alPredictions.clear();
      alPredictions.addAll(subscriptionResponse.predictions!);
    }

    /*if (_overlayEntry == null) { // TODO: Learning : It was showing problem because _overlayEntry is not null but not mounted
      _overlayEntry = _createOverlayEntry();
      Overlay.of(context).insert(_overlayEntry!);
    } else {
      _overlayEntry?.markNeedsBuild();
    }*/

    if (_overlayEntry == null || !_overlayEntry!.mounted) {
      _overlayEntry = _createOverlayEntry();
      _overlayState.insert(_overlayEntry!);
    } else {
      _overlayState.setState(() {});
    }
  }

  @override
  void initState() {
    subject.stream
        .distinct()
        .debounceTime(Duration(milliseconds: widget.debounceTime))
        .listen(textChanged);
    super.initState();
  }

  textChanged(String text) async {
    getLocation(text);
  }

  OverlayEntry? _createOverlayEntry() {
    RenderBox renderBox = context.findRenderObject() as RenderBox;
    var size = renderBox.size;
    var offset = renderBox.localToGlobal(Offset.zero);
    return OverlayEntry(
        builder: (context) => Positioned(
              left: offset.dx,
              top: size.height + offset.dy,
              width: size.width,
              child: CompositedTransformFollower(
                showWhenUnlinked: false,
                link: _layerLink,
                offset: Offset(
                    0.0, size.height), //offset: Offset(0.0, size.height + 5.0),
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(30),
                      bottomRight: Radius.circular(30)),
                  child: BackdropFilter(
                    filter: ui.ImageFilter.blur(
                      sigmaX: 20.0,
                      sigmaY: 20.0,
                    ),
                    child: Material(
                      color: kBackgroundColor.withOpacity(0.5),
                      elevation: 0.0,
                      shadowColor: Colors.transparent,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: alPredictions.length,
                        itemBuilder: (BuildContext context, int index) {
                          return InkWell(
                            onTap: () {
                              //Changing/Animating the search box shape dynamically
                              widget.shapeChange!(false);

                              if (index < alPredictions.length) {
                                widget.itemClick!(alPredictions[index]);
                                if (!widget.isLatLngRequired) return;

                                getPlaceDetailsFromPlaceId(
                                    alPredictions[index]);
                              }

                              removeOverlay();
                            },
                            child: Container(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  alPredictions[index].description!,
                                  style: kTextFieldTextStyle.copyWith(
                                      color: kCardColor),
                                )),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ));
  }

  removeOverlay() {
    alPredictions.clear();
    _overlayEntry = _createOverlayEntry();

    _overlayState.insert(_overlayEntry!);
    _overlayEntry!.markNeedsBuild();
  }

  Future<Response?> getPlaceDetailsFromPlaceId(Prediction prediction) async {
    //String key = GlobalConfiguration().getString('google_maps_key');

    var url =
        "https://maps.googleapis.com/maps/api/place/details/json?placeid=${prediction.placeId}&key=${widget.googleAPIKey}";
    Response response = await Dio().get(
      url,
    );

    PlaceDetails placeDetails = PlaceDetails.fromJson(response.data);

    prediction.lat = placeDetails.result!.geometry!.location!.lat.toString();
    prediction.lng = placeDetails.result!.geometry!.location!.lng.toString();

    widget.getPlaceDetailsWithLatLng!(prediction);

//    prediction.latLng =  LatLng(
//        placeDetails.result.geometry.location.lat,
//        placeDetails.result.geometry.location.lng);
  }
}

PlacesAutocompleteResponse parseResponse(Map responseBody) {
  return PlacesAutocompleteResponse.fromJson(
      responseBody as Map<String, dynamic>);
}

PlaceDetails parsePlaceDetailMap(Map responseBody) {
  return PlaceDetails.fromJson(responseBody as Map<String, dynamic>);
}

typedef ItemClick = void Function(Prediction postalCodeResponse);
typedef GetPlaceDetailswWithLatLng = void Function(
    Prediction postalCodeResponse);

typedef ShapeChange = void Function(bool changeNow);
