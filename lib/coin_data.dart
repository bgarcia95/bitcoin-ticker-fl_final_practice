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
    Map<String, String> cryptoPrices = {};

    for (String crypto in cryptoList) {
      http.Response response =
          await http.get('$bitCoinAverageURL/$crypto$currency');

      if (response.statusCode == 200) {
        try {
          var decodedData = jsonDecode(response.body);
          double lastPrice = decodedData['last'];
          cryptoPrices[crypto] = lastPrice.toStringAsFixed(0);
        } catch (e) {
          print(e);
        }
      } else {
        print(response.statusCode);
        throw 'Problem with the get request.';
      }
    }

    print(cryptoPrices);
    return cryptoPrices;
  }
}
