import 'dart:async';
import 'dart:math';

import 'package:get/get.dart';
import 'package:necopia/environment/environment_controller.dart';

class CatDialog {
  String message;
  CatDialog(this.message);
}

enum CatDialogStatus { ready, displaying }

abstract class ICatDialogController {
  // get CatDialog
  void forceDialog();

  CatDialogStatus get dialogStatus;
  set dialogStatus(CatDialogStatus status);

  // CatDialog stream
  Stream<CatDialog> get stream;
}

class CatDialogController implements ICatDialogController {
  final environmentController = Get.find<IEnvironmentController>();
  final StreamController<CatDialog> _streamController =
      StreamController.broadcast();

  static const dialogRate = 0.3;

  CatDialogController() {
    Stream.periodic(const Duration(seconds: 2), (time) {
      if (dialogStatus == CatDialogStatus.ready &&
          Random().nextDouble() <= CatDialogController.dialogRate) {
        _streamController.sink.add(_getCatDialog());

        dialogStatus = CatDialogStatus.displaying;
      }
    }).forEach((element) {});
  }

  CatDialog _getCatDialog() {
    return CatDialog("Hi");
  }

  @override
  Stream<CatDialog> get stream => _streamController.stream;

  @override
  CatDialogStatus dialogStatus = CatDialogStatus.ready;

  @override
  void forceDialog() {
    _streamController.sink.add(_getCatDialog());

    dialogStatus = CatDialogStatus.displaying;
  }
}
