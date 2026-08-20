// ignore_for_file: deprecated_member_use, strict_top_level_inference, file_names

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/call/call_api.dart';
import 'package:rukmini/controller/api/controllers/drawer/home/customers/custList_Controller.dart';
import 'package:rukmini/modal/drawer/home/customer/customer_list_model.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_Icon.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/app_String.dart';
import 'package:rukmini/view/utils/app_URL.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';
import 'package:rukmini/view/utils/widget/fullScreen.dart';
import 'package:shimmer/shimmer.dart';

class Custlist extends StatefulWidget {
  const Custlist({super.key});

  @override
  State<Custlist> createState() => _CustlistState();
}

class _CustlistState extends State<Custlist> {
  final custListController = Get.put(CustListController());
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  final RxBool _isSearching = false.obs;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      CallApi.callCustList(isRefresh: true);
    });

    _scrollController.addListener(() {
      if (_scrollController.hasClients &&
          _scrollController.position.pixels ==
              _scrollController.position.maxScrollExtent) {
        if (!custListController.isMoreLoading.value &&
            custListController.hasMoreData.value) {
          CallApi.callCustList(search: _searchController.text);
        }
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Fullscreen(
      isPadding: false,
      drawer: homeDrawer(),
      backGroundcolor: AppColor.dashboardIconBg,
      // Matches image background
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(AppSize.width * 0.2),
        child: Container(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top + AppSize.p10,
            left: AppSize.p16,
            right: AppSize.p16,
            bottom: AppSize.p10,
          ),
          child: Row(
            children: [
              Builder(
                builder: (context) {
                  return IconButton(
                    icon: Icon(
                      AppIcon.menu,
                      color: AppColor.dashboardTextDark,
                      size: AppSize.p24 + AppSize.p4,
                    ),
                    onPressed: () => Scaffold.of(context).openDrawer(),
                  );
                },
              ),
              SizedBox(width: AppSize.p8),
              Obx(
                () => _isSearching.value
                    ? Expanded(
                        child: TextField(
                          controller: _searchController,
                          autofocus: true,
                          decoration: InputDecoration(
                            hintText: AppString.searchCustomer,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            custListController.searchQuery.value = value;
                            CallApi.callCustList(
                              isRefresh: true,
                              search: value,
                            );
                          },
                        ),
                      )
                    : Text(
                        AppString.customer,
                        style: TextStyle(
                          fontSize: AppSize.size20,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black54,
                        ),
                      ),
              ),
              const Spacer(),
              Container(
                decoration: BoxDecoration(
                  color: AppColor.white,
                  borderRadius: BorderRadius.circular(AppSize.p10),
                  boxShadow: [
                    BoxShadow(
                      color: AppColor.black.withOpacity(0.05),
                      blurRadius: 5,
                    ),
                  ],
                ),
                child: IconButton(
                  icon: const Icon(
                    AppIcon.searchIcon,
                    color: AppColor.dashboardGold,
                  ),
                  onPressed: () {
                    _isSearching.value = !_isSearching.value;
                    if (!_isSearching.value) {
                      _searchController.clear();
                      custListController.searchQuery.value = "";
                      CallApi.callCustList(isRefresh: true);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColor.dashboardGold,
        onPressed: () => Get.toNamed('/addCustForm'),
        elevation: 5,
        shape: const CircleBorder(),
        child: Icon(
          AppIcon.add,
          color: AppColor.white,
          size: AppSize.p24 + AppSize.p8,
        ),
      ),
      child: Obx(() {
        final bool loading = custListController.isLoading.value;
        final bool isMoreLoading = custListController.isMoreLoading.value;
        final List<CustomerData> list = custListController.customers.toList();

        if (loading && list.isEmpty) {
          return customerLoading();
        }

        if (!loading && list.isEmpty) {
          return Center(child: Text(AppString.noCustomersFound));
        }

        return RefreshIndicator(
          key: const ValueKey('custListRefreshIndicator'),
          onRefresh: () => CallApi.callCustList(
            isRefresh: true,
            search: _searchController.text,
          ),
          child: ListView.builder(
            key: const ValueKey('custListBuilder'),
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.all(AppSize.p16),
            itemCount: list.length + (isMoreLoading ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == list.length) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: AppSize.p16),
                  child: const Center(
                    child: CircularProgressIndicator(
                      color: AppColor.dashboardGold,
                    ),
                  ),
                );
              }

              final customer = list[index];
              final phoneList = customer.phoneList;
              final phoneData = (phoneList != null && phoneList.isNotEmpty)
                  ? phoneList[0]
                  : null;

              final custTypeList = customer.custType;
              final custType = (custTypeList != null && custTypeList.isNotEmpty)
                  ? custTypeList[0]
                  : null;

              final String name = customer.name ?? "No Name";
              final String currentInitial = name.isNotEmpty
                  ? name[0].toUpperCase()
                  : '?';

              bool showHeader = false;
              if (index == 0) {
                showHeader = true;
              } else if (index > 0 && index < list.length) {
                final String prevName = list[index - 1].name ?? '';
                final String previousInitial = prevName.isNotEmpty
                    ? prevName[0].toUpperCase()
                    : '?';
                if (currentInitial != previousInitial) {
                  showHeader = true;
                }
              }

              return Column(
                key: ValueKey('customer_${customer.custId ?? index}'),
                children: [
                  if (showHeader) _buildSectionHeader(currentInitial),
                  _buildCustomerCard(customer, phoneData, custType),
                ],
              );
            },
          ),
        );
      }),
    );
  }

  Widget _buildSectionHeader(String initial) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: AppSize.p8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                initial,
                style: TextStyle(
                  fontSize: AppSize.size20 + AppSize.p4,
                  fontWeight: FontWeight.bold,
                  color: AppColor.dashboardGold,
                ),
              ),
              Container(
                height: 2,
                width: AppSize.p24,
                color: AppColor.dashboardGold,
              ),
            ],
          ),
        ),
        Row(
          children: [
            Expanded(child: Container(height: 1, color: AppColor.grey300)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSize.p10),
              child: Icon(
                AppIcon.diamond,
                color: AppColor.dashboardGold,
                size: AppSize.size14,
              ),
            ),
            Expanded(child: Container(height: 1, color: AppColor.grey300)),
          ],
        ),
        SizedBox(height: AppSize.p16),
      ],
    );
  }

  Widget _buildCustomerCard(
    CustomerData customer,
    PhoneList? phone,
    CustType? type,
  ) {
    return Container(
      margin: EdgeInsets.only(bottom: AppSize.p16),
      decoration: BoxDecoration(
        color: AppColor.white,
        borderRadius: BorderRadius.circular(AppSize.p16),
        boxShadow: [
          BoxShadow(
            color: AppColor.black.withOpacity(0.04),
            blurRadius: 10,
            offset: Offset(0, AppSize.p4),
          ),
        ],
      ),
      child: Material(
        color: AppColor.transparent,
        child: InkWell(
          onTap: () => Get.toNamed('/custDetail', arguments: customer),
          borderRadius: BorderRadius.circular(AppSize.p16),
          child: Padding(
            padding: EdgeInsets.all(AppSize.p12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Image Placeholder
                Container(
                  width: AppSize.width * 0.16,
                  height: AppSize.width * 0.25,
                  decoration: BoxDecoration(
                    color: AppColor.dashboardQuickActionBg,
                    borderRadius: BorderRadius.circular(AppSize.p12),
                    border: Border.all(
                      color: AppColor.dashboardCream,
                      width: 1,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppSize.p10),
                    child: Builder(
                      builder: (context) {
                        String? imageUrl;
                        if (customer.imagePath != null &&
                            customer.imagePath != "null" &&
                            customer.imagePath!.isNotEmpty) {
                          imageUrl = customer.imagePath;
                        } else if (customer.image != null &&
                            customer.image != "null" &&
                            customer.image!.isNotEmpty) {
                          imageUrl = customer.image;
                        }

                        if (imageUrl == null) {
                          return Icon(
                            AppIcon.person,
                            size: AppSize.width * 0.11,
                            color: AppColor.dashboardGold.withOpacity(0.5),
                          );
                        }

                        final String fullUrl = imageUrl.startsWith('http')
                            ? imageUrl
                            : "${AppUrl.baseURL}$imageUrl";

                        return Image.network(
                          fullUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              AppIcon.person,
                              size: AppSize.width * 0.11,
                              color: AppColor.dashboardGold.withOpacity(0.5),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(width: AppSize.p16),
                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        customer.name ?? AppString.noName,
                        style: TextStyle(
                          fontSize: AppSize.size14,
                          fontWeight: FontWeight.w600,
                          color: AppColor.black54,
                        ),
                      ),
                      SizedBox(height: AppSize.p8),
                      _infoRowWithIcon(
                        AppIcon.location,
                        "",
                        customer.address ?? "",
                      ),
                      SizedBox(height: AppSize.p4),
                      _infoRowWithIcon(AppIcon.phone, "", phone?.phone ?? ""),
                      SizedBox(height: AppSize.p4),
                      _infoRowWithIcon(
                        AppIcon.category,
                        "",
                        type?.typeName ?? "",
                      ),
                      SizedBox(height: AppSize.p4),
                      _infoRowWithIcon(
                        AppIcon.badge,
                        "",
                        customer.custCode ?? "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRowWithIcon(IconData icon, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: AppSize.p16, color: AppColor.dashboardGold),
        SizedBox(width: AppSize.p8 * 0.75),
        if (label.isNotEmpty) ...[
          Text(
            label,
            style: TextStyle(
              fontSize: AppSize.size12,
              fontWeight: FontWeight.w600,
              color: AppColor.black54,
            ),
          ),
          SizedBox(width: AppSize.p4),
        ],
        Expanded(
          child: Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: AppSize.size12,
              color: AppColor.dashboardTextLight,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget customerLoading() {
    return Shimmer.fromColors(
      baseColor: AppColor.baseColor,
      highlightColor: AppColor.highlightColor,
      child: ListView.builder(
        padding: EdgeInsets.all(AppSize.p16),
        itemCount: 8,
        itemBuilder: (context, index) => Container(
          height: AppSize.height * 0.15,
          margin: EdgeInsets.only(bottom: AppSize.p16),
          decoration: BoxDecoration(
            color: AppColor.white,
            borderRadius: BorderRadius.circular(AppSize.p16),
          ),
        ),
      ),
    );
  }
}
