import 'package:cyberlife/models/angle_list.dart';
import 'package:cyberlife/models/app_state.dart';
import 'package:cyberlife/widgets/appbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class FingerEscapeResults extends StatefulWidget {
  final AngleList supinationAngleList;

  const FingerEscapeResults({Key? key, required this.supinationAngleList})
      : super(key: key);

  @override
  State<FingerEscapeResults> createState() => _FingerEscapeResultsState();
}

class _FingerEscapeResultsState extends State<FingerEscapeResults> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    CommonAppBar appBar =
        const CommonAppBar(title: "Results (Finger Escape Test)");

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
                  Text(
                    "Finger Supination Angle Chart",
                    style: theme.textTheme.displayMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                      height: 200, child: widget.supinationAngleList.generateChart()),
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
                        appStateNotifier.recordFingerEscape(widget.supinationAngleList);
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
