import 'dart:developer';

import 'package:admin/models/api_response.dart';
import 'package:admin/utility/snack_bar_helper.dart';

import '../../../models/variant_type.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../../../core/data/data_provider.dart';
import '../../../models/variant.dart';
import '../../../services/http_services.dart';

class VariantsProvider extends ChangeNotifier {
  HttpService service = HttpService();
  final DataProvider _dataProvider;
  final addVariantsFormKey = GlobalKey<FormState>();
  TextEditingController variantCtrl = TextEditingController();
  VariantType? selectedVariantType;
  Variant? variantForUpdate;

  VariantsProvider(this._dataProvider);

  //?TODO: should complete addVariant
  addVariant() async {
    try {
      Map<String, dynamic> variant = await {
        'name': variantCtrl.text,
        'variantTypeId': selectedVariantType?.sId
      };
      final response =
          await service.addItem(endpointUrl: 'variants', itemData: variant);
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          clearFields();
          SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
          log('variant added');
          _dataProvider.getAllVariant();
        } else {
          SnackBarHelper.showErrorSnackBar(
              'failed to add variant:${apiResponse.message}');
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

  //?TODO: should complete updateVariant
  updateVariant() async {
    try {
      if (variantForUpdate != null) {
        Map<String, dynamic> variant = {
          'name': variantCtrl.text,
          'variantTypeId': selectedVariantType?.sId
        };
        final response = await service.updateItem(
            endpointUrl: 'variants',
            itemData: variant,
            itemId: variantForUpdate?.sId ?? '');
        if (response.isOk) {
          ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
          if (apiResponse.success == true) {
            clearFields();
            SnackBarHelper.showSuccessSnackBar('${apiResponse.message}');
            log('variant updated');
            _dataProvider.getAllVariant();
          } else {
            SnackBarHelper.showErrorSnackBar(
                'failed to add variant: ${apiResponse.message}');
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

  //?TODO: should complete submitVariant

  submitVariant() {
    if (variantForUpdate != null) {
      updateVariant();
    } else {
      addVariant();
    }
  }

  //?TODO: should complete deleteVariant
  deleteVariant(Variant variant) async {
    try {
      Response response = await service.deleteItem(
          endpointUrl: 'variants', itemId: variant.sId ?? '');
      if (response.isOk) {
        ApiResponse apiResponse = ApiResponse.fromJson(response.body, null);
        if (apiResponse.success == true) {
          SnackBarHelper.showSuccessSnackBar('variant deleted successfully');
          _dataProvider.getAllVariant();
        }
      } else {
        SnackBarHelper.showErrorSnackBar(
            'error ${response.body?['message'] ?? response.statusText}');
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  setDataForUpdateVariant(Variant? variant) {
    if (variant != null) {
      variantForUpdate = variant;
      variantCtrl.text = variant.name ?? '';
      selectedVariantType = _dataProvider.variantTypes.firstWhereOrNull(
          (element) => element.sId == variant.variantTypeId?.sId);
    } else {
      clearFields();
    }
  }

  clearFields() {
    variantCtrl.clear();
    selectedVariantType = null;
    variantForUpdate = null;
  }

  void updateUI() {
    notifyListeners();
  }
}
