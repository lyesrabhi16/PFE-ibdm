import { languages, stringsTranslationsType } from "#types";

export const defaultLanguage:languages = 'en' as languages;

export const stringsAll:stringsTranslationsType = {
    'login': {
        'title': {
            'en': 'Login',
            'fr': "S'identifier",
            'ar': 'تسجيل الدخول',
        },
        'email': {
            'en': 'Email',
            'fr': 'Email',
            'ar': 'البريد الإلكتروني',
        },
        'email_empty_message': {
            'en': 'Please input your Email!',
            'fr': 'Veuillez saisir votre email!',
            'ar': 'الرجاء إدخال بريدك الإلكتروني!',
        },
        'password': {
            'en': 'Password',
            'fr': 'Mot de passe',
            'ar': 'كلمة المرور',
        },
        'password_empty_message': {
            'en': 'Please input your Password!',
            'fr': 'Veuillez saisir votre mot de passe!',
            'ar': 'الرجاء إدخال كلمة المرور الخاصة بك!',
        },
        'login': {
            'en': 'Login',
            'fr': 'S’identifier',
            'ar': 'تسجيل الدخول',
        },
        'welcome_message': {
            'en': 'Welcome to our app',
            'fr': 'Bienvenue sur notre app',
            'ar': 'مرحبًا بك في تطبيقنا',
        },
        'login_message': {
            'en': 'Login to continue',
            'fr': 'identifier vous pour continuer',
            'ar': 'سجل الدخول للمتابعة',
        },
        'remember_me': {
            'en': 'Remember me',
            'fr': 'se souvenir de moi',
            'ar': 'تذكرنى',
        },
        'forgot_password_question': {
            'en': 'Forgot password?',
            'fr': 'Mot de passe oublié?',
            'ar': 'هل نسيت كلمة المرور؟',
        },

    },
    'startup': {
        'loading':{
            "en": "Loading...",
            "fr": "Chargement...",
            "ar": "...جار التحميل",
        }
    },
    'notfound': {
        'text': {
            'en': 'Page not found',
            'fr': 'Page non trouvée',
            'ar': 'الصفحة غير موجودة',
        }
    },
    'index': {
        'text1': {
            'en': 'Welcome to our app',
            'fr': 'Bienvenue sur notre app',
            'ar': 'مرحبًا بك في تطبيقنا',
        },
        'text2': {
            'en': 'Sign in',
            'fr': "S'identifier",
            'ar': 'تسجيل الدخول',
        }
    },
    'toasts': {
        'Error_SignIn_InProgress': {
            'en': 'Please wait, sign in is in progress...',
            'fr': 'Veuillez patienter, l\'authentification est en cours...',
            'ar': '...الرجاء الانتظار، تسجيل الدخول قيد التقدم',
        },
        'SignIn_successful': {
            'en': 'Sign in successful',
            'fr': 'Authentification réussie',
            'ar': 'تم تسجيل الدخول بنجاح',
        },
        'please_wait': {
            'en': 'Please wait...',
            'fr': 'Veuillez patienter...',
            'ar': '...الرجاء الانتظار',
        },
        'SignIn_failed': {
            'en': 'Sign in failed',
            'fr': 'Échec de l\'Authentification',
            'ar': 'فشل تسجيل الدخول',
        },
    }
}

