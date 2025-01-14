import 'dart:math';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void main() {
  runApp(DiceGameApp());
}

class DiceGameApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DiceGameScreen(),
    );
  }
}

class DiceGameScreen extends StatefulWidget {
  @override
  _DiceGameScreenState createState() => _DiceGameScreenState();
}

class _DiceGameScreenState extends State<DiceGameScreen> {
  int walletBalance = 10;
  int wager = 0;
  String selectedGameType = "2 Alike";
  final TextEditingController wagerController = TextEditingController();

  void playGame() {
    if (wager <= 0 || wager > walletBalance) {
      Fluttertoast.showToast(msg: "Invalid wager amount!");
      return;
    }

    int maxWager = 0;
    int multiplier = 0;
    switch (selectedGameType) {
      case "2 Alike":
        maxWager = walletBalance ~/ 2;
        multiplier = 2;
        break;
      case "3 Alike":
        maxWager = walletBalance ~/ 3;
        multiplier = 3;
        break;
      case "4 Alike":
        maxWager = walletBalance ~/ 4;
        multiplier = 4;
        break;
    }

    if (wager > maxWager) {
      Fluttertoast.showToast(msg: "Wager exceeds maximum allowed for $selectedGameType!");
      return;
    }

    List<int> diceRolls = List.generate(4, (_) => Random().nextInt(6) + 1);
    Map<int, int> counts = {};

    for (var roll in diceRolls) {
      counts[roll] = (counts[roll] ?? 0) + 1;
    }

    bool isWin = counts.values.any((count) => count >= multiplier);

    if (isWin) {
      walletBalance += wager * multiplier;
      Fluttertoast.showToast(msg: "You won! Dice: $diceRolls");
    } else {
      walletBalance -= wager * multiplier;
      Fluttertoast.showToast(msg: "You lost! Dice: $diceRolls");
    }

    setState(() {
      wagerController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stake Dice Game"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Wallet Balance: \$${walletBalance}", style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            TextField(
              controller: wagerController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Enter Wager",
              ),
              onChanged: (value) {
                setState(() {
                  wager = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            DropdownButton<String>(
              value: selectedGameType,
              onChanged: (value) {
                setState(() {
                  selectedGameType = value!;
                });
              },
              items: ["2 Alike", "3 Alike", "4 Alike"].map((String type) {
                return DropdownMenuItem<String>(
                  value: type,
                  child: Text(type),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: playGame,
              child: Text("Go"),
            ),
          ],
        ),
      ),
    );
  }
}
