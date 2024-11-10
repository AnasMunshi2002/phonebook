import 'package:shared_preferences/shared_preferences.dart';

class ProfileStoreManager {
  static late final SharedPreferences profileManager;
  static const String profileKey = "PROFILE_KEY";

  static initProfilePref() async {
    profileManager = await SharedPreferences.getInstance();
  }

  static storeProfile(String imagePath) async {
    await profileManager.setString(profileKey, imagePath);
  }

  static String getProfile() {
    return profileManager.getString(profileKey) ?? "";
  }
}
