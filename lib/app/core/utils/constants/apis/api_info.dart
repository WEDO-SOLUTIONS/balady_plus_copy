class ApiUrl {
  static const apiV1 = 'v1/';

  //! GET
  static const ssoUserInfo = '/v1/connect/userinfo';
  static const ssoUserCookie = '/account/GetAuthCookies';
  static const apigeeToken = '/oauth/v1/token';
  static const forceUpdate = '/v1/force-update-apps/version';

  //! Profile
  //! Dashboard
  static const dashboardCards =
      '/v1/balady-dashboard/balady-life-style/main-cards';
  static dashboardCardProducts(int cardId) =>
      '/v1/balady-dashboard/balady-life-style/main-cards/$cardId/products';
  static const dashboardCardStatistics =
      '/v1/balady-dashboard/balady-life-style/statistics';

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
