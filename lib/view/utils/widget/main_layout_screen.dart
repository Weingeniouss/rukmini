import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rukmini/controller/api/controllers/drawer/all_master/locker_master/lockerList_Controller.dart';
import 'package:rukmini/controller/api/controllers/drawer/productInLocker/cust_product_controller.dart';
import 'package:rukmini/controller/ui/home/allMaster/locker_master/lockerMaster_ControllerUI.dart';
import 'package:rukmini/controller/ui/home/allMaster/year_Master/yearMaster_ControllerUI.dart';
import 'package:rukmini/controller/ui/home/customer/addCustForm_controller.dart';
import 'package:rukmini/controller/ui/home/customer/updateCustForm_controller.dart';
import 'package:rukmini/controller/ui/home/locker/locker_trans_ui_controller.dart';
import 'package:rukmini/controller/ui/home/productInLocker/changeLocker_ControllerUI.dart';
import 'package:rukmini/controller/ui/home/report/report_ui_controller.dart';
import 'package:rukmini/controller/ui/widget/drawerControllerUI.dart';
import 'package:rukmini/view/screen/drawer/allMaster/allMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/categoryMataer/categoryMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/customerTypeMaster/customerTypeMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/lockerCodeMaster/addLockerCode.dart';
import 'package:rukmini/view/screen/drawer/allMaster/lockerCodeMaster/lockerCodeMaster.dart';
import 'package:rukmini/view/screen/drawer/allMaster/metalMaster/metal_Master.dart';
import 'package:rukmini/view/screen/drawer/allMaster/metalTouch/metalTouch.dart';
import 'package:rukmini/view/screen/drawer/allMaster/year_Master/add_Year_Master.dart';
import 'package:rukmini/view/screen/drawer/allMaster/year_Master/year_Master.dart';
import 'package:rukmini/view/screen/drawer/home/customer/addCustForm.dart';
import 'package:rukmini/view/screen/drawer/home/customer/custDetail.dart';
import 'package:rukmini/view/screen/drawer/home/customer/custList.dart';
import 'package:rukmini/view/screen/drawer/home/customer/updateCustForm.dart';
import 'package:rukmini/view/screen/drawer/home/dueGirvi/dueGirvi.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/addGirivi.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/addProduct.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/giriviDetail.dart';
import 'package:rukmini/view/screen/drawer/home/girvi/giriviList.dart';
import 'package:rukmini/view/screen/drawer/home/home.dart';
import 'package:rukmini/view/screen/drawer/home/pendingProduct/productDetail.dart';
import 'package:rukmini/view/screen/drawer/home/profile/profile.dart';
import 'package:rukmini/view/screen/drawer/lockerTransaction/lockerTransationDetail/lockerTransationDetail.dart';
import 'package:rukmini/view/screen/drawer/lockerTransaction/lockerTranstaion.dart';
import 'package:rukmini/view/screen/drawer/productInLocker/changeTheLocker/changeTheLocker.dart';
import 'package:rukmini/view/screen/drawer/productInLocker/productInLocker.dart';
import 'package:rukmini/view/screen/drawer/productInLocker/productLockerDetail/productInLockerDetail.dart';
import 'package:rukmini/view/screen/drawer/report/export_customer_contacts.dart';
import 'package:rukmini/view/screen/drawer/report/report_view_screen.dart';
import 'package:rukmini/view/screen/drawer/report/reports.dart';
import 'package:rukmini/view/utils/app_Color.dart';
import 'package:rukmini/view/utils/app_size.dart';
import 'package:rukmini/view/utils/widget/drawer.dart';

class ShellScope extends InheritedWidget {
  const ShellScope({super.key, required super.child});

  static bool of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShellScope>() != null;
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => false;
}

class MainLayoutScreen extends StatefulWidget {
  final String initialRoute;

  const MainLayoutScreen({super.key, this.initialRoute = '/home'});

  @override
  State<MainLayoutScreen> createState() => _MainLayoutScreenState();
}

class _MainLayoutScreenState extends State<MainLayoutScreen> {
  late final NavDrawerController navDrawerController;

  @override
  void initState() {
    super.initState();
    navDrawerController = Get.put(NavDrawerController());
    navDrawerController.selectedIndex.value =
        navDrawerController.getIndexForRoute(widget.initialRoute);
  }

  Widget _getWidgetForRoute(String route) {
    switch (route) {
      case '/home':
        return const Home();
      case '/allMaster':
        return const AllMaster();
      case '/custList':
        return const Custlist();
      case '/custDetail':
        return const CustDetail();
      case '/addCustForm':
        return AddCustForm(
          addCustForomUI: Get.put(AddCustFormControllerUI()),
        );
      case '/updateCustForm':
        return UpdateCustForm(
          updateCustUI: Get.put(UpdateCustFormControllerUI()),
        );
      case '/giriviList':
        return const GiriviList();
      case '/giriviadd':
        return const Addgirivi();
      case '/AddProduct':
        return const AddProduct();
      case '/giriviDetail':
        return const GiriviDetail();
      case '/pendingProduct':
      case '/returnProduct':
      case '/karkitProduct':
      case '/soldProduct':
        return const productDetail();
      case '/dueGirvi':
      case '/dueOverGirvi':
        return const DueGirvi();
      case '/metalMaster':
        return const MetalMaster();
      case '/categoryMaster':
        return const CategoryMaster();
      case '/customerTypeMaster':
        return const CustomerTypeMaster();
      case '/lockerCodeMaster':
        return const LockerCodeMaster();
      case '/addLockerCode':
        return AddLockerCode(
          uiController: Get.put(LockerMasterControllerUI()),
        );
      case '/metalTouch':
        return const MetalTouch();
      case '/yearMaster':
        return const YearMaster();
      case '/addYearMaster':
        return AddYearMaster(
          uiController: Get.put(YearMasterControllerUI()),
        );
      case '/productInLocker':
        return ProductInLocker(
          custProductController: Get.put(CustProductController()),
          lockerListController: Get.put(LockerListController()),
        );
      case '/productInLockerDetail':
        return const ProductInLockerDetail();
      case '/changeTheLocker':
        return ChangeTheLocker(
          uiController: Get.put(ChangeLockerControllerUI()),
          custProductController: Get.find<CustProductController>(),
        );
      case '/lockerTransaction':
        return LockerTranStaion(
          uiController: Get.put(LockerTransUIController()),
        );
      case '/lockerTransationDetail':
        return const LockerTransationDetail();
      case '/report':
        return Reports(uiController: Get.put(ReportUIController()));
      case '/exportContacts':
        return ExportCustomerContacts(
          uiController: Get.put(ReportUIController()),
        );
      case '/reportView':
        return const ReportViewScreen();
      case '/profile':
        return const Profile();
      default:
        return const Home();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDesktopOrTablet = AppSize.isDesktop || AppSize.isTablet;

    if (!isDesktopOrTablet) {
      return ShellScope(
        child: Navigator(
          key: Get.nestedKey(NavDrawerController.nestedKey),
          initialRoute: widget.initialRoute,
          onGenerateRoute: (settings) {
            final routeName = settings.name ?? widget.initialRoute;
            return GetPageRoute(
              page: () => _getWidgetForRoute(routeName),
              settings: settings,
              transition: Transition.fade,
              transitionDuration: const Duration(milliseconds: 150),
            );
          },
        ),
      );
    }

    return ShellScope(
      child: Scaffold(
        backgroundColor: AppColor.backgroundColor,
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Left Side: Persistent Navigation Drawer
            SizedBox(
              width: AppSize.isDesktop ? 350 : 240,
              height: double.infinity,
              child: homeDrawer(),
            ),

            // Right Side: Content Area Navigator
            Expanded(
              child: Navigator(
                key: Get.nestedKey(NavDrawerController.nestedKey),
                initialRoute: widget.initialRoute,
                onGenerateRoute: (settings) {
                  final routeName = settings.name ?? widget.initialRoute;
                  return GetPageRoute(
                    page: () => _getWidgetForRoute(routeName),
                    settings: settings,
                    transition: Transition.fade,
                    transitionDuration: const Duration(milliseconds: 150),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
