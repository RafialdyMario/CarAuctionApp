
import 'package:auction_app/models/keyboard.dart';
import 'package:auction_app/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ShowAllItem extends StatefulWidget {
  @override
  _ShowAllItemState createState() => _ShowAllItemState();
}

class _ShowAllItemState extends State<ShowAllItem> {
  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
        return <Widget>[
          SliverList(
            delegate: SliverChildListDelegate(
              <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[_headerWidget()],
                  ),
                ),
              ],
            ),
          ),
        ];
      },
      body: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: <Widget>[],
      ),
    );
  }

  Widget _buildItems(List<dynamic> data) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        shrinkWrap: true,
        itemBuilder: (context, i) {
          Keyboard keyboard;
          var status = data[i]['status'];
          keyboard = _addKeyboard(data, i);
          return GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => TemplateDetail(
              //       clothes: clothes,
              //     ),
              //   ),
              // );
            },
            child: Stack(
              children: <Widget>[
                Card(
                  elevation: 3.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: ColorFiltered(
                        colorFilter: status == 'Sold' || status == 'Given'
                            ? ColorFilter.mode(Colors.grey, BlendMode.color)
                            : ColorFilter.mode(
                                Colors.transparent, BlendMode.color),
                        child: Image(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            '${data[i]['image']}',
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (status == 'Sold' || status == 'Given')
                  Center(
                    child: Text(
                      status,
                      style: TextStyle(
                        color: Color(0xffD96969),
                        fontSize: 16.0,
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
  
  // Future getData() async {
  //   QuerySnapshot data = await DatabaseService().getClothesByCategory();
  //   var documents = data.documents;
  //   List<DocumentSnapshot> ds = [];

  //   if (documents.isEmpty) {
  //     return null;
  //   } else {
  //     documents.forEach((e) {
  //         ds.add(e);
  //     });
  //     return ds;
  //   }
  // }

  Keyboard _addKeyboard(List<dynamic> data, int i) {
    Keyboard keyboard;
    keyboard = Keyboard(
      data[i].documentID,
      data[i]['image'],
      data[i]['desc'],
      data[i]['name'],
      data[i]['brand'],
      data[i]['switchType'],
      data[i]['keyboardSize'],
      data[i]['keyboardLayout'],
      data[i]['keycapPlastic'],
      data[i]['caseColor'],
      data[i]['keycapColor'],
      data[i]['weight'],
      data[i]['conditon'],
      data[i]['startDate'],
      data[i]['endDate'],
      data[i]['openPrice'],
      data[i]['bidIncrement'],
      data[i]['status'],
    );
    return keyboard;
  }

  Widget _headerWidget() {
    return Container(
      margin: EdgeInsets.only(top: 10.0),
      padding: EdgeInsets.symmetric(
        horizontal: 20.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 5.0),
              Text(
                'All Keyboard',
                style: TextStyle(
                  color: Color(0xff3F4D55),
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.0,
                  fontStyle: FontStyle.normal,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                '100 Items',
                style: TextStyle(
                  color: Color(0xff859289),
                  fontSize: 12.0,
                ),
              )
            ],
          ),
          Row(
            children: <Widget>[
              IconButton(
                icon: Image(
                  image: AssetImage('assets/images/searchIcon.png'),
                ),
                onPressed: () {},
              ),
              IconButton(
                icon: Image(
                  image: AssetImage('assets/images/filterIcon.png'),
                ),
                onPressed: () {},
              ),
            ],
          )
        ],
      ),
    );
  }
}
