class MetalListModal {
  bool? status;
  String? message;
  List<MetalData>? data;

  MetalListModal({this.status, this.message, this.data});

  MetalListModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['data'] != null) {
      data = <MetalData>[];
      json['data'].forEach((v) {
        data!.add(MetalData.fromJson(v));
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

class MetalData {
  String? metalId;
  String? karat;
  String? goldContent;

  MetalData({this.metalId, this.karat, this.goldContent});

  MetalData.fromJson(Map<String, dynamic> json) {
    metalId = json['MetalId'];
    karat = json['Karat'];
    goldContent = json['GoldContent'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['MetalId'] = metalId;
    data['Karat'] = karat;
    data['GoldContent'] = goldContent;
    return data;
  }
}
