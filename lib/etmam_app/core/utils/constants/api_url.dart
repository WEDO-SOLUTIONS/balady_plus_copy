class ApiUrl {
  static const apiV1 = '/v1';

  //! GET
  static const search = '$apiV1/etmamplus-services/services/search';
  static const mainServices = '$apiV1/etmamplus-services/main-services';
  static const topOrderedServices =
      '$apiV1/etmamplus-services/services/top-ordered';
  static const topOrderedServiceProviders =
      '$apiV1/etmamplus-services/service-providers/top-rated';

  static const subServices = '$apiV1/etmamplus-services/sub-services/';

  static const services =
      '$apiV1/etmamplus-services/service-providers/by-service/';
  static const serviceDetails = '$apiV1/etmamplus-services/providers/';

  static const providers = '$apiV1/etmamplus-services/providers/';

  static const relationsByService =
      '$apiV1/etmamplus-services/order-management/relations/byservice/';

  static const defaultProfile = '$apiV1/etmamplus-services/profiles/default';
  static const myOrders =
      '$apiV1/etmamplus-services/order-management/orders/search';
  static const myRequests = '$apiV1/dashboard-services/user/by-user';

  static const cities = '$apiV1/etmamplus-services/cities';

  static const ads = '$apiV1/etmamplus-services/ads/search';
  static const ratingItems =
      '$apiV1/etmamplus-services/order-management/rating-types';

  static const orderDetails =
      '$apiV1/etmamplus-services/order-management/order-details/';

  static const requestDetails = '$apiV1/biddings-services/user/by-user/';

  static const findByRequestType =
      '$apiV1/etmamplus-services/order-management/relations/by-request-type/bidding';

  //! POST
  static const submitRequest =
      '$apiV1/etmamplus-services/order-management/orders/submit';
  static const sendOTP = '$apiV1/etmamplus-services/otp/send';

  static const verifyOTP = '$apiV1/etmamplus-services/otp/verify';

  static const createProfile = '$apiV1/etmamplus-services/profiles';

  static const cancelOrder =
      '$apiV1/etmamplus-services/order-management/orders/{}/cancel';

  static const submitOrderRating =
      '$apiV1/etmamplus-services/order-management/order-rate/';

  static const addDeviceToken = '$apiV1/etmamplus-services/devices';

  static const forceUpdate = 'force-update-apps/version';

  static const createDynamicForm = '$apiV1/mobile-dynamic-forms/create';
  static const getFormFieldsData =
      '$apiV1/mobile-dynamic-forms/data/form-fields';

  static const submitBiddingForm = '$apiV1/biddings-services/user/submit';
  static const editBiddingForm = '$apiV1/biddings-services/user/update';

  static const validateBiddingForm = '$apiV1/mobile-dynamic-forms/validate/';

  static const viewFormData = '$apiV1/mobile-dynamic-forms/view/';
  static const viewEditFormData = '$apiV1/mobile-dynamic-forms/for-edit/';

  static const getOffers = '$apiV1/biddings-services/user/offers/';
  static const acceptOffers = '$apiV1/offers-services/user/accept/';
  static const rejectOffers = '$apiV1/offers-services/user/reject/';
  static const submitOrder = '$apiV1/biddings-services/user/submit-order/';

  static const cancelRequest = '$apiV1/biddings-services/user/cancel/';

  static const bidAttachments =
      '$apiV1/etmamplus-archiving-services/attachments';

  //! Delete

  //! Patch

  //! Put
  static const changeProvider =
      '$apiV1/etmamplus-services/order-management/orders/change-providers';

  static const updateProfile = '$apiV1/etmamplus-services/profiles/';

  static const updateDeviceToken = '$apiV1/etmamplus-services/devices/';
}

/// It has any params which used inside any API
class ApiParams {
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

// Top Ordered SubService

//
  static const phoneNumber = 'phoneNumber';
  static const username = 'userName';
  static const password = 'password';
  static const email = 'Email';
}

/// It has any constants which used inside any API
class ApiConstants {}
