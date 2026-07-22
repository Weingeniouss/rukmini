class ProductTypeListModal {
  bool? status;
  String? message;
  List<ProductTypeData>? data;

  ProductTypeListModal({this.status, this.message, this.data});

  ProductTypeListModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductTypeData>[];
      json['data'].forEach((v) {
        data!.add(ProductTypeData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductTypeData {
  String? productTypeId;
  String? name;
  String? rate;

  ProductTypeData({this.productTypeId, this.name, this.rate});

  ProductTypeData.fromJson(Map<String, dynamic> json) {
    productTypeId = json['ProductTypeId'];
    name = json['Name'];
    rate = json['Rate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductTypeId'] = productTypeId;
    data['Name'] = name;
    data['Rate'] = rate;
    return data;
  }
}
