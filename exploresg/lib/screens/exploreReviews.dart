// import 'package:exploresg/helper/authController.dart';
import 'package:exploresg/helper/reviewsController.dart';
import 'package:exploresg/helper/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:exploresg/models/place.dart';
import 'package:flutter_svg/svg.dart';

import '../models/review.dart';

class ReviewsScreen extends StatefulWidget {
  static const routeName = "/exploreReviews";
  final Place place;

  ReviewsScreen({required this.place});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  bool _isLoaded = false;
  ReviewsController _reviewsController = ReviewsController();
  // AuthController _auth = AuthController();
  List<Review> reviews = [];
  List<String> displayNames = [];
  List<String> PFPs = [];

  @override
  void initState() {
    super.initState();
    _init();

  }

  void _init() async {
    // Get list of reviews (List of Review class)
    reviews = await _reviewsController.returnAllReviews(widget.place.id);

    String tempName = '';
    for (int i=0; i < reviews.length; i++){
      tempName = await _reviewsController.getUserName(reviews[i].getUserID());
      displayNames.add(tempName);
    }

    String tempPFP = '';
    for (int i=0; i < reviews.length; i++){
      tempPFP = await _reviewsController.getPFP(reviews[i].getUserID());
      PFPs.add(tempPFP);
    }
    print('pfp urls '+PFPs.toString());

    setState(() {
      _isLoaded = true;
    });
  }

  Widget _topVector() {
    double _width = MediaQuery
        .of(context)
        .size
        .width;
    return SafeArea(
      top: true,
      child: FittedBox(
          fit: BoxFit.fill,
          child: SvgPicture.asset(
            'assets/img/place-top.svg',
            width: _width,
            height: _width * 116 / 375,
          )
      ),
    );
  }

  Widget _back() {
    return Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.only(left: 16),
        child: InkWell(
          onTap: () {Navigator.of(context).pop();},
          child: Row(
            children: [
              Icon(Icons.arrow_back_ios, color: Color(0xff22254C)),
              Text("back",
                  style: TextStyle(
                      fontFamily: 'AvenirLtStd',
                      fontSize: 14,
                      color: Color(0xff22254C)
                  ))
            ],
          ),
        ));
  }

  Widget _reviewContainer(String userName, String pfp_url, double rating, String review) {
    final _w = MediaQuery.of(context).size.width;
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(20))),
        padding: EdgeInsets.symmetric(vertical: 30, horizontal: 20),
        width: _w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  foregroundImage: NetworkImage(pfp_url),
                  backgroundColor: Color(0xff6488E5),
                  child: Text(userName[0]),
                ),
                SizedBox(width: 20,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    textMinorBold(userName, Color(0xff22254C)),
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
                  ],
                ),
              ],
            ),
          SizedBox(height: 15,),
          textMinor(review, Color(0xff22254C)),
            SizedBox(height: 15,),
        ]));
  }

  Widget _review(List<Review> reviews) {
    return ListView.builder(
      itemCount: reviews.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            _reviewContainer(displayNames[index], PFPs[index],
                reviews[index].getUserRating(), reviews[index].getUserReview()),
            SizedBox(height: 20,)
          ],
        );
      },
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final height = MediaQuery.of(context).size.height;
    // final width = MediaQuery.of(context).size.width;
    return _isLoaded
    ? Scaffold(
      backgroundColor: Color(0xfffffcec),
      body: Column(
        children: [
          _topVector(),
          _back(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 40),
            child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: 7,),
                    textMajor(widget.place.placeName, Color(0xff22254C), 36),
                    textMajor('reviews', Color(0xff22254C), 36),
                    SizedBox(height: 20),
                    reviews.isEmpty
                        ? textMinor('no reviews to show', Color(0xffd1d1d6))
                        : _review(reviews),
                    reviews.isEmpty
                        ? Container()
                        : textMinor('no more to show...', Color(0xffd1d1d6)),
                  ],
                )
            ),
          ),
        ],
      ),
    )
    : Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
