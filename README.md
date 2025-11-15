# WowTask -- Modern Task Management App

A clean, modern, and scalable **Task Management Application** built
using **Flutter**, following the **MVVM architecture**, powered by
**Provider**, and integrated with **Back4App** for secure authentication
and task management.

### 🧑‍💻 About the Developer

**Vaishnav Datir**\
Software Engineer 
Experienced in Java, Spring Boot, Microservices, Flutter, Firebase, SQL.

------------------------------------------------------------------------

## 🚀 Features

-   🔐 Secure Login & Signup (Back4App)
-   👤 User Profile & Session Handling
-   🏠 Home Dashboard with Task Filters
-   ➕ Create, Update & View Tasks
-   📅 Date-based Task Classification:
    -   Today\
    -   Upcoming\
    -   Past Due\
    -   Completed\
-   ⚡ MVVM + Provider State Management\
-   🛣️ GoRouter Navigation + Route Guards\
-   🎨 Centralized Theme + Clean UI\
-   📦 Repository Pattern\
-   💾 Local Storage (Shared Preferences)\
-   🔍 Custom Logger & Error Screens

------------------------------------------------------------------------

## Tech Stack

### Frontend

-   Flutter
-   Dart
-   Provider (State Management)
-   GoRouter (Navigation)
-   Dio (Networking)

### Backend

-   Back4App Parse Server

### Architecture

-   MVVM\
-   Repository Pattern\
-   Feature-First Structure\
-   Dependency Injection using Provider

------------------------------------------------------------------------

##  Project Structure

        📁lib
        └── 📁core
            └── 📁config 
                ├── app_initializer.dart
            └── 📁constants 
                ├── app_assets.dart
                ├── app_config.dart
                ├── app_keys.dart
                ├── app_strings.dart
            └── 📁di
                ├── app_providers.dart
            └── 📁models
                ├── task_model.dart
                ├── user_model.dart
            └── 📁network
                ├── api_client.dart
                ├── api_custom_header.dart
                ├── api_endpoints.dart
            └── 📁repositories
                ├── auth_repository.dart
                ├── task_repository.dart
            └── 📁routing
                └── 📁guards
                    ├── auth_guard.dart
                ├── app_navigator.dart
                ├── app_router.dart
                ├── app_routes.dart
                ├── route_names.dart
            └── 📁storage
                ├── app_preferences.dart
            └── 📁theme
                ├── app_colors.dart
                ├── app_shadows.dart
                ├── app_spacing.dart
                ├── app_theme.dart
                ├── app_typography.dart
            └── 📁utils
                ├── logger.dart
                ├── ui_utils.dart
            └── 📁widgets
                ├── error_screen.dart
                ├── wow_task_logo.dart
        └── 📁features
            └── 📁auth
                └── 📁view
                    └── 📁widgets
                        ├── about_app_sheet.dart
                        ├── auth_card.dart
                        ├── social_button.dart
                    ├── login_screen.dart
                    ├── profile_screen.dart
                    ├── signup_screen.dart
                    ├── welcome_screen.dart
                └── 📁view_model
                    ├── auth_viewmodel.dart
            └── 📁home
                └── 📁view
                    ├── home_screen.dart
                └── 📁view_model
                    ├── home_viewmodel.dart
            └── 📁splash
                └── 📁view
                    ├── splash_screen.dart
                └── 📁view_model
                    ├── splash_view_model.dart
            └── 📁task
                └── 📁view
                    ├── create_task_screen.dart
                    ├── edit_task_screen.dart
                    ├── task_detail_screen.dart
                └── 📁view_model
                    ├── task_view_model.dart
        └── main.dart

------------------------------------------------------------------------

## ▶️ How to Run the Project

#### **1️⃣ Clone the Repo**

``` sh
git clone https://github.com/VaishnavDatir/Task-Manager-Application.git
cd Task-Manager-Application
```

#### **2️⃣ Install Dependencies**

``` sh
flutter pub get
```

#### **3️⃣ Update Back4App Keys**

Go to:\
`create .env file`\
with structure:

``` 
BACK4APP_APPLICATION_ID=<your-app-id>
BACK4APP_CLIENT_API_KEY=<your-client-api-key>
BACK4APP_BASE_URL=https://parseapi.back4app.com
```

#### **4️⃣ Run the App**

``` sh
flutter run
```

------------------------------------------------------------------------


### ⭐ Show Support

If this project helped you, consider giving it a **star** on GitHub!