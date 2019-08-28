import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const bitCoinAverageURL =
    'https://apiv2.bitcoinaverage.com/indices/global/ticker';

class CoinData {
  Future getData(String currency) async {
    http.Response response = await http.get('$bitCoinAverageURL/BTC$currency');

    if (response.statusCode == 200) {
      try {
        var decodedData = jsonDecode(response.body);
        var lastPrice = decodedData['last'];
        print(lastPrice);
        return lastPrice;
      } catch (e) {
        print(e);
      }
    }
  }
}
