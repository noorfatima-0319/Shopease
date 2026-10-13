import 'package:hive/hive.dart';

import '../../core/constants/app_constants.dart';
import '../models/address_model.dart';

class AddressLocalDataSource {
  static const _key = 'default';
  Box get _box => Hive.box(AppConstants.addressBox);

  AddressModel? get() {
    final raw = _box.get(_key);
    if (raw == null) return null;
    return AddressModel.fromMap(raw as Map);
  }

  Future<void> save(AddressModel address) async {
    await _box.put(_key, address.toMap());
  }
}
