import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: homePage(),
    title: "Simple Interest Calculator",
    theme: ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.blue,
      accentColor: Colors.blueAccent,
    ),
  ));
}

class homePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _homePageState();
  }
}

class _homePageState extends State<homePage> {

var _formKey=GlobalKey<FormState>();
  final _minimumPadding = 8.0;
  var _currency = ['Rupees', 'Dollars', 'Pounds', 'Euro'];
  var _currencyItemSelected = '';
  var _totalAmount = '';

  @override
  void initState() {
    super.initState();
    _currencyItemSelected = _currency[0];
  }

  TextEditingController principalController = TextEditingController();
  TextEditingController roiController = TextEditingController();
  TextEditingController termController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //resizeToAvoidBottomInset:false,

      appBar: AppBar(
        title: Text("Simple Interest Calculator"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(_minimumPadding * 2),
            child: ListView(
              children: <Widget>[
                getImageAsset(),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: TextFormField(
                    controller: principalController,
                    keyboardType: TextInputType.number,
                    validator: ( value){
                      var validateForm = _validateForm(value);
                      return validateForm;
                    },
                    decoration: InputDecoration(
                      labelText: 'Principal',
                      hintText: 'Enter Principal amount i.e 15,000',
                      errorStyle: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 14.0
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(_minimumPadding),
                      ),
                    ),
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: TextFormField(
                      controller: roiController,
                      keyboardType: TextInputType.number,
                      validator: ( value){
                        var validateForm = _validateForm(value);
                        return validateForm;
                      },
                      decoration: InputDecoration(
                        labelText: 'Interest Rate',
                        hintText: 'Enter Rate of Interest ',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(_minimumPadding),
                        ),
                      ),
                    )),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: TextFormField(
                          controller: termController,
                          keyboardType: TextInputType.number,
                          validator: ( value){
                            var validateForm = _validateForm(value);
                            return validateForm;
                          },
                          decoration: InputDecoration(
                            labelText: 'Term',
                            hintText: 'Enter number of years',
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(_minimumPadding),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        width: _minimumPadding,
                      ),
                      Container(
                        width: _minimumPadding * 5,
                      ),
                      DropdownButton<String>(
                        items: _currency
                            .map((String dropDownItem) =>
                                DropdownMenuItem<String>(
                                  child: Text(dropDownItem),
                                  value: dropDownItem,
                                ))
                            .toList(),
                        onChanged: (String newDropDownMenuItem) {
                          _onDropDownItemSelected(newDropDownMenuItem);
                        },
                        value: _currencyItemSelected,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      top: _minimumPadding, bottom: _minimumPadding),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: RaisedButton(
                              onPressed: () {
                                setState(() {
                                  if(_formKey.currentState.validate()) {
                                    this._totalAmount = _calculateTotalReturn();
                                  }
                                }
                                );

                                this._totalAmount = _calculateTotalReturn();
                              },
                              child: Text("Calculate"))),
                      Container(
                        width: _minimumPadding,
                      ),
                      Expanded(
                        child: RaisedButton(
                            onPressed: () {
                              setState(() {
                                _reset();
                              });
                            },
                            child: Text("Reset")),
                      ),
                    ],
                  ),
                ),
                Padding(
                    padding: EdgeInsets.only(
                        top: _minimumPadding, bottom: _minimumPadding),
                    child: Expanded(
                      child: Text(this._totalAmount),
                    )),
              ],
            )),
      ),
    );
  }

  Widget getImageAsset() {
    AssetImage assetImage = AssetImage('images/money.jpg');
    Image image = new Image(
      image: assetImage,
      width: 250.0,
      height: 250.0,
    );
    return Container(
      child: image,
      margin: EdgeInsets.all(_minimumPadding * 10),
    );
  }

  void _onDropDownItemSelected(String newDropDownMenuItem) {
    setState(() {
      this._currencyItemSelected = newDropDownMenuItem;
    });
  }

  String _calculateTotalReturn() {
    double principal = double.parse(principalController.text);
    double term = double.parse(termController.text);
    double roi = double.parse(roiController.text);

    double totalAmount = principal + (principal * roi * term) / 100;
    String result =
        'After $term years,your investment will be worth $totalAmount $_currencyItemSelected';
    return result;
  }

  void _reset() {
    principalController.text = '';
    roiController.text = '';
    termController.text = '';
    _totalAmount = '';
    _currencyItemSelected = _currency[0];
  }
String _validateForm(String value){
     var isNumeric=isNumericUsingRegularExpression(value);

     debugPrint('the value of isNumericUsingRegularExpression is ${isNumeric} and the string is ${value.isEmpty}');

  if(value.isEmpty || !isNumeric ){
    return 'Please enter valid Integer input.';
  }
}
bool isNumericUsingRegularExpression(String string) {
  final numericRegex =
  RegExp(r'^-?(([0-9]*)|(([0-9]*)\.([0-9]*)))$');

  return numericRegex.hasMatch(string);
}
}
