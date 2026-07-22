class ProductListModal {
  bool? status;
  String? search;
  int? totalCount;
  String? message;
  List<ProductListData>? data;

  ProductListModal({
    this.status,
    this.search,
    this.totalCount,
    this.message,
    this.data,
  });

  ProductListModal.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    search = json['Search'];
    totalCount = json['TotalCount'];
    message = json['message'];
    if (json['data'] != null) {
      data = <ProductListData>[];
      json['data'].forEach((v) {
        data!.add(ProductListData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['Search'] = search;
    data['TotalCount'] = totalCount;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ProductListData {
  String? productId;
  String? girviId;
  String? productTypeId;
  String? pieces;
  String? weight;
  String? categoryId;
  String? metalId;
  String? todayRate;
  String? origAmount;
  String? givenAmount;
  String? isDiamond;
  String? isGemStone;
  String? isReturn;
  String? returnDate;
  String? badDept;
  String? prodType;
  String? metalName;
  String? catName;
  String? uniqueId;
  String? custName;
  String? lockerCode;
  String? givenDate;
  List<dynamic>? galleryList;

  ProductListData({
    this.productId,
    this.girviId,
    this.productTypeId,
    this.pieces,
    this.weight,
    this.categoryId,
    this.metalId,
    this.todayRate,
    this.origAmount,
    this.givenAmount,
    this.isDiamond,
    this.isGemStone,
    this.isReturn,
    this.returnDate,
    this.badDept,
    this.prodType,
    this.metalName,
    this.catName,
    this.uniqueId,
    this.custName,
    this.lockerCode,
    this.givenDate,
    this.galleryList,
  });

  ProductListData.fromJson(Map<String, dynamic> json) {
    productId = json['ProductId'];
    girviId = json['GirviId'];
    productTypeId = json['ProductTypeId'];
    pieces = json['Pieces'];
    weight = json['Weight'];
    categoryId = json['CategoryId'];
    metalId = json['MetalId'];
    todayRate = json['TodayRate'];
    origAmount = json['OrigAmount'];
    givenAmount = json['GivenAmount'];
    isDiamond = json['IsDiamond'];
    isGemStone = json['IsGemStone'];
    isReturn = json['IsReturn'];
    returnDate = json['ReturnDate'];
    badDept = json['BadDept'];
    prodType = json['ProdType'];
    metalName = json['MetalName'];
    catName = json['CatName'];
    uniqueId = json['UniqueId'];
    custName = json['CustName'];
    lockerCode = json['LockerCode'];
    givenDate = json['GivenDate'];
    galleryList = json['GalleryList'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProductId'] = productId;
    data['GirviId'] = girviId;
    data['ProductTypeId'] = productTypeId;
    data['Pieces'] = pieces;
    data['Weight'] = weight;
    data['CategoryId'] = categoryId;
    data['MetalId'] = metalId;
    data['TodayRate'] = todayRate;
    data['OrigAmount'] = origAmount;
    data['GivenAmount'] = givenAmount;
    data['IsDiamond'] = isDiamond;
    data['IsGemStone'] = isGemStone;
    data['IsReturn'] = isReturn;
    data['ReturnDate'] = returnDate;
    data['BadDept'] = badDept;
    data['ProdType'] = prodType;
    data['MetalName'] = metalName;
    data['CatName'] = catName;
    data['UniqueId'] = uniqueId;
    data['CustName'] = custName;
    data['LockerCode'] = lockerCode;
    data['GivenDate'] = givenDate;
    data['GalleryList'] = galleryList;
    return data;
  }
}
