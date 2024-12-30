const is_dev = process.env.APP_VARIANT === 'development';
const enable_http = process.env.ENABLE_HTTP == true; 
export default {
	"expo": {
		"name": "IBDM" + (is_dev ? ' (Dev)' : ''),
		"slug": "IBDM",
		"version": "1.0.0",
		"orientation": "portrait",
		"icon": "./assets/icons/logo/logoImageSet/android/drawable-hdpi/logo.png",
		"scheme": "ibdm",
		"userInterfaceStyle": "automatic",
		"newArchEnabled": true,
		"jsEngine": "hermes",
		"ios": {
			"infoPlist": {
				"NSAppTransportSecurity": { "NSAllowsArbitraryLoads": enable_http }
			},
			"supportsTablet": true,
			"bundleIdentifier": "com.ifri.ibdm"
		},
		"android": {
			"adaptiveIcon": {
				"foregroundImage": "./assets/icons/logo/logoImageSet/android/drawable-hdpi/logo.png",
				"backgroundColor": "#ffffff"
			},
			"permissions": [
				"android.permission.INTERNET",
				"android.permission.ACCESS_NETWORK_STATE",
				"android.permission.ACCESS_WIFI_STATE"
			],
			"package": "com.ifri.ibdm"+(is_dev ? '.dev' : ''),
		},
		"web": {
			"bundler": "metro",
			"output": "static",
			"favicon": "./assets/icons/logo/logoImageSet/android/drawable-hdpi/logo.png"
		},
		"plugins": [
			"expo-router",
			[
				"expo-build-properties",
				{
					"android": {
						"usesCleartextTraffic": enable_http
					}
				}
			],
			[
				"expo-splash-screen",
				{
					"image": "./assets/icons/logo/logoImageSet/android/drawable-hdpi/logo.png",
					"imageWidth": 200,
					"resizeMode": "contain",
					"backgroundColor": "#ffffff"
				}
			]
		],
		"experiments": {
			"typedRoutes": true
		},
		"extra": {
			"router": {
				"origin": false
			},
			"eas": {
				"projectId": "ff84471f-6744-4336-9482-76c8877af551"
			}
		}
	}
}
