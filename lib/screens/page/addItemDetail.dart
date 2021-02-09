import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:image_picker/image_picker.dart';
import 'package:auction_app/screens/page/boxcolor.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:auction_app/services/database.dart';

class AddItemDetail extends StatefulWidget {
  @override
  _AddItemDetailState createState() => _AddItemDetailState();
}

class _AddItemDetailState extends State<AddItemDetail> {
  final _formKey = GlobalKey<FormState>();
  final _myController = TextEditingController();
  List<TextEditingController> _controller = List<TextEditingController>(20);
  Map<String, dynamic> _mapController = {};
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now();
  Color caseColor = Colors.white;
  Color keycapColor = Colors.white;
  File _image;
  bool loading = false;

  void fetchData() {
    _mapController = {
      'desc': _controller[0] = TextEditingController(),
      'name': _controller[1] = TextEditingController(),
      'brand': _controller[2] = TextEditingController(),
      'switchType': _controller[3] = TextEditingController(),
      'keyboardSize': _controller[4] = TextEditingController(),
      'keyboardLayout': _controller[5] = TextEditingController(),
      'keyboardBacklight ': _controller[6] = TextEditingController(),
      'keycapPlastic': _controller[7] = TextEditingController(),
      'caseColor': _controller[8] = TextEditingController(
          text: caseColor
              .toString()
              .substring(10, caseColor.toString().length - 1)),
      'keycapColor': _controller[9] = TextEditingController(
          text: keycapColor
              .toString()
              .substring(10, keycapColor.toString().length - 1)),
      'weight': _controller[10] = TextEditingController(),
      'condition': _controller[11] = TextEditingController(),
      'startDate': _controller[12] = TextEditingController(
          text: DateFormat('dd MMMM yyyy').format(DateTime.now()).toString()),
      'endDate': _controller[13] = TextEditingController(
          text: DateFormat('dd MMMM yyyy').format(DateTime.now()).toString()),
      'currentPrice': _controller[14] = TextEditingController(),
      'bidIncrement': _controller[15] = TextEditingController(),
    };
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ListView(
        children: <Widget>[
          // Keyboard Desc
          Container(
            padding: EdgeInsets.all(10.0),
            height: 120,
            color: Color(0xffF8F6F4),
            child: TextFormField(
              validator: (val) {
                if (val.isEmpty) {
                  return 'The keyboard description field is required';
                }
                return null;
              },
              style: TextStyle(
                  color: Color(0xff3F4D55),
                  letterSpacing: 1.0,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic),
              controller: _mapController['desc'],
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Description of your keyboard',
                hintStyle: TextStyle(
                  color: Color(0xff3F4D55),
                  letterSpacing: 1,
                  fontSize: 12.0,
                  fontWeight: FontWeight.normal,
                  fontStyle: FontStyle.italic,
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF8F6F4),
                  ),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF8F6F4),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xffF8F6F4),
                  ),
                ),
                prefixIcon: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    elevation: 3.0,
                    child: GestureDetector(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(5.0),
                        child: _image == null
                            ? Image.asset('assets/images/addPhoto.png')
                            : Image.file(
                                _image,
                                height: 70.0,
                                width: 70.0,
                                fit: BoxFit.cover,
                              ),
                      ),
                      onTap: () {
                        showDialog(context: context, child: _addPhoto());
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              children: <Widget>[
                _buildTextFormField(
                    'Name', false, false, _mapController['name']),
                _buildTextFormField(
                    'Brand', true, false, _mapController['brand']),
                _buildTextFormField(
                    'Switch Type', false, false, _mapController['switchType']),
                _buildTextFormField('Keyboard Size', true, false,
                    _mapController['keyboardSize']),
                _buildTextFormField('Keyboard Layout', false, false,
                    _mapController['keyboardLayout']),
                _buildTextFormField('Keycap Plastic', true, false,
                    _mapController['keycapPlastic']),
                _buildTextFormField(
                    'Case Color', false, true, _mapController['caseColor']),
                _buildTextFormField(
                    'Keycap Color', true, true, _mapController['keycapColor']),
                _buildTextFormField(
                    'Weight', false, false, _mapController['weight']),
                _buildTextFormField(
                    'Condition', true, false, _mapController['condition']),
                _buildTextFormField(
                    'Start Date', false, true, _mapController['startDate']),
                _buildTextFormField(
                    'End Date', true, true, _mapController['endDate']),
                _buildTextFormField(
                    'Open Price', false, false, _mapController['currentPrice']),
                _buildTextFormField('Bid Increment', true, false,
                    _mapController['bidIncrement']),
              ],
            ),
          ),
          SizedBox(height: 50.0),
          FlatButton(
            onPressed: () async {
              if (_formKey.currentState.validate()) {
                String desc = _mapController['desc'].text;
                String name = _mapController['name'].text;
                String brand = _mapController['brand'].text;
                String switchType = _mapController['switchType'].text;
                String keyboardSize = _mapController['keyboardSize'].text;
                String keyboardLayout = _mapController['keyboardLayout'].text;
                String keycapPlastic = _mapController['keycapPlastic'].text;
                String weight = _mapController['weight'].text;
                String condition = _mapController['condition'].text;
                String currentPrice = _mapController['currentPrice'].text;
                String bidIncrement = _mapController['bidIncrement'].text;
                String image = await uploadPic();
                String status = 'Available';
                setState(() => loading = true);
                //Add Keyboard to Firestore
                await DatabaseService().setKeyboard(
                    desc,
                    name,
                    brand,
                    switchType,
                    keyboardSize,
                    keyboardLayout,
                    keycapPlastic,
                    caseColor.toString(),
                    keycapColor.toString(),
                    weight,
                    condition,
                    startDate,
                    endDate,
                    currentPrice,
                    bidIncrement,
                    image,
                    status);
                if (image != null) {
                  setState(() {
                    loading = false;
                    showDialog(
                      builder: (context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return Image.asset(
                            'assets/images/itemsavedialog.png');
                      },
                      context: context,
                    );
                  });
                }
              } else {
                return null;
              }
            },
            child: Image(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/buttonSave.png'),
            ),
          ),
          SizedBox(height: 50.0),
        ],
      ),
    );
  }

  InputDecoration _inputDecoration(String desc, bool isDark) {
    return InputDecoration(
      prefix: _boxColor(desc),
      contentPadding: EdgeInsets.all(15.0),
      fillColor: isDark ? Color(0xffF8F6F4) : Color(0xffFFFFFF),
      filled: true,
      prefixText: desc == 'Price' ? '€ ' : null,
      prefixStyle: TextStyle(
        fontSize: 12.0,
        color: Color(0xff3F4D55),
      ),
      border: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffF8F6F4),
        ),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffF8F6F4),
        ),
      ),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(
          color: Color(0xffF8F6F4),
        ),
      ),
      prefixIcon: Container(
        width: 120.0,
        padding: EdgeInsets.fromLTRB(15.0, 15.0, 0, 15.0),
        child: Text(
          desc,
          style: TextStyle(
            color: Color(0xff3F4D55),
            fontWeight: FontWeight.bold,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _boxColor(desc) {
    if (desc == 'Case Color') {
      return BoxColor(color: _mapController['caseColor'].text);
    } else if (desc == 'Keycap Color') {
      return BoxColor(color: _mapController['keycapColor'].text);
    } else {
      return null;
    }
  }

  Widget _buildTextFormField(String desc, bool isDark, bool readOnly,
      TextEditingController controller) {
    return TextFormField(
      validator: (val) {
        if (val.isEmpty) {
          return 'The $desc field is required';
        }
        return null;
      },
      onTap: readOnly
          ? () {
              if (desc == 'Start Date') {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                  confirmText: 'OK',
                  cancelText: '',
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Color(0xffDBBEA7),
                          onPrimary: Colors.white,
                          surface: Color(0xff3F4D55),
                          onSurface: Color(0xffDBBEA7),
                        ),
                        dialogBackgroundColor: Color(0xff3F4D55),
                      ),
                      child: child,
                    );
                  },
                ).then((value) {
                  setState(() {
                    startDate = value;
                    _mapController['startDate'].text =
                        DateFormat('dd MMMM yyyy').format(value);
                  });
                });
              } else if (desc == 'End Date') {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now().subtract(new Duration(days: -2)),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                  confirmText: 'OK',
                  cancelText: '',
                  builder: (BuildContext context, Widget child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        colorScheme: ColorScheme.dark(
                          primary: Color(0xffDBBEA7),
                          onPrimary: Colors.white,
                          surface: Color(0xff3F4D55),
                          onSurface: Color(0xffDBBEA7),
                        ),
                        dialogBackgroundColor: Color(0xff3F4D55),
                      ),
                      child: child,
                    );
                  },
                ).then((value) {
                  setState(() {
                    endDate = value;
                    _mapController['endDate'].text =
                        DateFormat('dd MMMM yyyy').format(value);
                  });
                });
              } else if (desc == 'Case Color') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: HexColor('FFFFFF'),
                          onColorChanged: (color) {
                            setState(() {
                              caseColor = color;
                              _mapController['caseColor'].text = caseColor
                                  .toString()
                                  .substring(10, color.toString().length - 1);
                            });
                          },
                        ),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else if (desc == 'Keycap Color') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Select a color'),
                      content: SingleChildScrollView(
                        child: ColorPicker(
                          pickerColor: HexColor('FFFFFF'),
                          onColorChanged: (color) {
                            setState(() {
                              keycapColor = color;
                              _mapController['keycapColor'].text = keycapColor
                                  .toString()
                                  .substring(10, color.toString().length - 1);
                            });
                          },
                        ),
                      ),
                      actions: [
                        FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              }
            }
          : null,
      style: TextStyle(
        fontSize: 12.0,
        color: desc == 'URL'
            ? Colors.blue
            : (desc == 'Case Color' || desc == 'Keycap Color'
                ? Color(0xffFFFFFF)
                : Color(0xff3F4D55)),
      ),
      controller: controller,
      readOnly: readOnly,
      decoration: _inputDecoration(desc, isDark),
    );
  }

  Widget _addPhoto() {
    Future getImageGallery() async {
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        if (_image != null) {
          _image = image;
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
        }
      });
    }

    Future getImageCamera() async {
      var image = await ImagePicker.pickImage(source: ImageSource.camera);
      setState(() {
        _image = image;
        if (_image != null) {
          Navigator.of(context).pop();
        } else {
          Navigator.of(context).pop();
        }
      });
    }

    return SimpleDialog(
      backgroundColor: HexColor('#E1C8B4'),
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(bottom: 10),
          child: Column(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: getImageCamera,
                child: Text(
                  'Take a picture',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    color: HexColor('#3F4D55'),
                  ),
                ),
              ),
              Divider(
                color: Colors.white,
                thickness: 1.0,
              ),
            ],
          ),
        ),
        Container(
          child: Column(
            children: <Widget>[
              SimpleDialogOption(
                onPressed: getImageGallery,
                child: Text(
                  'Choose from Album',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.normal,
                    color: HexColor('#3F4D55'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<String> uploadPic() async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference firebaseStrorageRef =
        FirebaseStorage.instance.ref().child('keyboard/' + fileName);
    StorageUploadTask uploadTask = firebaseStrorageRef.putFile(_image);
    StorageTaskSnapshot taskSnapshot = await uploadTask.onComplete;
    var imageURL = await taskSnapshot.ref.getDownloadURL();
    if (uploadTask.isComplete) {
      String img = imageURL.toString();
      return img;
    } else {
      return null;
    }
  }
}
