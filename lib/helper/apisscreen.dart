class API {
  // static const String API_URL = "https://driverqtr.com";
  // static const String API_URL = "https://rakmanaonline.com";
  static const String API_URL = "https://futureproperty.qa/api/";
  //"http://192.168.18.32"
  //"http://3.135.23.7";
  static const pdflink =
      "https://futureproperty.qa/api/broker/property/download-pdf/";
  static const String Image_Path = "https://futureproperty.qa";
  // static const String Image_Path =
  //     "http://jaikapp.com/uploads/reseller/normal/";
  // static const String Image_Path_Qr = "http://jaikapp.com";
  /*------------------------------------------------------------
                 API:Signup
                 TYPE: post  -------------------------------------------------------------*/
  static const loginApi = "broker/login";

  /*------------------------------------------------------------
                 API:getStaff
                 TYPE: post  -------------------------------------------------------------*/
  static const getStaff = "broker/staff";

  /*------------------------------------------------------------
                 API:getStaff
                 TYPE: post  -------------------------------------------------------------*/
  static const getAppointment = "broker/queries/appointment-requests";
  /*------------------------------------------------------------
                 API:getContactRequest
                 TYPE: post  -------------------------------------------------------------*/
  static const getContactRequest = "broker/queries/contact-requests";

/*------------------------------------------------------------
                 API:updateStaff
                 TYPE: post  -------------------------------------------------------------*/
  static const updateStaff = "broker/staff/update?id=";
  /*------------------------------------------------------------
                 API:addStaff
                 TYPE: post  -------------------------------------------------------------*/
  static const addStaff = "broker/staff/create";

  /*------------------------------------------------------------
                 API:support
                 TYPE: post  -------------------------------------------------------------*/
  static const support = "broker/support";
  /*------------------------------------------------------------
                 API:getProperties
                 TYPE: post  -------------------------------------------------------------*/
  static const getProperties = "broker/property";
  /*------------------------------------------------------------
                 API:propertyDetail
                 TYPE: post  -------------------------------------------------------------*/
  static const propertyDetail = "broker/property/detail?id=";
  /*------------------------------------------------------------
                 API:propertyDetail
                 TYPE: post  -------------------------------------------------------------*/
  static const types = "broker/property/get-types";
  /*------------------------------------------------------------
                 API:propertyDetail
                 TYPE: post  -------------------------------------------------------------*/
  static const saveProperty = "broker/property/save";

  /*------------------------------------------------------------
                 API:updateProperty
                 TYPE: post  -------------------------------------------------------------*/
  static const updateProperty = "broker/property/update";

  /*------------------------------------------------------------
                 API:duplicate
                 TYPE: post  -------------------------------------------------------------*/
  static const duplicate = "broker/property/duplicate?id=";

  /*------------------------------------------------------------
                 API:publish
                 TYPE: post  -------------------------------------------------------------*/
  static const publish = "broker/property/update/publish-status?id=";

  /*------------------------------------------------------------
                 API:deleteProperty
                 TYPE: post  -------------------------------------------------------------*/
  static const deleteProperty = "broker/property/delete?id=";
  /*------------------------------------------------------------
                 API:featureProperty
                 TYPE: post  -------------------------------------------------------------*/
  static const featureProperty = "broker/property/set-featured?id=";

  /*------------------------------------------------------------
                 API:archive
                 TYPE: post  -------------------------------------------------------------*/
  static const archive = "broker/property/archive?id=";
  /*------------------------------------------------------------
                 API:getArchive
                 TYPE: post  -------------------------------------------------------------*/
  static const getArchive = "broker/property?archived=1";

/*------------------------------------------------------------
                 API:uploadImages
                 TYPE: post  -------------------------------------------------------------*/
  static const uploadImages = "broker/property/upload-image";

/*------------------------------------------------------------
                 API:removeImage
                 TYPE: post  -------------------------------------------------------------*/
  static const removeImage = "broker/property/remove-image";

/*------------------------------------------------------------
                 API:getUserProfile
                 TYPE: post  -------------------------------------------------------------*/
  static const getUserProfile = "broker/user-profile";

/*------------------------------------------------------------
                 API:getBrokerList
                 TYPE: post  -------------------------------------------------------------*/
  static const getBrokerList = "broker/list";

/*------------------------------------------------------------
                 API:dashboard
                 TYPE: post  -------------------------------------------------------------*/
  static const dashboard = "broker/dashboard";

/*------------------------------------------------------------
                 API:dashboard
                 TYPE: post  -------------------------------------------------------------*/
  static const assignProperty = "broker/property/assign?";

/*------------------------------------------------------------
                 API:notificationList
                 TYPE: post  -------------------------------------------------------------*/
  static const notificationList = "broker/notification/list";
/*------------------------------------------------------------
                 API:readNotification
                 TYPE: post  -------------------------------------------------------------*/
  static const readNotification = "broker/notification/read?id=";

/*------------------------------------------------------------
                 API:changeLead
                 TYPE: post  -------------------------------------------------------------*/
  static const changeLead = "broker/leads/status";
}
