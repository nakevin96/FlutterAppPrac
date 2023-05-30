import 'package:flutter/material.dart';
import 'package:toonflix/widgets/currency_card.dart';
import './widgets/button.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color(0xFF181818),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Hello Miu 😎',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              )),
                          Text('Welcom Back!!',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white.withOpacity(0.8),
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 80,
                  ),
                  Text(
                    "Total Balance",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 24,
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "\$5 194 482",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 44,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Button(
                        text: 'Transfer',
                        bgColor: Color(0xfff2b33a),
                        textColor: Colors.black,
                      ),
                      Button(
                          text: 'Request',
                          bgColor: Color(0xff1f2123),
                          textColor: Colors.white),
                    ],
                  ),
                  const SizedBox(
                    height: 88,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        "Wallets",
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        "view All",
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const CurrencyCard(
                    currencyName: 'Euro',
                    balance: '6 328',
                    currencyUnit: 'EUR',
                    currencyIcon: Icons.euro_rounded,
                    isInverted: false,
                  ),
                  Transform.translate(
                    offset: const Offset(0, -20),
                    child: const CurrencyCard(
                      currencyName: 'Bitcoin',
                      balance: '4.0',
                      currencyUnit: 'BTC',
                      currencyIcon: Icons.currency_bitcoin_rounded,
                      isInverted: true,
                    ),
                  ),
                  Transform.translate(
                    offset: const Offset(0, -40),
                    child: const CurrencyCard(
                      currencyName: 'Dollar',
                      balance: '7 742000',
                      currencyUnit: 'USD',
                      currencyIcon: Icons.attach_money_rounded,
                      isInverted: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
