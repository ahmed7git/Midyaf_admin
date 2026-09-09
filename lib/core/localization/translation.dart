import 'package:get/get.dart';

class MyTranslation extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    "ar": {
      "onboarding_title_1": "اطلب بسهولة",
      "onboarding_body_1":
          "اختر ما تحتاجه من مطاعمك ومتاجرك المفضلة،\n"
          "تصفّح القوائم بسرعة،\n"
          "واطلب خلال ثوانٍ بخطوات بسيطة وواضحة.",
      "onboarding_title_2": "توصيل سريع وآمن",
      "onboarding_body_2":
          "يتم توصيل طلبك بأسرع وقت\n"
          "عبر مندوبين موثوقين، مع متابعة الطلب\n"
          "خطوة بخطوة حتى يصل إلى بابك.",
      "onboarding_title_3": "تجربة ذكية ومريحة",
      "onboarding_body_3":
          "استمتع بواجهة سهلة الاستخدام،\n"
          "وخيارات دفع متعددة، وعروض مميزة\n"
          "تجعل تجربة الطلب أفضل في كل مرة.",
      "login_welcome":
          "بين نقرة ووصول… تبدأالحكاية \n سجّل دخولك ودع السرعة تقوم بالباقي",
      "email_hint": "أدخل بريدك الإلكتروني",
      "phone_hint": "أدخل رقم هاتفك",
      "username_hint": "أدخل أسم مستخدم",
      "password_hint": "أدخل كلمة المرور",
      "login_forgot_password": "نسيت كلمة المرور?",
      "login_Have_account": "ليس لديك حساب ؟",
      "sign_up": "أنشاء حساب",
      "signup_Have_account": "لديك حساب ؟",
      "login": "تسجيل الدخول",
      "check": "تحقق الأن",
      "signup_welcome":
          "لكل حكاية رائعة بداية... \nأنشئ حسابك الآن وابدأ رحلة السرعة معنا.",
      "forgot_password_msg":
          "استعادة الحساب: \n أدخل البريد الإلكتروني المسجل لاستلام رمز مصادقة آمن لإعادة تعيين كلمة المرور.",
      "verify_email_msg":
          "تأكيد البريد الإلكتروني: \n أرسلنا رمز التحقق المكون من 5 أرقام إلى بريدك الإلكتروني. يرجى إدخاله في الخانات أدناه للمتابعة.",
      "reset_password_msg":
          "إعادة تعيين كلمة المرور: \n أنشئ كلمة مرور جديدة وقوية لتأمين حسابك وتسجيل الدخول.",
      "success": "تم بنجاح!",
      "pass_changed_msg":
          "تم إعادة تعيين كلمة المرور بنجاح. يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.",
      "account_verified_msg": "تم التحقق من حسابك بنجاح. أهلاً بك في Delever!",
      "continue": "متابعة",
      "signup_success_msg":
          "تم إنشاء الحساب بنجاح: \n حسابك أصبح نشطاً الآن. يمكنك البدء في استخدام جميع خدماتنا فوراً.",
      "err_empty": "هذا الحقل لا يمكن أن يكون فارغاً",
      "err_email": "يرجى إدخال بريد إلكتروني صحيح",
      "err_username": "صيغة اسم المستخدم غير صحيحة",
      "err_phone": "يرجى إدخال رقم هاتف صحيح",
      "err_min": "الحد الأدنى للطول هو",
      "err_max": "الحد الأقصى للطول هو",
      "exit_title": "انتظر!",
      "exit_message":
          "هل أنت متأكد من رغبتك في الخروج من التطبيق؟ نأمل رؤيتك مجدداً قريباً.",
      "exit_yes": "خروج",
      "exit_no": "إلغاء",
    },

    "en": {
      "onboarding_title_1": "Easy Ordering",
      "onboarding_body_1":
          "Choose what you need from your favorite restaurants and stores,\n"
          "browse menus quickly,\n"
          "and place your order in seconds with simple, clear steps.",
      "onboarding_title_2": "Fast & Secure Delivery",
      "onboarding_body_2":
          "Your order is delivered as quickly as possible\n"
          "by trusted couriers, with real-time tracking\n"
          "until it reaches your door.",
      "onboarding_title_3": "Smart & Convenient Experience",
      "onboarding_body_3":
          "Enjoy an easy-to-use interface,\n"
          "multiple payment options, and special offers\n"
          "that make ordering easier and better every time.",
      "login_welcome":
          "Between a tap and arrival… the story begins\n Log in and let speed do the rest",
      "email_hint": "Enter your email",
      "phone_hint": "Enter your phone number",
      "username_hint": "Enter your username",
      "password_hint": "Enter your Password",
      "login_forgot_password": "Forgot Password?",
      "login_Have_account": "Don't have an account ?",
      "sign_up": "Sign Up",
      "signup_Have_account": "Have an account",
      "login": "Sign In",
      "check": "Check Now",
      "signup_welcome":
          "Every great journey starts with a single tap... \nCreate your account and let the story of speed unfold.",
      "forgot_password_msg":
          "Account Recovery: \n Enter your registered email to receive a secure authentication token for password restoration.",
      "verify_email_msg":
          "Confirm your email: \n We've sent a 5-digit verification code to your email address. Please enter it below to continue.",
      "reset_password_msg":
          "Reset Password: \n Create a new, strong password to secure your account and log in.",
      "success": "Success!",
      "pass_changed_msg":
          "Your password has been reset successfully. You can now log in with your new password.",
      "account_verified_msg":
          "Your account has been verified successfully. Welcome to Delever!",
      "continue": "Continue",
      "signup_success_msg":
          "Account Created Successfully: \n Your account is now active. You can start using all our services immediately.",
      "err_empty": "This field cannot be empty",
      "err_email": "Please enter a valid email address",
      "err_username": "Invalid username format",
      "err_phone": "Please enter a valid phone number",
      "err_min": "The minimum length is",
      "err_max": "The maximum length is",
      "exit_title": "Wait!",
      "exit_message":
          "Are you sure you want to exit the application? We hope to see you again soon.",
      "exit_yes": "Exit",
      "exit_no": "Cancel",
    },
  };
}
