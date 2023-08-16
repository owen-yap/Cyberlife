import 'package:cyberlife/models/angle_list.dart';

class FingerEscapeUserState {
  AngleList supinationAngleList = AngleList();
  bool complete = false;

  FingerEscapeUserState();

  bool isComplete() {
    return complete;
  }

  AngleList getSupinationAngleList() {
    return supinationAngleList;
  }

  void record(AngleList supinationAngleList) {
    this.supinationAngleList = supinationAngleList;
    complete = true;
  }

  void reset() {
    supinationAngleList = AngleList();
    complete = false;
  }

  @override
  String toString() {
    String result = "Finger Escape User State:\n";

    result += "complete? $complete \n";
    result += "supinationAngleList: $supinationAngleList \n";

    return result;
  }
}
