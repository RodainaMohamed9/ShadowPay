import 'package:shadow_pay_app/database/models/profile_model.dart';
import 'package:shadow_pay_app/services/tokens/api_service.dart';

class ProfileService {
  static Future<ProfileModel?> getUserProfile() async {
    try {
      final dioClient = DioClient().dio;
      final response = await dioClient.get('/Profile/get-profile');

      if (response.statusCode == 200) {
        print(response.data);
        return ProfileModel.fromJson(response.data);
      } else {
        return null;
      }
    } catch (e) {
      print("Error fetching profile: $e");
      return null;
    }
  }
}
