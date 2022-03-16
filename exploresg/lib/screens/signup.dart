import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class SignUpScreen extends StatefulWidget {
  static const routeName = "/signup";

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Color(0xfffffcec),
      body: Column(
        children: [
          Stack(
              clipBehavior: Clip.none,
              children: [
                FittedBox(
                    fit: BoxFit.fill,
                    child: SvgPicture.asset('assets/img/login-top.svg',
                      width: MediaQuery.of(context).size.width,)
                ),
                Positioned(
                  top: _height*1/5,
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 40),
                    width: MediaQuery.of(context).size.width - 80,
                    height: 420,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(height: 25),
                          Text(
                              "sign up",
                              style: TextStyle(
                                fontFamily: 'MadeSunflower',
                                color: Color(0xff22254C),
                                fontSize: 36,
                              )
                          ),
                          SizedBox(height: 60),
                          Text(
                              'email',
                              style: TextStyle(
                                fontFamily: 'AvenirLtStd',
                                color: Color(0xffD1D1D6),
                                fontSize: 13,
                              )
                          ),
                          Divider(
                            color: Color(0xffD1D1D6),
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 40),
                          Text(
                              'password',
                              style: TextStyle(
                                fontFamily: 'AvenirLtStd',
                                color: Color(0xffD1D1D6),
                                fontSize: 13,
                              )
                          ),
                          Divider(
                            color: Color(0xffD1D1D6),
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 40),
                          Text(
                              'phone number',
                              style: TextStyle(
                                fontFamily: 'AvenirLtStd',
                                color: Color(0xffD1D1D6),
                                fontSize: 13,
                              )
                          ),
                          Divider(
                            color: Color(0xffD1D1D6),
                            indent: 30,
                            endIndent: 30,
                          ),
                          SizedBox(height: 30),
                          ElevatedButton(onPressed: () {},
                            child: Text('sign up',
                                style: TextStyle(
                                  fontFamily: 'AvenirLtStd',
                                  color: Colors.white,
                                  fontSize: 16,
                                )
                            ),
                            style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                                primary: Color(0xff6488E5),
                                elevation: 0,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                            ),
                          ),
                        ]
                    ),
                  ),
                ),
              ]
          ),
          Container(
            margin: EdgeInsets.only(left: 40, right: 40, top: _height*1/4 + 50),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(onPressed: () {},
                    icon: Icon(
                      Icons.abc,
                      color: Colors.black,
                    ),
                    label: Text('Google',
                        style: TextStyle(
                          fontFamily: 'AvenirLtStd',
                          color: Color(0xff22254C),
                          fontSize: 13,
                        )
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                        primary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ),
                SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(onPressed: () {},
                    icon: Icon(
                      Icons.abc,
                      color: Colors.black,
                    ),
                    label: Text('Facebook',
                        style: TextStyle(
                          fontFamily: 'AvenirLtStd',
                          color: Color(0xff22254C),
                          fontSize: 13,
                        )
                    ),
                    style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 7),
                        primary: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Text.rich(
              TextSpan(
                  style: TextStyle(fontFamily: 'AvenirLtStd', fontSize: 13,),
                  children: [
                    TextSpan(text: "already have an account? ", style: TextStyle(color: Color(0xff22254C))),
                    TextSpan(text: "sign in", style: TextStyle(color: Color(0xff6488E5))),
                  ]
              )
          )
        ],
      ),
    );
  }
}
