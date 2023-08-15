import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';

class JointMotorFunctionUserState {
  Map<Joints, Map<String, dynamic>> stateMap = {
    for (Joints joint in Joints.values)
      joint: {'completed': false, 'angleList': AngleList()},
  };

  bool isJointComplete(Joints joint) {
    return stateMap[joint]!['completed'];
  }

  AngleList getJointAngleList(Joints joint) {
    return stateMap[joint]!['angleList'];
  }

  void markJointTest(Joints joint, bool completed, AngleList angles) {
    Map<String, dynamic> jointState = stateMap[joint]!;
    jointState["completed"] = completed;
    jointState["angleList"] = completed ? angles : AngleList();
  }

  void resetJointTest(Joints joint) {
    markJointTest(joint, false, AngleList());
  }

  bool isComplete() {
    return stateMap.values.fold(true,
        (previousValue, element) => previousValue && element["completed"]);
  }

  @override
  String toString() {
    String result = "Joint Motor Function User State:\n";

    for (var jointData in stateMap.entries) {
      bool isComplete = jointData.value["completed"];
      AngleList angleList = jointData.value["angleList"];

      result += "${jointData.key} \n";
      result += "complete? $isComplete \n";
      result += "angleList: $angleList \n";
    }

    return result;
  }
}
