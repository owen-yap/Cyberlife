import 'package:cyberlife/constants/routes.dart';
import 'package:cyberlife/constants/strings.dart';
import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/app_state.dart';
import 'package:cyberlife/theme.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GripReleaseResults extends StatefulWidget {
  final int fistsMade;

  const GripReleaseResults({Key? key, required this.fistsMade})
      : super(key: key);

  @override
  State<GripReleaseResults> createState() => _GripReleaseResultsState();
}

class _GripReleaseResultsState extends State<GripReleaseResults> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar =
        const CommonAppBar(title: "Results (Grip Release Test)");

    final appStateNotifier = Provider.of<AppStateNotifier>(context);

    return Consumer<AppStateNotifier>(builder: (context, notifier, child) {
      ThemeData theme = Theme.of(context);

      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat('EEEE, d MMMM yyyy');
      DateFormat timeFormat = DateFormat.jm();

      String dateString = dateFormat.format(now);
      String timeString = timeFormat.format(now);

      return Scaffold(
          appBar: appBar,
          body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Expanded(
                    child: SizedBox(height: 30),
                  ),
                  Text(
                    dateString,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    timeString,
                    style: theme.textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 36),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Number of Fists Made",
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            "${widget.fistsMade}",
                            style: theme.textTheme.displayMedium,
                          )
                        ],
                      ),
                    ],
                  ),
                  const Expanded(
                    child: SizedBox(height: 30),
                  ),
                  ElevatedButton(
                      style: theme.elevatedButtonTheme.style!.copyWith(
                          padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 48.0),
                      )),
                      onPressed: () {
                        appStateNotifier.resetGripRelease();
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Redo",
                        style: Theme.of(context).textTheme.displayMedium,
                      )),
                  const SizedBox(height: 30),
                  ElevatedButton(
                      style: theme.elevatedButtonTheme.style!.copyWith(
                          padding: MaterialStateProperty.all(
                        const EdgeInsets.symmetric(
                            vertical: 18.0, horizontal: 48.0),
                      )),
                      onPressed: () {
                        appStateNotifier.recordGripRelease(widget.fistsMade);
                        Navigator.popUntil(context,
                            ((route) => route.isFirst));
                      },
                      child: Text(
                        "Submit",
                        style: Theme.of(context).textTheme.displayMedium,
                      )),
                  const SizedBox(height: 18)
                ],
              )));
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
}
