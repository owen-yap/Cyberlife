import 'package:cyberlife/theme.dart';
import 'package:flutter/material.dart';

class TestNavigationCard extends StatelessWidget {
  final String testIconFilePath;
  final String testName;
  final String testTime;
  final void Function() onTap;
  final bool completed;

  const TestNavigationCard({
    super.key,
    required this.testIconFilePath,
    required this.testName,
    required this.testTime,
    required this.onTap,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: screenWidth * 0.45,
            width: screenWidth * 0.4,
            decoration: BoxDecoration(
              color: completed
                  ? AppTheme.lightGreen.withOpacity(0.3)
                  : Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  offset: const Offset(-6, 6),
                  blurRadius: 40,
                  spreadRadius: 1,
                  color: Colors.grey.withOpacity(0.1),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(50.0)),
                          border: Border.all(
                            color: Colors.grey,
                            width: 1.0,
                          )),
                      child: Center(
                        child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage(testIconFilePath),
                              fit: BoxFit.scaleDown,
                            ),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(50.0)),
                          ),
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          testTime,
                          style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.green,
                              fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Image.asset(
                          'assets/images/png/clock.png',
                          height: 16,
                          width: 16,
                        ),
                      ],
                    )
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Flexible(
                      child: Text(testName,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      completed ? 'Redo Test?' : 'Start Test',
                      style: TextStyle(
                        color: completed
                            ? AppTheme.red.withOpacity(0.75)
                            : AppTheme.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    completed
                        ? const SizedBox.shrink()
                        : Icon(
                            Icons.chevron_right,
                            color: AppTheme.green,
                          ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
