import 'package:auction_app/screens/page/addItemDetail.dart';
import 'package:auction_app/screens/page/showAllItem.dart';
import 'package:auction_app/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  List<Widget> _widgetOptions = <Widget>[
    ShowAllItem(),
    AddItemDetail(),
    Text(
      'Index 2: Favorite',
    ),
    Text(
      'Index 3: Profile',
    ),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: HexColor('#466A64'),
        centerTitle: true,
        title: Text(
          'Keyboard Auction',
          style: TextStyle(color: HexColor('E9CBB0')),
        ),
        elevation: 0.0,
        actions: <Widget>[
          FlatButton.icon(
            color: HexColor('#466A64'),
            icon: Icon(
              Icons.person,
              color: HexColor('#D96969'),
            ),
            label: Text(
              'Logout',
              style: TextStyle(color: HexColor('#D96969')),
            ),
            onPressed: () async {
              await _auth.signOut();
            },
          )
        ],
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: _customNavbar(),
    );
  }

  Widget _customNavbar() {
    return Container(
      color: HexColor('#F8F8F8'),
      height: 70,
      padding: EdgeInsets.all(4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            height: 65,
            width: 65,
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.home,
                    color: HexColor('#E9CBB0'),
                    size: 35,
                  ),
                  Text(
                    'Home',
                    style: TextStyle(color: HexColor('#406260')),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 65,
            width: 65,
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.keyboard,
                    color: HexColor('#E9CBB0'),
                    size: 35,
                  ),
                  Text(
                    'Auction',
                    style: TextStyle(color: HexColor('#406260')),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 65,
            width: 65,
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.favorite,
                    color: HexColor('#E9CBB0'),
                    size: 35,
                  ),
                  Text(
                    'Favorite',
                    style: TextStyle(color: HexColor('#406260')),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
            ),
          ),
          Container(
            margin: EdgeInsets.all(5),
            height: 65,
            width: 65,
            child: GestureDetector(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.person,
                    color: HexColor('#E9CBB0'),
                    size: 35,
                  ),
                  Text(
                    'Profile',
                    style: TextStyle(color: HexColor('#406260')),
                  )
                ],
              ),
              onTap: () {
                setState(() {
                  _selectedIndex = 3;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
