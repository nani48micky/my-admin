import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_connect/http/src/response/response.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/variant_type.dart';
import '../../../services/http_services.dart';

class VariantsTypeProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;

  final addVariantsTypeFormKey = GlobalKey<FormState>();
  TextEditingController variantNameCtrl = TextEditingController();
  TextEditingController variantTypeCtrl = TextEditingController();

  VariantType? variantTypeForUpdate;

  VariantsTypeProvider(this._dataProvider);

  //TODO: should complete addVariantType
  addVariantType() async {
    try {
      Map<String, dynamic> variantType = {
        'name': variantNameCtrl.text,
        'type': variantTypeCtrl.text
      };
      final response = await service.addItem(
          endpointUrl: 'variantTypes', itemData: variantType);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('variant Type added');
          _dataProvider.getAllVariantType();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'failed to add variant type:${apiResponse.message}');
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('an error occurred $e');
      rethrow;
    }
  }

  //TODO: should complete
  updateVariantType() async {
    try {
      if (variantTypeForUpdate != null) {
        Map<String, dynamic> variantType = {
          'name': variantNameCtrl.text,
          'type': variantTypeCtrl.text
        };
        final response = await service.updateItem(
            endpointUrl: 'variantTypes',
            itemData: variantType,
            itemId: variantTypeForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            log('variant Type added');
            _dataProvider.getAllVariantType();
          } else {
            SnackBarHelper.showErrorSnackBar(
                'failed to add variant type:${apiResponse.message}');
          }
        } else {
          SnackBarHelper.showErrorSnackBar(
              'error ${response.body?['message'] ?? response.statusText}');
        }
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('an error occurred $e');
      rethrow;
    }
  }

  //TODO: should complete submitVariantType
  submitVariantType() {
    if (variantTypeForUpdate != null) {
      updateVariantType();
    } else {
      addVariantType();
    }
  }

  //TODO: should complete deleteVariantType
  deleteVariantType(VariantType variantType) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'variantTypes', itemId: variantType.sId ?? '');

      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar(
              'variant type deleted successfully');
          _dataProvider.getAllVariantType();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      SnackBarHelper.showErrorSnackBar('an error occurred $e');
      rethrow;
    }
  }

  setDataForUpdateVariantTYpe(VariantType? variantType) {
    if (variantType != null) {
      variantTypeForUpdate = variantType;
      variantNameCtrl.text = variantType.name ?? '';
      variantTypeCtrl.text = variantType.type ?? '';
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantNameCtrl.clear();
    variantTypeCtrl.clear();
    variantTypeForUpdate = null;
  }
}
