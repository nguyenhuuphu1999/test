class Endpoints {
  // Auth endpoints
  static const login = '/auth/login';
  static const register = '/auth/register';
  static const me = '/auth/me';
  static const forgotPassword = '/auth/forgot-password';
  static const resetPassword = '/auth/reset-password';
  static const refreshToken = '/auth/refresh-token';

  // User endpoints
  static const userProfile = '/user/profile';
  static const updateProfile = '/user/profile';
  static const changePassword = '/user/change-password';

  // VPN endpoints
  static const devices = '/vpn/devices';
  static const createDevice = '/vpn/devices';
  static const deviceDetails = '/vpn/devices/{id}';
  static const connectDevice = '/vpn/devices/{id}/connect';
  static const disconnectDevice = '/vpn/devices/{id}/disconnect';

  // Subscription endpoints
  static const plans = '/subscription/plans';
  static const subscribe = '/subscription/subscribe';
  static const mySubscription = '/subscription/my-subscription';

  // Payment endpoints
  static const paymentMethods = '/payment/methods';
  static const createPayment = '/payment/create';
  static const paymentStatus = '/payment/{id}/status';

  // FAQ endpoints
  static const faq = '/faq';
  static const support = '/support';
}
