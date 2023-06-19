class ApiUrl {
  static const apiV1 = 'v1/';

  //! GET
  static const ssoUserInfo = '/connect/userinfo';
  static const ssoUserCookie = '/account/GetAuthCookies';
  static const apigeeToken = '/oauth/v1/token';
  static const forceUpdate = '/v1/force-update-apps/version';

  //! Profile
  //! Delegators
  static const delegators =
      '/v1/delegation-services/delegated-commercial-records';
  //! Dashboard
  static const dashboardCards =
      '/v1/balady-dashboard/balady-life-style/main-cards';
  static dashboardCardProducts(int cardId) =>
      '/v1/balady-dashboard/balady-life-style/main-cards/$cardId/products';
  static const dashboardCardStatistics =
      '/v1/balady-dashboard/balady-life-style/statistics';
  //!Requests
  static const requests = '/v1/balady-dashboard/requests/my-requestes';
  static const requestStatuses = '/v1/balady-dashboard/requests/statuses';
  static const municipalities = '/v1/balady-dashboard/requests/municipalities';
  static subMunicipalities(String id) =>
      '/v1/balady-dashboard/requests/sub-municipalities/$id';
  static const requestTypes = '/v1/balady-dashboard/requests/main-types';
  static requestSubTypes(int id) =>
      '/v1/balady-dashboard/requests/sub-main-types/$id';
  //! Invoices
  static const invoices = '/v1/balady-dashboard/invoices/my-invoices';
  static const invoiceTypes = '/v1/balady-dashboard/invoices/main-types';
  static invoiceSubTypes(int id) =>
      '/v1/balady-dashboard/invoices/sub-main-types/$id';
  static const invoiceStatuses = '/v1/balady-dashboard/invoices/statuses';
  //! Licenses
  static const licenses = '/v1/balady-dashboard/license/my-licenses';
  static const licenseTypes = '/v1/balady-dashboard/license/main-types';
  static licenseSubTypes(int id) =>
      '/v1/balady-dashboard/license/sub-main-types/$id';
  static const licenseStatuses = '/v1/balady-dashboard/license/statuses';

// VD
  static const gis = '/v1/crm/bcg/gis-info';
  static const vdCategories = '/v1/crm/bcg/categories';
  static const vdSpecialClassifications = '/v1/crm/bcg/special-classifications';

  static const vdSpecialClassificationDetails =
      '/v1/crm/bcg/special-classification-details';

  static const vdUploadFile = '/v1/crm/upload/bcg/upload-file';

  static const getOTP = '/v1/crm/bcg/otp';

  static const createIncidentRegistered =
      '/v1/crm/bcg/registered-user/incident';
  static const createIncidentUnRegistered =
      '/v1/crm/bcg/unregistered-user/incident';

  static const vdCategoriesRegistered =
      '/v1/crm/bcg/registered-user/categories';

  static const vdCrExists = '/v1/crm/cr-exists/';

  //! POST

  //! Delete

  //! Patch
}

/// It has any header which used inside any API
// class ApiHeader {
//   static const requiresToken = "requiresToken";
//   static const language = "Accept-Language";
//   static const verifyingKEY = "verifyingKEY";
// }

/// It has any params which used inside any API
/*class ApiParam {
  static const phoneNumber = 'phoneNumber';
  static const username = 'userName';
  static const password = 'password';
  static const email = 'Email';
  static const refreshToken = 'refreshToken';
  static const mimeType = '{extension}';

  // General
  static const cityId = "cityId";
  static const pageSize = "pageSize";
  static const pageIndex = "pageIndex";
  static const pageNo = "pageNo";
  static const page_No = "page-no";
  static const page_Size = "page-size";
  static const profileId = "profileId";
  static const maxCount = "maxCount";
  static const name = "name";
  static const typeId = "typeId";
  static const langId = "langId";
  static const sort = "sort";
  static const desc = "desc";
  static const asc = "asc";

// Search API
  static const text = "text";

  // My Orders
  static const closed = "closed";
  static const hasPendingCancelRequest = "has-pending-cancel-request";

// Force Update
  static const appID = "appID";
  static const type = "type";

// Main-Service API

// Notifications
  static const id = "id";
  static const notificationToken = "notificationToken";
  static const os = "os";

  // game
  static const gameCategory = 'category';
  static const gameProvider = 'provider';
  static const gameSort = 'sort';
  static const gamePageSize = 'page_size';
  static const gamePageNumber = 'page_number';
  static const gameCoupon = 'coupon';
  static const gameTaskName = 'task_name';
}
*/
