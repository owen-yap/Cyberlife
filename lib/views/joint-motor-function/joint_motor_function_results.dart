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

class JointMotorFunctionResults extends StatefulWidget {
  final Joints joint;
  final AngleList angleList;

  const JointMotorFunctionResults(
      {Key? key, required this.joint, required this.angleList})
      : super(key: key);

  @override
  State<JointMotorFunctionResults> createState() =>
      _JointMotorFunctionResultsState();
}

class _JointMotorFunctionResultsState extends State<JointMotorFunctionResults> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String jointString = Strings.fromJointEnum[widget.joint]!;
    CommonAppBar appBar = CommonAppBar(title: "Results ($jointString)");

    print(widget.angleList.angleList);

    final appStateNotifier = Provider.of<AppStateNotifier>(context);

    return Consumer<AppStateNotifier>(builder: (context, notifier, child) {
      ThemeData theme = Theme.of(context);

      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat('EEEE, d MMMM yyyy');
      DateFormat timeFormat = DateFormat.jm();

      String dateString = dateFormat.format(now);
      String timeString = timeFormat.format(now);

      String minAngle = "${widget.angleList.minAngle().toStringAsFixed(1)} deg";
      String maxAngle = "${widget.angleList.maxAngle().toStringAsFixed(1)} deg";

      return Scaffold(
          appBar: appBar,
          body: Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 36),
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
                  const Expanded(
                    child: SizedBox(height: 30),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Minimum Angle",
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            minAngle,
                            style: theme.textTheme.displayMedium,
                          )
                        ],
                      ),
                      const SizedBox(width: 30),
                      Column(
                        children: [
                          Text(
                            "Maximum Angle",
                            style: theme.textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            maxAngle,
                            style: theme.textTheme.displayMedium,
                          )
                        ],
                      ),
                    ],
                  ),
                  const Expanded(
                    child: SizedBox(height: 30),
                  ),
                  SizedBox(
                      height: 200, child: widget.angleList.generateChart()),
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
                        appStateNotifier.markJointTest(
                            widget.joint, true, widget.angleList);
                        Navigator.popUntil(
                            context,
                            ((route) =>
                                route.settings.name ==
                                jointMotorFunctionMainRoute));
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
