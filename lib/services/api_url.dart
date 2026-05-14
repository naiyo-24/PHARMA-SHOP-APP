class ApiUrl {
  static const String baseUrl =
      "http://10.0.2.2:8000"; // Replace with your actual backend URL

  // Pharma Shop Authentication and Profile Endpoints
  static const String signup = "$baseUrl/auth/pharma-shop/signup";
  static const String login = "$baseUrl/auth/pharma-shop/login";
  static const String getShopById =
      "$baseUrl/auth/pharma-shop/get-by"; // Append shopId
  static const String updateShopById =
      "$baseUrl/auth/pharma-shop/update-by"; // Append shopId
  static const String deleteShopById =
      "$baseUrl/auth/pharma-shop/delete-by"; // Append shopId
}
