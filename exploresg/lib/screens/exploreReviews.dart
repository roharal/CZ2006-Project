import 'package:exploresg/helper/utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:exploresg/models/place.dart';

class ReviewsScreen extends StatefulWidget {
  static const routeName = "/exploreReviews";
  final Place place;

  ReviewsScreen({required this.place});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  Widget _review(String username, double rating, String review) {
    return Container(
        child: Column(children: [
      Text(username),
      RatingBarIndicator(
        rating: rating,
        itemBuilder: (context, index) => Icon(
          Icons.star,
          color: Colors.amber,
        ),
        itemCount: 5,
        itemSize: 20,
        direction: Axis.horizontal,
      ),
      Text(review),
    ]));
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: createMaterialColor(Color(0xfffffcec)),
      body: Container(
        child: SingleChildScrollView(
            child: Container(
                child: Column(
          children: [
            topBar("reviews", height, width, 'assets/img/accountTop.png'),
            _review("Bob", widget.place.ratings, widget.place.placeName)
          ],
        ))),
      ),
    );
  }
}
