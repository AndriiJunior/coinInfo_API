import 'dart:convert';
import 'dart:math';

import 'package:coin_info_app/pages/details_page.dart';
import 'package:coin_info_app/services/http_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double? _deviceHeight, _deviceWidth;
  HTTPService? _http;
  String? _selectedCoin = "bitcoin";
  String? _selectedCurrency = 'usd';
  @override
  void initState() {
    super.initState();
    _http = GetIt.instance.get<HTTPService>();
  }

  @override
  Widget build(BuildContext context) {
    _deviceHeight = MediaQuery.of(context).size.height;
    _deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _selectedCoinDropdown(),
              _dateWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _selectedCoinDropdown() {
    List<String> _coins = [
      "bitcoin",
      "ethereum",
      "tether",
      "cardano",
      "binancecoin",
      "binance-usd",
      "ripple",
      "doggicoin",
    ];
    List<DropdownMenuItem<String>> _items = _coins
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 40,
                    fontWeight: FontWeight.w600),
              ),
            ))
        .toList();
    return DropdownButton(
      value: _selectedCoin,
      items: _items,
      onChanged: (_value) {
        setState(() {
          _selectedCoin = _value;
        });
      },
      dropdownColor: Colors.indigo[700],
      iconSize: 30,
      icon: Icon(
        Icons.arrow_drop_down_circle_rounded,
        color: Colors.white,
      ),
      underline: Container(),
    );
  }

  Widget _dateWidget() {
    return FutureBuilder(
      future: _http!.get('/coins/$_selectedCoin'),
      builder: ((BuildContext _context, AsyncSnapshot _snapshot) {
        if (_snapshot.hasData) {
          Map _date = jsonDecode(_snapshot.data.toString());
          num _prise = _date['market_data']['current_price'][_selectedCurrency];
          num _percentageChanged =
              _date['market_data']['price_change_percentage_24h'];

          Map _exchangeRate = _date['market_data']['current_price'];

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                onDoubleTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext _context) {
                        return DetailPage(
                          rates: _exchangeRate,
                        );
                      },
                    ),
                  );
                },
                child: _imgURLWidget(_date['image']['large']),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: _currentPriceWidget(_prise),
                  ),
                  Container(
                    child: _selectedCurrencyDropdown(),
                  ),
                ],
              ),
              _percentageChangedWidget(_percentageChanged),
              _descriptionCardWidget(_date['description']['en'])
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
      }),
    );
  }

  Widget _currentPriceWidget(num _price) {
    return Text(
      "${_price.toStringAsFixed(2)}",
      style: TextStyle(
        color: Color.fromARGB(255, 33, 205, 42),
        fontSize: 30,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _percentageChangedWidget(num _percentChanged) {
    return Text(
      "${_percentChanged.toString()} %",
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget _imgURLWidget(String _imgURL) {
    return Container(
      padding: EdgeInsets.symmetric(
        vertical: _deviceHeight! * 0.02,
      ),
      height: _deviceHeight! * 0.15,
      width: _deviceWidth! * 0.15,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(_imgURL),
        ),
      ),
    );
  }

  Widget _descriptionCardWidget(String _description) {
    return Container(
      height: _deviceHeight! * 0.45,
      width: _deviceWidth! * 0.90,
      margin: EdgeInsets.symmetric(vertical: _deviceHeight! * 0.05),
      padding: EdgeInsets.symmetric(
          vertical: _deviceHeight! * 0.01, horizontal: _deviceWidth! * 0.01),
      color: Colors.lightBlue[700],
      child: Text(
        _description,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _selectedCurrencyDropdown() {
    List<String> _currency = [
      "usd",
      "uah",
      "eur",
      "huf",
      'pln',
    ];
    List<DropdownMenuItem<String>> _items = _currency
        .map((e) => DropdownMenuItem(
              value: e,
              child: Text(
                e.toUpperCase(),
                style: TextStyle(
                  color: Color.fromARGB(255, 43, 175, 49),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ))
        .toList();
    return DropdownButton(
      value: _selectedCurrency,
      items: _items,
      onChanged: (_value) {
        setState(() {
          _selectedCurrency = _value;
        });
      },
      dropdownColor: Colors.indigo[700],
      iconSize: 20,
      icon: Icon(
        Icons.arrow_drop_down_circle_rounded,
        color: Colors.green[800],
      ),
      underline: Container(),
    );
  }
}
