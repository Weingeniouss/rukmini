class CategoryListModal {
  bool? status;
  String? message;
  List<CategoryData>? data;

  CategoryListModal({this.status, this.message, this.data});

  CategoryListModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <CategoryData>[];
      json['data'].forEach((v) {
        data!.add(CategoryData.fromJson(v));
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

class CategoryData {
  String? categoryId;
  String? name;

  CategoryData({this.categoryId, this.name});

  CategoryData.fromJson(Map<String, dynamic> json) {
    categoryId = json['CategoryId'];
    name = json['Name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CategoryId'] = categoryId;
    data['Name'] = name;
    return data;
  }
}
