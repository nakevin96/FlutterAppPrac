import 'package:flutter/material.dart';

class CurrencyCard extends StatelessWidget {
  final String currencyName;
  final String balance;
  final String currencyUnit;
  final IconData currencyIcon;
  final bool isInverted;

  const CurrencyCard({
    super.key,
    required this.currencyName,
    required this.balance,
    required this.currencyUnit,
    required this.currencyIcon,
    required this.isInverted,
  });

  @override
  Widget build(BuildContext context) {
    var mainThemeColor = isInverted ? Colors.white : const Color(0xFF1F2123);
    var subThemeColor = isInverted ? const Color(0xFF1F2123) : Colors.white;
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: mainThemeColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  currencyName,
                  style: TextStyle(
                    color: subThemeColor,
                    fontSize: 28,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      balance,
                      style: TextStyle(
                        color: subThemeColor,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Text(
                      currencyUnit,
                      style: TextStyle(
                        color: subThemeColor.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Transform.scale(
              scale: 2.2,
              child: Transform.translate(
                offset: const Offset(-4.0, 12.0),
                child: Icon(
                  currencyIcon,
                  color: subThemeColor,
                  size: 88,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
