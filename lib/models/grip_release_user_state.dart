class GripReleaseUserState {
  int defaultValue = -1;
  late int fistsMade;
  bool complete = false;

  GripReleaseUserState() {
    fistsMade = defaultValue;
  }

  bool isComplete() {
    return complete;
  }

  int getFistsMade() {
    return fistsMade;
  }

  void record(int fistsMade) {
    this.fistsMade = fistsMade;
    complete = true;
  }

  void reset() {
    fistsMade = -1;
    complete = false;
  }

  @override
  String toString() {
    String result = "Grip Release User State:\n";

    result += "complete? $complete \n";
    result += "fistsMade: $fistsMade \n";

    return result;
  }
}
