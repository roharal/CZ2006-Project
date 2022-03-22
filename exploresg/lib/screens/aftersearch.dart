import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:exploresg/helper/utils.dart';

class AfterSearchScreen extends StatefulWidget {
  static const routeName = "/aftersearch";
  @override
  State<AfterSearchScreen> createState() => _AfterSearchState();
}

class _AfterSearchState extends State<AfterSearchScreen> {
  bool _searchByCategory = false;
  String _placetypedropdownValue = 'place type';
  String _filterbydropdownValue = 'filter by';
  String _sortbydropdownValue = 'sort by';
  TextEditingController _searchController = new TextEditingController();

  InputDecoration dropdownDeco = InputDecoration(
      border: InputBorder.none,
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      errorBorder: InputBorder.none,
      disabledBorder: InputBorder.none,
      labelStyle: TextStyle(color: Colors.black, fontSize: 16));

  Container _dropdownlist(double width, DropdownButtonFormField DDL) {
    return Container(
        width: width,
        padding: EdgeInsets.symmetric(horizontal: 0.1 * width),
        margin: EdgeInsets.symmetric(vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.white),
        child: DDL);
  }

  Container _filterDropDown(double width) {
    return _dropdownlist(
        0.49 * width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  child: textMinor("filter by", Colors.black), value: "filter by"),
              DropdownMenuItem(child: textMinor("b", Colors.black), value: "b")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _filterbydropdownValue,
            onChanged: (String? newValue) {
              _filterbydropdownValue = newValue!;
            }));
  }

  Container _sortDropDown(double width) {
    return _dropdownlist(
        0.49 * width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(child: textMinor("sort by", Colors.black), value: "sort by"),
              DropdownMenuItem(child: textMinor("b", Colors.black), value: "b")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _sortbydropdownValue,
            onChanged: (String? newValue) {
              _sortbydropdownValue = newValue!;
            }));
  }

  Container _placeTypeDropDown(double width) {
    return _dropdownlist(
        width,
        DropdownButtonFormField<String>(
            items: [
              DropdownMenuItem(
                  child: textMinor("place type", Colors.black), value: "place type"),
              DropdownMenuItem(child: textMinor("a", Colors.black), value: "a")
            ],
            decoration: dropdownDeco,
            isExpanded: true,
            value: _placetypedropdownValue,
            onChanged: (String? newValue) {
              _placetypedropdownValue = newValue!;
            }));
  }

  Container _searchBar(double width, double height) {
    return Container(
      width: width,
      height: height / 5.4,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.white),
      child: Container(
        child: TextField(
          onSubmitted: (value) {
            print(_placetypedropdownValue +
                _filterbydropdownValue +
                _sortbydropdownValue +
                _searchController.text);
          },
          controller: _searchController,
          cursorColor: Colors.grey,
          cursorHeight: 14.0,
          style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 14),
          decoration: new InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            labelText: 'type a place...',
            labelStyle: TextStyle(
                fontFamily: 'AvenirLtStd', fontSize: 14, color: Colors.grey),
            enabledBorder: const OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: const BorderSide(
                color: Colors.white,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              borderSide: BorderSide(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Transform _searchSwitch() {
    return Transform.scale(
        transformHitTests: false,
        scale: .7,
        child: CupertinoSwitch(
          activeColor: Colors.blue,
          trackColor: Colors.blue, //change to closer colour
          value: _searchByCategory,
          onChanged: (value) {
            setState(() {
              _searchByCategory = !_searchByCategory;
            });
          },
        ));
  }

  Align _goButton() {
    return Align(
        alignment: Alignment.topRight,
        child: TextButton(
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(Colors.blue),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
              ))),
          onPressed: () {
            print(_placetypedropdownValue +
                _filterbydropdownValue +
                _sortbydropdownValue +
                _searchController.text);
          },
          child: Text("Go!",
              style: TextStyle(
                  fontFamily: 'AvenirLtStd',
                  fontSize: 12,
                  color: Colors.white)),
        ));
  }

  Widget _searchTools(double width, double height) {
    return Container(
        width: width,
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                textMinor("keyword search", Colors.black),
                _searchSwitch(),
                textMinor("dropdown list", Colors.black)
              ],
            ),
            _searchByCategory == false
                ? _searchBar(width, height)
                : _placeTypeDropDown(width),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              _filterDropDown(width),
              SizedBox(width: 0.02 * width),
              _sortDropDown(width)
            ]),
            _goButton()
          ],
        ));
  }

  // Widget _addFav(Place place) {
  //   return Expanded(
  //       child: Row(
  //           crossAxisAlignment: CrossAxisAlignment.end,
  //           mainAxisAlignment: MainAxisAlignment.center,
  //           children: [
  //         Row(children: [
  //           InkWell(
  //               onTap: () {
  //                 print("<3 pressed");
  //                 setState(() {
  //                   place.likes = !place.likes;
  //                 });
  //                 print(place.likes);
  //               },
  //               child: place.likes
  //                   ? Icon(
  //                       Icons.favorite,
  //                       color: Colors.red,
  //                     )
  //                   : Icon(
  //                       Icons.favorite_border,
  //                       color: Colors.grey,
  //                     )),
  //           SizedBox(
  //             width: 10,
  //           ),
  //           textMinor("add to favourites", Colors.black)
  //         ])
  //       ]));
  // }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: createMaterialColor(Color(0xFFFFF9ED)),
        body: Container(
            child: SingleChildScrollView(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      topBar("places", height, width, 'assets/img/afterSearchTop.png'),
                      SizedBox(height: 10),
                      _searchTools(0.80 * width, 0.3 * height),
                      SizedBox(height: 20),
              // for (place in places)
              //   placeContainer(
              //       place, 0.8 * width, 0.3 * height, _addFav(place)),
                      SizedBox(height: 0.1 * height),
                    ]
                )
            )
        )
    );
  }
}
