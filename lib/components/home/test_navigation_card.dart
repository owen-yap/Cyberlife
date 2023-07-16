import 'package:flutter/material.dart';

class TestNavigationCard extends StatelessWidget {
  final String testIconFilePath;
  final String testName;
  final String testTime;
  final void Function() onTap;

  const TestNavigationCard({
    super.key,
    required this.testIconFilePath,
    required this.testName,
    required this.testTime,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            height: 180,
            width: 150,
            decoration: BoxDecoration(
              color: Colors.white,
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
                          color: Colors.white,
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
                            color: Colors.white,
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
                          style: const TextStyle(
                              fontSize: 12,
                              color: Colors.green,
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
                Expanded(
                    child: Container(
                  color: Colors.white,
                )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const Text(
                      'Start Test',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Image.asset('assets/images/png/nextArrowIcon.png',
                        height: 14, width: 14),
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
