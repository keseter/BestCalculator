import 'package:flutter/material.dart';
import 'package:expressions/expressions.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import shared_preferences
import 'buttons.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userInput = "";
  String result = "";
  bool buttonPressedFlag = false;
  int usageCount = 0; // Variable to store the count of calculator uses

  @override
  void initState() {
    super.initState();
    _loadUsageCount(); // Load usage count when the page is initialized
  }

  // Function to load the usage count from shared_preferences
  void _loadUsageCount() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      usageCount = prefs.getInt('usageCount') ?? 0; // Default to 0 if not found
    });
  }

  // Function to increment and save usage count
  void _incrementUsageCount() async {
    setState(() {
      usageCount++;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('usageCount', usageCount); // Save the updated count
  }

  void buttonPressed(String value) {
    setState(() {
      if (value == 'C') {
        userInput = "";
        result = "";
      } else if (value == '=') {
        try {
          result = evaluateExpression(userInput);
          // Increment and save the usage count only when '=' is pressed
          _incrementUsageCount();
        } catch (e) {
          result = 'Error';
        }
      } else {
        userInput += value;
      }
      buttonPressedFlag = true;
    });

    // Reset flag after short delay
    Future.delayed(const Duration(milliseconds: 200), () {
      setState(() {
        buttonPressedFlag = false;
      });
    });
  }

  String evaluateExpression(String expression) {
    expression = expression.replaceAll('x', '*').replaceAll('÷', '/');
    final expr = Expression.parse(expression);
    final evaluator = ExpressionEvaluator();
    final result = evaluator.eval(expr, {});

    if (result is double || result is int) {
      return result.toString();
    } else {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.green],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Text(
            "Coolest Calculator",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 25, 160, 90),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/smartGuyIsaac.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: AnimatedPadding(
                padding: buttonPressedFlag
                    ? const EdgeInsets.only(right: 10, bottom: 80)
                    : const EdgeInsets.only(right: 10, bottom: 60),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    userInput,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: AnimatedPadding(
                padding: buttonPressedFlag
                    ? const EdgeInsets.only(right: 10, bottom: 40)
                    : const EdgeInsets.only(right: 10, bottom: 20),
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: Text(
                    result.isEmpty ? "" : "= $result",
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            // Add the usage count to display on the screen
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Calculator used $usageCount times',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                padding: const EdgeInsets.all(12),
                itemCount: buttons.length,
                itemBuilder: (context, index) {
                  return CalculatorButton(
                    buttonText: buttons[index],
                    onPressed: () => buttonPressed(buttons[index]),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

const List<String> buttons = [
  '7',
  '8',
  '9',
  '/',
  '4',
  '5',
  '6',
  '*',
  '1',
  '2',
  '3',
  '-',
  'C',
  '0',
  '=',
  '+',
];
