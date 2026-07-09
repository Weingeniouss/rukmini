class CustomerDetailModel {
  bool? status;
  String? message;
  CustomerDetailData? data;

  CustomerDetailModel({this.status, this.message, this.data});

  CustomerDetailModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null
        ? CustomerDetailData.fromJson(json['data'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class CustomerDetailData {
  String? name;
  String? custCode;
  String? address;
  String? gender;
  String? custId;
  String? status;
  String? imagePath;
  String? gracePeriod;
  List<CustType>? custType;
  Nominee? nominee;
  List<Phone>? phone;
  List<Proof>? proof;
  List<Profile>? profile;
  List<Girvi>? girviList;
  num? totalGivenAmt;
  num? totalBalance;

  CustomerDetailData({
    this.name,
    this.custCode,
    this.address,
    this.gender,
    this.custId,
    this.status,
    this.imagePath,
    this.gracePeriod,
    this.custType,
    this.nominee,
    this.phone,
    this.proof,
    this.profile,
    this.girviList,
    this.totalGivenAmt,
    this.totalBalance,
  });

  CustomerDetailData.fromJson(Map<String, dynamic> json) {
    name = json['Name'];
    custCode = json['CustCode'];
    address = json['Address'];
    gender = json['Gender'];
    custId = json['CustId'];
    status = json['Status'];
    imagePath = json['ImagePath'];
    gracePeriod = json['GracePeriod'];
    if (json['CustType'] != null) {
      custType = <CustType>[];
      json['CustType'].forEach((v) {
        custType!.add(CustType.fromJson(v));
      });
    }
    nominee = json['Nominee'] != null
        ? Nominee.fromJson(json['Nominee'])
        : null;
    if (json['Phone'] != null) {
      phone = <Phone>[];
      json['Phone'].forEach((v) {
        phone!.add(Phone.fromJson(v));
      });
    }
    if (json['Proof'] != null) {
      proof = <Proof>[];
      json['Proof'].forEach((v) {
        proof!.add(Proof.fromJson(v));
      });
    }
    if (json['Profile'] != null) {
      profile = <Profile>[];
      json['Profile'].forEach((v) {
        profile!.add(Profile.fromJson(v));
      });
    }
    if (json['GirviList'] != null) {
      girviList = <Girvi>[];
      json['GirviList'].forEach((v) {
        girviList!.add(Girvi.fromJson(v));
      });
    }
    totalGivenAmt = json['TotalGivenAmt'];
    totalBalance = json['TotalBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['Name'] = name;
    data['CustCode'] = custCode;
    data['Address'] = address;
    data['Gender'] = gender;
    data['CustId'] = custId;
    data['Status'] = status;
    data['ImagePath'] = imagePath;
    data['GracePeriod'] = gracePeriod;
    if (custType != null) {
      data['CustType'] = custType!.map((v) => v.toJson()).toList();
    }
    if (nominee != null) {
      data['Nominee'] = nominee!.toJson();
    }
    if (phone != null) {
      data['Phone'] = phone!.map((v) => v.toJson()).toList();
    }
    if (proof != null) {
      data['Proof'] = proof!.map((v) => v.toJson()).toList();
    }
    if (profile != null) {
      data['Profile'] = profile!.map((v) => v.toJson()).toList();
    }
    if (girviList != null) {
      data['GirviList'] = girviList!.map((v) => v.toJson()).toList();
    }
    data['TotalGivenAmt'] = totalGivenAmt;
    data['TotalBalance'] = totalBalance;
    return data;
  }
}

class CustType {
  String? custDelId;
  String? custId;
  String? typeId;
  String? typeName;
  String? status;

  CustType({
    this.custDelId,
    this.custId,
    this.typeId,
    this.typeName,
    this.status,
  });

  CustType.fromJson(Map<String, dynamic> json) {
    custDelId = json['CustDelId'];
    custId = json['CustId'];
    typeId = json['TypeId'];
    typeName = json['TypeName'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['CustDelId'] = custDelId;
    data['CustId'] = custId;
    data['TypeId'] = typeId;
    data['TypeName'] = typeName;
    data['Status'] = status;
    return data;
  }
}

class Nominee {
  String? nomineeId;
  String? custId;
  String? name;
  String? phone;
  String? custRelation;
  String? status;

  Nominee({
    this.nomineeId,
    this.custId,
    this.name,
    this.phone,
    this.custRelation,
    this.status,
  });

  Nominee.fromJson(Map<String, dynamic> json) {
    nomineeId = json['NomineeId'];
    custId = json['CustId'];
    name = json['Name'];
    phone = json['Phone'];
    custRelation = json['CustRelation'];
    status = json['Status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['NomineeId'] = nomineeId;
    data['CustId'] = custId;
    data['Name'] = name;
    data['Phone'] = phone;
    data['CustRelation'] = custRelation;
    data['Status'] = status;
    return data;
  }
}

class Phone {
  String? phoneId;
  String? custId;
  String? phone;
  String? status;
  String? isDefault;

  Phone({this.phoneId, this.custId, this.phone, this.status, this.isDefault});

  Phone.fromJson(Map<String, dynamic> json) {
    phoneId = json['PhoneId'];
    custId = json['CustId'];
    phone = json['Phone'];
    status = json['Status'];
    isDefault = json['IsDefault'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['PhoneId'] = phoneId;
    data['CustId'] = custId;
    data['Phone'] = phone;
    data['Status'] = status;
    data['IsDefault'] = isDefault;
    return data;
  }
}

class Proof {
  String? proofId;
  String? custId;
  String? name;
  String? status;
  String? image;
  String? imagePath;

  Proof({
    this.proofId,
    this.custId,
    this.name,
    this.status,
    this.image,
    this.imagePath,
  });

  Proof.fromJson(Map<String, dynamic> json) {
    proofId = json['ProofId'];
    custId = json['CustId'];
    name = json['Name'];
    status = json['Status'];
    image = json['Image'];
    imagePath = json['ImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProofId'] = proofId;
    data['CustId'] = custId;
    data['Name'] = name;
    data['Status'] = status;
    data['Image'] = image;
    data['ImagePath'] = imagePath;
    return data;
  }
}

class Profile {
  String? profileId;
  String? custId;
  String? name;
  String? status;
  String? image;
  String? imagePath;
  String? isProfile;

  Profile({
    this.profileId,
    this.custId,
    this.name,
    this.status,
    this.image,
    this.imagePath,
    this.isProfile,
  });

  Profile.fromJson(Map<String, dynamic> json) {
    profileId = json['ProfileId'];
    custId = json['CustId'];
    name = json['Name'];
    status = json['Status'];
    image = json['Image'];
    imagePath = json['ImagePath'];
    isProfile = json['IsProfile'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['ProfileId'] = profileId;
    data['CustId'] = custId;
    data['Name'] = name;
    data['Status'] = status;
    data['Image'] = image;
    data['ImagePath'] = imagePath;
    data['IsProfile'] = isProfile;
    return data;
  }
}

class Girvi {
  String? girviId;
  String? custId;
  String? custName;
  String? custPhone;
  String? uniqueId;
  String? girviDate;
  String? givenMonth;
  String? dueDate;
  String? interest;
  String? givenAmt;
  String? totalCunt;
  String? discAmt;
  String? badDept;
  num? balance;
  String? isClosed;
  String? tranDate;
  String? interestAmt;
  String? paidInterset;
  String? isCarried;
  String? parentId;
  List<dynamic>? productList;
  List<dynamic>? tranHistory;
  num? totalPaidAmt;
  num? crDr;
  num? tillInterest;
  num? monthInterset;
  String? tillDate;
  num? tillMonth;

  Girvi({
    this.girviId,
    this.custId,
    this.custName,
    this.custPhone,
    this.uniqueId,
    this.girviDate,
    this.givenMonth,
    this.dueDate,
    this.interest,
    this.givenAmt,
    this.totalCunt,
    this.discAmt,
    this.badDept,
    this.balance,
    this.isClosed,
    this.tranDate,
    this.interestAmt,
    this.paidInterset,
    this.isCarried,
    this.parentId,
    this.productList,
    this.tranHistory,
    this.totalPaidAmt,
    this.crDr,
    this.tillInterest,
    this.monthInterset,
    this.tillDate,
    this.tillMonth,
  });

  Girvi.fromJson(Map<String, dynamic> json) {
    girviId = json['GirviId'];
    custId = json['CustId'];
    custName = json['CustName'];
    custPhone = json['CustPhone'];
    uniqueId = json['UniqueId'];
    girviDate = json['GirviDate'];
    givenMonth = json['GivenMonth'];
    dueDate = json['DueDate'];
    interest = json['Interest'];
    givenAmt = json['GivenAmt'];
    totalCunt = json['TotalCunt'];
    discAmt = json['DiscAmt'];
    badDept = json['BadDept'];
    balance = json['Balance'];
    isClosed = json['IsClosed'];
    tranDate = json['TranDate'];
    interestAmt = json['InterestAmt'];
    paidInterset = json['PaidInterset'];
    isCarried = json['IsCarried'];
    parentId = json['ParentId'];
    if (json['ProductList'] != null) {
      productList = List<dynamic>.from(json['ProductList']);
    }
    if (json['TranHistory'] != null) {
      tranHistory = List<dynamic>.from(json['TranHistory']);
    }
    totalPaidAmt = json['TotalPaidAmt'];
    crDr = json['CR_DR'];
    tillInterest = json['TillInterest'];
    monthInterset = json['MonthInterset'];
    tillDate = json['TillDate'];
    tillMonth = json['TillMonth'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['GirviId'] = girviId;
    data['CustId'] = custId;
    data['CustName'] = custName;
    data['CustPhone'] = custPhone;
    data['UniqueId'] = uniqueId;
    data['GirviDate'] = girviDate;
    data['GivenMonth'] = givenMonth;
    data['DueDate'] = dueDate;
    data['Interest'] = interest;
    data['GivenAmt'] = givenAmt;
    data['TotalCunt'] = totalCunt;
    data['DiscAmt'] = discAmt;
    data['BadDept'] = badDept;
    data['Balance'] = balance;
    data['IsClosed'] = isClosed;
    data['TranDate'] = tranDate;
    data['InterestAmt'] = interestAmt;
    data['PaidInterset'] = paidInterset;
    data['IsCarried'] = isCarried;
    data['ParentId'] = parentId;
    if (productList != null) {
      data['ProductList'] = productList;
    }
    if (tranHistory != null) {
      data['TranHistory'] = tranHistory;
    }
    data['TotalPaidAmt'] = totalPaidAmt;
    data['CR_DR'] = crDr;
    data['TillInterest'] = tillInterest;
    data['MonthInterset'] = monthInterset;
    data['TillDate'] = tillDate;
    data['TillMonth'] = tillMonth;
    return data;
  }
}
