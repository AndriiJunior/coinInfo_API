import 'package:flutter/material.dart';

class DetailPage extends StatelessWidget {
  Map rates;
  DetailPage({required this.rates});

  @override
  Widget build(BuildContext context) {
    List _cerrencies = rates.keys.toList();
    List _exchangedRates = rates.values.toList();
    return Scaffold(
      body: SafeArea(
        child: ListView.builder(
            itemCount: _cerrencies.length,
            itemBuilder: (_context, _index) {
              String _currency = _cerrencies[_index].toString().toUpperCase();
              String _rates = _exchangedRates[_index].toString();
              return ListTile(
                title: Text(
                  _currency + "=" + _rates,
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              );
            }),
      ),
    );
  }
}
