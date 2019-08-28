import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  @override
  void initState() {
    super.initState();
    getData();
  }

  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    for (String currency in currenciesList) {
      var newItem = DropdownMenuItem(
        child: Text(currency),
        value: currency,
      );
      dropdownItems.add(newItem);
    }

    return DropdownButton<String>(
      items: dropdownItems,
      value: selectedCurrency,
      onChanged: (String newValue) {
        setState(() {
          selectedCurrency = newValue;
          getData();
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [];
    for (String currency in currenciesList) {
      pickerItems.add(Text(currency));
    }

    return CupertinoPicker(
      children: pickerItems,
      itemExtent: 32.0,
      backgroundColor: Colors.lightBlue,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          selectedCurrency = currenciesList[selectedIndex];
          //We add method here and on DD in order to update the currency value and get the right currency value.
          getData();
        });
      },
    );
  }

  Map<String, String> coinData = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    try {
      var coinValues = await CoinData().getData(selectedCurrency);
      setState(() {
        coinData = coinValues;
      });
      isWaiting = false;
    } catch (e) {
      print(e);
    }
  }

  Column makeCards() {
    List<CryptoCard> cryptoCards = [];

    for (String crypto in cryptoList) {
      cryptoCards.add(
        CryptoCard(
          cryptoCurrency: crypto,
          cryptoValue: isWaiting ? '?' : coinData[crypto],
          selectedCurrency: selectedCurrency,
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: cryptoCards,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          makeCards(),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: iOSPicker(),
//              Platform.isIOS ? iOSPicker() : androidDropdown(),
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  final cryptoCurrency;
  final cryptoValue;
  final selectedCurrency;

  CryptoCard({this.cryptoCurrency, this.cryptoValue, this.selectedCurrency});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $cryptoValue $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
