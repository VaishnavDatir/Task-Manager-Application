/// Centralized place for managing all asset paths in the app.
/// Keeps code clean and prevents typos or hard-coded paths.
library;

class AppAssets {
  //  Image Assets
  static const String baseImages = 'assets/images';
  static const String baseIcons = 'assets/icons';
  static const String baseLottie = 'assets/lottie';
  static const String baseAnimations = 'assets/animations';

  // svgs
  static const String svgSignInWhite = "$baseImages/undraw_sign-in.svg";

  // --- Illustrations ---
  static const String welcomeIllustration =
      '$baseImages/welcome_illustration.png';
  static const String splashLogo = '$baseImages/splash_logo.png';
  static const String profilePlaceholder =
      '$baseImages/profile_placeholder.png';

  // --- Icons ---
  static const String icHome = '$baseIcons/home.png';
  static const String icTasks = '$baseIcons/tasks.png';
  static const String icProfile = '$baseIcons/profile.png';
  static const String icSettings = '$baseIcons/settings.png';

  // --- Lottie Files ---
  static const String loading = '$baseLottie/loading.json';
  static const String success = '$baseLottie/success.json';
  static const String error = '$baseLottie/error.json';
}
