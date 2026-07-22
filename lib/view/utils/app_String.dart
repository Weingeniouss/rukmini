// ignore_for_file: constant_identifier_names, file_names

class AppString {
  //Url Start
    //Headers
      static const apiKey = 'API-KEY';
      static const logintokan = 'LoginToken';
      static const userid = 'UserId';
    //Headers

      //Credetinals
        //Login Start _Body
          static const emailBody = 'Email';
          static const passwordBody = 'Password';
        //Login End _Body
      //Credetinals

      //Customer
          //Add CustList _Params
            static const timezonePera = 'timezone';
            static const pagePera = 'page';
            static const searchPera = 'Search';
          //Add CustList _Params

          //Add CustDetail Start  _Params
            static const cusid = 'CustId';
          //Add CustDetail End

          //Add Cust Form Start  _Body
            static const name_Body = 'Name';
            static const typeDel_Body = 'TypeDel';
            static const phoneDel_Body = 'PhoneDel';
            static const address_Body = 'Address';
            static const gender_Body = 'Gender';
            static const nName_Body = 'NName';
            static const nPhone_Body = 'NPhone';
            static const custRelation_Body = 'CustRelation';
            static const gracePeriod_Body = 'GracePeriod';
            static const pName_Body = 'PName';
            static const isProfile_Body = 'IsProfile';
            static const profileName_Body = 'ProfileName';
            static const profile_Body = 'Profile[]';
            static const proof_Body = 'Proof[]';
         //Add Cust Form End

         // Update Cust Form Start  _Body
            static const custDelId_Body = 'CustDelId';
            static const nomineeId_Body = 'NomineeId';
            static const profileId_Body = 'ProfileId';
            static const proofId_Body = 'ProofId';
            static const phoneId_Body = 'PhoneId';
            static const eProofId_Body = 'EProofId';
            static const eProfileId_Body = 'EProfileId';
         // Update Cust Form End
      //Customer

      //Girivi
           //Girivi List Start
              static const timezone = 'timezone';
              static const Search = 'Search';
              static const page = 'page';
              static const FilterType = 'FilterType';
              static const YearId = 'YearId';
              static const FormDate = 'FormDate';
              static const ToDate = 'ToDate';
           //Girivi List End

           //Girivi Add Start
              static const custId_body = 'CustId';
              static const dueDate_body = 'DueDate';
              static const girviDate_body = 'GirviDate';
              static const givenMonth_body = 'GivenMonth';
              static const interest_body = 'Interest';
              static const givenAmt_body = 'GivenAmt';
              static const address_body = 'Address';
              static const productDel_body = 'ProductDel';
              static const image_body = 'Image_i';
           //Girivi Add End
      //Girivi

  //Url End

  //Error Handilaing
  static const customeraddedsuccessfully = 'Customer added successfully';
  static const customerremovededsuccessfully = 'Customer removed successfully';
  static const failedtoaddcustomer = 'Failed to add customer';
  static const failedtoremovecustomer = 'Failed to remove customer';
  static const giriviaddedsuccessfully = 'Girivi added successfully';
  static const failedtoaddgirivi = 'Failed to add Girivi';
  static const invalidserverresponseformat = 'Invalid server response format';

  //Drawer
  static const home = 'Home';
  static const logout = 'Logout';
  static const allMaster = 'All Master';
  static const customer = 'Customer';
  static const girvi = 'Girvi';
  static const products = 'Products';
  static const productinLocker = 'Product in Locker';
  static const pendingTransaction = 'Pending Transaction';
  static const lockerTransaction = 'Locker Transaction';
  static const reports = 'Reports';
  static const exportCustomersContacts = "Export Customer's Contacts";

  //Buttons
  static const sumit = 'Sumit';
  static const update = 'Upadte';
  static const delete = 'Delete';
  static const cancel = 'Cancel';
  static const deleteCustomer = 'Delete Customer';
  static const deleteMessage = 'Are you sure you want to delete this customer?';

  //Splash
  static const napoleonHill = "“Strength and growth come only through continuous effort and struggle.”";
  static const authorNapoleonHill = "— Napoleon Hill, author";
  static const andyRooney = "“Everyone wants to live on top of the mountain, but all the happiness and growth occurs while you’re climbing it.”";
  static const andyRooneyJournalist = "— Andy Rooney, journalist";
  static const williamGeorge = "“Mistakes are the growing pains of wisdom.”";
  static const williamGeorgeJordan = "— William George Jordan";

  //Login
  static const welcome = 'Welcome to';
  static const rukminiJewellers = 'Rukmini Jewellers';
  static const emailphone = 'Email/Phone';
  static const password = 'password';
  static const forgetPassword = 'Forget Password?';

  //home
  static const homeScreen = 'Home';
  static const totalCustomer = 'Total Customer';
  static const totalGirvi = 'Total Girvi';
  static const totalKarkit = 'Total Karkit';
  static const totalSold = 'Total Sold';
  static const totalDueGirvi = 'Total Due Girvi';
  static const totalDueOverGirvi = 'Total Due Over Girvi';
  static const totalPendingProduct = 'Total Pending Product';
  static const totalReturnProduct = 'Total Return Product';
    //Customer
      static const name = 'Name';
      static const address = 'Address';
      static const phone = 'Phone';
      static const type = 'Type';
      static const custCode = 'CustCode';
      static const customerDetail = 'Customer Detail';
      static const nomineeDetail = 'Nominee Detail';
      static const gvnAmt = 'Gvn Amt';
      static const pendingAmt = 'Pending Amt';
      static const call = 'Call';
      static const message = 'Message';
      static const whatsapp = 'Whatsapp';
      static const customerDetails = 'Customer Details';
      static const girviDetails = 'Girvi Details';
      static const transactionDetails = 'Transaction Detail';
      static const identiyProof = 'Identiy Proof';
      static const customerProof = ' Customer Identiy Verification Photo';
      static const identifyProofType = ' Identify Proof Type';
      static const profilePhotos = 'Profile Photos';
      static const gender = 'Gender';
      static const status = 'Status';
      static const gracePeriod = 'GracePeriod';
      static const phoneNumbar = 'Phone Numbers';
      static const customerTypes = 'Customer Types';
      static const customerRelation = 'Customer Relation';
      static const customerPhotos = 'Customer Photos';
      static const uniqueId = 'Unique Id';
      static const girviDate = 'Girvi Date';
      static const givenAmt = 'Given Amt';
      static const balance = 'Balance';
      static const paidAmt = 'Paid Amt';
      static const totint = 'Tot int';
      static const paidint = 'Paid int';
      static const addCustomerForm = 'Add Customer Form';
      static const nomineeName = 'Nominee Name';
      static const nomineePhoneNumber = 'Nominee Phone Number';
      static const customerName = 'Customer Name';
      static const male = 'Male';
      static const female = 'Female';
      static const gracedDays = 'Grace Days';
      static const personName = 'Person Name';
      static const image = 'Image';
      static const save = 'Save';
      static const customerPhoneNumber = 'Customer Phone Number';
      static const selectDate = 'Select Date';
      static const durationInMonths = 'Duration(In Months)';
      static const enterDurationInMonths = 'Enter duration(In months)';
      static const dueDateLabel = 'Due date';
      static const interestRate = 'Interest Rate';
      static const totalAmountGiven = 'Total Amount Given';
      static const interestAmount = 'Interest Amount';
      static const totalAmountReceivable = 'Total Amount Receivable';
    //Givi
      static const giriviList = 'Girivi List';
      static const selectYear = 'Select Year';
      static const allYears = 'All Years';
      static const closed = 'Closed';
      static const open = 'Open';
      static const uiqueId = 'Unique ID';
      static const givenAmount = 'Given Amount';
      static const contact = 'Contact';
      static const filterOptions = 'Filter Options';
      static const all = 'All';
      static const reset = 'Reset';
      static const dateRange = 'Date Range';
      static const fromeDate = 'From Date';
      static const toDate = 'To Date';
      static const applyFilter = 'Apply Filter';
      static const addProduct = 'Add Product';
      static const category = 'Category';
      static const selectCategory = 'Select Category';
      static const metal = 'Metal';
      static const selectMetal = 'Select Metal';
      static const productType = 'Product Type';
      static const selectProductType = 'Select Product Type';
      static const metalTouch = 'Metal Touch';
      static const selectMetalTouch = 'Select Metal Touch';
      static const quantity = 'Quantity';
      static const enterQuantity = 'Enter quantity';
      static const weightInGm = 'Weight(in gm)';
      static const enterWeight = 'Enter Weight';
      static const todaysRate = 'Today\'s rate';
      static const originalPriceApprox = 'Orignal Price(Approx)';
      static const enterApproxOriginalPrice = 'Enter approx orignal price';
      static const amountGiven = 'Amount Given';
      static const enterGivenAmount = 'Enter given amount';
      static const locker = 'Locker';
      static const selectLocker = 'Select Locker';
      static const lockerCode = 'Locker Code';
      static const enterLockerCode = 'Enter Locker code';
      static const productPhoto = 'Product Photo';
      static const remark = 'Remark';
      static const isDiamondAvailable = 'Is Diamond available?';
      static const diamondDetails = 'Diamond Details';
      static const diamondPieces = 'Diamond Pieces';
      static const diamondWeight = 'Diamond Weight';
      static const certificateNumber = 'Certificate Number';
      static const diamondPriceApp = 'Diamond Price(App)';
      static const ok = 'OK';
      static const selectCustomerName = 'Select Customer Name';
}
