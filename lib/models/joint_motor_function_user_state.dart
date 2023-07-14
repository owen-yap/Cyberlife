import 'package:cyberlife/enums/joint_motor_function/joints.dart';
import 'package:cyberlife/models/angle_list.dart';

class JointMotorFunctionUserState {
  Map<Joints, Map<String, dynamic>> stateMap = {
    for (Joints joint in Joints.values)
      joint: {'completed': false, 'angleList': AngleList()},
  };

  bool get isShoulderComplete => stateMap[Joints.shoulder]!['completed'];
  AngleList get shoulderAngleList => stateMap[Joints.shoulder]!['angleList'];

  bool get isElbowComplete => stateMap[Joints.elbow]!['completed'];
  AngleList get elbowAngleList => stateMap[Joints.elbow]!['angleList'];

  bool get isKneeComplete => stateMap[Joints.knee]!['completed'];
  AngleList get kneeAngleList => stateMap[Joints.knee]!['angleList'];

  // TODO: Repalce with one function + enums
  void markJointTest(Joints joint, bool completed, AngleList angles) {
    // CLEAN THIS UP MORE, use dict ah
    Map<String, dynamic> jointState = stateMap[joint]!;
    jointState["completed"] = completed;
    jointState["angleList"] = completed ? angles : AngleList();
  }
}
