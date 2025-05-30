'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "76eb243e9b7c564ab872f696625d660e",
"assets/AssetManifest.bin.json": "b77826dbe2220df16a93770222c14559",
"assets/AssetManifest.json": "f72ee1ff7f00597798093182e610d776",
"assets/assets/certificates/CA.pem": "a7b0e847c13ff9782da13d4967aed6fe",
"assets/assets/google_fonts/Poppins-Black.ttf": "14d00dab1f6802e787183ecab5cce85e",
"assets/assets/google_fonts/Poppins-BlackItalic.ttf": "e9c5c588e39d0765d30bcd6594734102",
"assets/assets/google_fonts/Poppins-Bold.ttf": "08c20a487911694291bd8c5de41315ad",
"assets/assets/google_fonts/Poppins-BoldItalic.ttf": "19406f767addf00d2ea82cdc9ab104ce",
"assets/assets/google_fonts/Poppins-ExtraBold.ttf": "d45bdbc2d4a98c1ecb17821a1dbbd3a4",
"assets/assets/google_fonts/Poppins-ExtraBoldItalic.ttf": "8afe4dc13b83b66fec0ea671419954cc",
"assets/assets/google_fonts/Poppins-ExtraLight.ttf": "6f8391bbdaeaa540388796c858dfd8ca",
"assets/assets/google_fonts/Poppins-ExtraLightItalic.ttf": "a9bed017984a258097841902b696a7a6",
"assets/assets/google_fonts/Poppins-Italic.ttf": "c1034239929f4651cc17d09ed3a28c69",
"assets/assets/google_fonts/Poppins-Light.ttf": "fcc40ae9a542d001971e53eaed948410",
"assets/assets/google_fonts/Poppins-LightItalic.ttf": "0613c488cf7911af70db821bdd05dfc4",
"assets/assets/google_fonts/Poppins-Medium.ttf": "bf59c687bc6d3a70204d3944082c5cc0",
"assets/assets/google_fonts/Poppins-MediumItalic.ttf": "cf5ba39d9ac24652e25df8c291121506",
"assets/assets/google_fonts/Poppins-Regular.ttf": "093ee89be9ede30383f39a899c485a82",
"assets/assets/google_fonts/Poppins-SemiBold.ttf": "6f1520d107205975713ba09df778f93f",
"assets/assets/google_fonts/Poppins-SemiBoldItalic.ttf": "9841f3d906521f7479a5ba70612aa8c8",
"assets/assets/google_fonts/Poppins-Thin.ttf": "9ec263601ee3fcd71763941207c9ad0d",
"assets/assets/google_fonts/Poppins-ThinItalic.ttf": "01555d25092b213d2ea3a982123722c9",
"assets/assets/google_fonts/Roboto-Black.ttf": "dc44e38f98466ebcd6c013be9016fa1f",
"assets/assets/google_fonts/Roboto-BlackItalic.ttf": "792016eae54d22079ccf6f0760938b0a",
"assets/assets/google_fonts/Roboto-Bold.ttf": "8c9110ec6a1737b15a5611dc810b0f92",
"assets/assets/google_fonts/Roboto-BoldItalic.ttf": "e85cb1c48a3695009621fdb836eb22e9",
"assets/assets/google_fonts/Roboto-ExtraBold.ttf": "27fd63e58793434ce14a41e30176a4de",
"assets/assets/google_fonts/Roboto-ExtraBoldItalic.ttf": "80b61563f9e8f51aa379816e1c6016ef",
"assets/assets/google_fonts/Roboto-ExtraLight.ttf": "83e5ab4249b88f89ccf80e15a98b92f0",
"assets/assets/google_fonts/Roboto-ExtraLightItalic.ttf": "41c80845424f35477f8ecadfb646a67d",
"assets/assets/google_fonts/Roboto-Italic.ttf": "1fc3ee9d387437d060344e57a179e3dc",
"assets/assets/google_fonts/Roboto-Light.ttf": "25e374a16a818685911e36bee59a6ee4",
"assets/assets/google_fonts/Roboto-LightItalic.ttf": "00b6f1f0c053c61b8048a6dbbabecaa2",
"assets/assets/google_fonts/Roboto-Medium.ttf": "7d752fb726f5ece291e2e522fcecf86d",
"assets/assets/google_fonts/Roboto-MediumItalic.ttf": "918982b4cec9e30df58aca1e12cf6445",
"assets/assets/google_fonts/Roboto-Regular.ttf": "303c6d9e16168364d3bc5b7f766cfff4",
"assets/assets/google_fonts/Roboto-SemiBold.ttf": "dae3c6eddbf79c41f922e4809ca9d09c",
"assets/assets/google_fonts/Roboto-SemiBoldItalic.ttf": "2d365b1721b9ba2ff4771393a0ce2e46",
"assets/assets/google_fonts/Roboto-Thin.ttf": "1e6f2d32ab9876b49936181f9c0b8725",
"assets/assets/google_fonts/Roboto-ThinItalic.ttf": "dca165220aefe216510c6de8ae9578ff",
"assets/assets/google_fonts/Roboto_Condensed-Black.ttf": "b8e3ed03047190a170b330b99cb497cf",
"assets/assets/google_fonts/Roboto_Condensed-BlackItalic.ttf": "77716aa38d5bfb3b7a8707797e6d6d65",
"assets/assets/google_fonts/Roboto_Condensed-Bold.ttf": "07bb72eb5189e2f32a17031e20535777",
"assets/assets/google_fonts/Roboto_Condensed-BoldItalic.ttf": "a716b7548d0a9e24b5e165906c017f73",
"assets/assets/google_fonts/Roboto_Condensed-ExtraBold.ttf": "e7921919c3021ad88323d48eb9294917",
"assets/assets/google_fonts/Roboto_Condensed-ExtraBoldItalic.ttf": "17772988c821639e9fe36044d6931208",
"assets/assets/google_fonts/Roboto_Condensed-ExtraLight.ttf": "cf9840bb59a0b4ef1f6441efde262ec0",
"assets/assets/google_fonts/Roboto_Condensed-ExtraLightItalic.ttf": "2c2c1df1100801d8a4b345d27f302980",
"assets/assets/google_fonts/Roboto_Condensed-Italic.ttf": "58ab0145561cf8b4782eea242cb30f5b",
"assets/assets/google_fonts/Roboto_Condensed-Light.ttf": "0f3de38ef164b0a65a8a0a686e08bbff",
"assets/assets/google_fonts/Roboto_Condensed-LightItalic.ttf": "d86a4886b06b3be02dd8c06db6c7b53d",
"assets/assets/google_fonts/Roboto_Condensed-Medium.ttf": "b9f98617f7bc110311f054d264f43b58",
"assets/assets/google_fonts/Roboto_Condensed-MediumItalic.ttf": "a887fedb5da68c3987dcaf272f685228",
"assets/assets/google_fonts/Roboto_Condensed-Regular.ttf": "6f1c323492d1266a46461cbc57101ad4",
"assets/assets/google_fonts/Roboto_Condensed-SemiBold.ttf": "e9bd6495779750596421effa84fdd4f5",
"assets/assets/google_fonts/Roboto_Condensed-SemiBoldItalic.ttf": "9f8f19b06543707a34bda741211fd833",
"assets/assets/google_fonts/Roboto_Condensed-Thin.ttf": "38ca91dbce841a3c3c20a3024a00fb93",
"assets/assets/google_fonts/Roboto_Condensed-ThinItalic.ttf": "66aeec1eb99fd707bbda2c23c0d88dbd",
"assets/assets/google_fonts/Roboto_SemiCondensed-Black.ttf": "4e83f16b2aae530ed5a9eea2c6fcba0e",
"assets/assets/google_fonts/Roboto_SemiCondensed-BlackItalic.ttf": "cee6c277748569381168fa4873f17951",
"assets/assets/google_fonts/Roboto_SemiCondensed-Bold.ttf": "4bc60797786e604a69c1b81a60231b6a",
"assets/assets/google_fonts/Roboto_SemiCondensed-BoldItalic.ttf": "11ddd56e0fc47673960de04be0ddaf6d",
"assets/assets/google_fonts/Roboto_SemiCondensed-ExtraBold.ttf": "cd66a60e5be720ca2c368e6b60348cd4",
"assets/assets/google_fonts/Roboto_SemiCondensed-ExtraBoldItalic.ttf": "76b49fa5b22fb20fd69561f17237e80d",
"assets/assets/google_fonts/Roboto_SemiCondensed-ExtraLight.ttf": "83c6c6b25720032a079c86b8244ece58",
"assets/assets/google_fonts/Roboto_SemiCondensed-ExtraLightItalic.ttf": "c5105f6fbcd6f492a2a6f99f92936d22",
"assets/assets/google_fonts/Roboto_SemiCondensed-Italic.ttf": "5cae5cd3f40c671315aea0e55f8aa469",
"assets/assets/google_fonts/Roboto_SemiCondensed-Light.ttf": "7f35ecca19fa7286023e6d5d29d98fee",
"assets/assets/google_fonts/Roboto_SemiCondensed-LightItalic.ttf": "ee86d3beb5d7e6f711f0f12f09179d48",
"assets/assets/google_fonts/Roboto_SemiCondensed-Medium.ttf": "ec198bede12e04919f81c2deabbfddfe",
"assets/assets/google_fonts/Roboto_SemiCondensed-MediumItalic.ttf": "4404af13d7c2b95be24b367e5dfaa726",
"assets/assets/google_fonts/Roboto_SemiCondensed-Regular.ttf": "1a494bea2b882849db6c932aee6a4302",
"assets/assets/google_fonts/Roboto_SemiCondensed-SemiBold.ttf": "4cd0ff27a44b68f74262ec5d63d9f304",
"assets/assets/google_fonts/Roboto_SemiCondensed-SemiBoldItalic.ttf": "60a345becd1b883beef9d02bbb655af6",
"assets/assets/google_fonts/Roboto_SemiCondensed-Thin.ttf": "4f2191b28015879bcd1836c2d03b9ac5",
"assets/assets/google_fonts/Roboto_SemiCondensed-ThinItalic.ttf": "b1b3f970c13ebd8f93345d10d6ac3626",
"assets/assets/images/ifruit.png": "e67fc7efb0ab6c736fd8296dc745c646",
"assets/assets/images/ifruit_logo.png": "e67fc7efb0ab6c736fd8296dc745c646",
"assets/assets/images/logo.png": "a32e9cc5a15248fd736b2f0094c90b76",
"assets/FontManifest.json": "4af0a70f2ec44d17eee5ebbea3fb4d05",
"assets/fonts/MaterialIcons-Regular.otf": "9fc849c48f44f7d25666fc82e0dc3984",
"assets/NOTICES": "dc836462378fc42a5e1b18f821f6b44a",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "33b7d9392238c04c131b6ce224e13711",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/geekyants_flutter_gauges/assets/fonts/Roboto-Regular.ttf": "8a36205bd9b83e03af0591a004bc97f4",
"assets/packages/iconsax_flutter/fonts/FlutterIconsax.ttf": "83c878235f9c448928034fe5bcba1c8a",
"assets/packages/lucide_icons_flutter/assets/lucide.ttf": "5a3f94f5a4cbe35f2ae3bbc430b110e4",
"assets/packages/shadcn_ui/fonts/Geist-Black.otf": "cf003c4f85b590cf60bec1e111ebaaf5",
"assets/packages/shadcn_ui/fonts/Geist-Bold.otf": "d3e1d3dc690224fd330969af598a9c31",
"assets/packages/shadcn_ui/fonts/Geist-Light.otf": "21f434e8c2b53240a0c459b9d119f22f",
"assets/packages/shadcn_ui/fonts/Geist-Medium.otf": "f7ceaf00b58d396cf93ff1ea43740027",
"assets/packages/shadcn_ui/fonts/Geist-Regular.otf": "4d02716b4f2f2e4d9c568c8d24e8e74d",
"assets/packages/shadcn_ui/fonts/Geist-SemiBold.otf": "2c0b1d3e7b1c71bedc2eecf78f7a1d1d",
"assets/packages/shadcn_ui/fonts/Geist-Thin.otf": "8603d0fe0def4273ebeee670eedcfb86",
"assets/packages/shadcn_ui/fonts/Geist-UltraBlack.otf": "f3591a030925294b2bb427e6a6c9b0d8",
"assets/packages/shadcn_ui/fonts/Geist-UltraLight.otf": "b64b37fbec0a925067cbf530e4962fec",
"assets/packages/shadcn_ui/fonts/GeistMono-Black.otf": "d72857791f93bbf88629ab9601ebfa14",
"assets/packages/shadcn_ui/fonts/GeistMono-Bold.otf": "fce632a1c87f36e92fb23ae5618176ce",
"assets/packages/shadcn_ui/fonts/GeistMono-Light.otf": "92c6dfb1c2854b6b0fd3f63ab5af9b7a",
"assets/packages/shadcn_ui/fonts/GeistMono-Medium.otf": "b1f17a06e50fba3f1e9695c2a8ae0783",
"assets/packages/shadcn_ui/fonts/GeistMono-Regular.otf": "42af0dfdb5e9e272e7ac28868b5b99fb",
"assets/packages/shadcn_ui/fonts/GeistMono-SemiBold.otf": "02036797116901c5db4a3a629561e588",
"assets/packages/shadcn_ui/fonts/GeistMono-Thin.otf": "cbf62a8e76578e03404b0314787d9477",
"assets/packages/shadcn_ui/fonts/GeistMono-UltraBlack.otf": "cfad4eb45ce5dff853a6c84c8a7d441b",
"assets/packages/shadcn_ui/fonts/GeistMono-UltraLight.otf": "45ea4a4ba1034f7fa081c8b7ee958734",
"assets/shaders/ink_sparkle.frag": "ecc85a2e95f5e9f53123dcaf8cb9b6ce",
"canvaskit/canvaskit.js": "86e461cf471c1640fd2b461ece4589df",
"canvaskit/canvaskit.js.symbols": "68eb703b9a609baef8ee0e413b442f33",
"canvaskit/canvaskit.wasm": "efeeba7dcc952dae57870d4df3111fad",
"canvaskit/chromium/canvaskit.js": "34beda9f39eb7d992d46125ca868dc61",
"canvaskit/chromium/canvaskit.js.symbols": "5a23598a2a8efd18ec3b60de5d28af8f",
"canvaskit/chromium/canvaskit.wasm": "64a386c87532ae52ae041d18a32a3635",
"canvaskit/skwasm.js": "f2ad9363618c5f62e813740099a80e63",
"canvaskit/skwasm.js.symbols": "80806576fa1056b43dd6d0b445b4b6f7",
"canvaskit/skwasm.wasm": "f0dfd99007f989368db17c9abeed5a49",
"canvaskit/skwasm_st.js": "d1326ceef381ad382ab492ba5d96f04d",
"canvaskit/skwasm_st.js.symbols": "c7e7aac7cd8b612defd62b43e3050bdd",
"canvaskit/skwasm_st.wasm": "56c3973560dfcbf28ce47cebe40f3206",
"favicon.png": "a32e9cc5a15248fd736b2f0094c90b76",
"flutter.js": "76f08d47ff9f5715220992f993002504",
"flutter_bootstrap.js": "5415fd1df99cbf09220c5b839ac0bcd3",
"icons/logo-192.png": "a32e9cc5a15248fd736b2f0094c90b76",
"icons/logo-512.png": "3329db83e53e3486297a700a0b32c80a",
"icons/logo-maskable-192.png": "a32e9cc5a15248fd736b2f0094c90b76",
"icons/logo-maskable-512.png": "3329db83e53e3486297a700a0b32c80a",
"index.html": "36922976cc4eed23cb8aa28b29e34527",
"/": "36922976cc4eed23cb8aa28b29e34527",
"main.dart.js": "ad9884d0924cba6eb43817c3bae3bb8a",
"manifest.json": "3e94f2758bf09a066b3136db5660d5a9",
"splash/img/branding-1x.png": "14285ca56c13939f812f877eefa9276d",
"splash/img/branding-2x.png": "f75f93069efee2189a28f465d7ec3bf0",
"splash/img/branding-3x.png": "59f431c0625e6e02b8cc4752fae6d16b",
"splash/img/branding-4x.png": "77f288b33da199c276e836f02ec79849",
"splash/img/branding-dark-1x.png": "14285ca56c13939f812f877eefa9276d",
"splash/img/branding-dark-2x.png": "f75f93069efee2189a28f465d7ec3bf0",
"splash/img/branding-dark-3x.png": "59f431c0625e6e02b8cc4752fae6d16b",
"splash/img/branding-dark-4x.png": "77f288b33da199c276e836f02ec79849",
"splash/img/dark-1x.png": "1c81a430b44c22e1198660f41a8886e1",
"splash/img/dark-2x.png": "0f8d3f82f659fb952cff38cabb7623e0",
"splash/img/dark-3x.png": "af2cbea6c1073b6abcdc4d27d5bbefa8",
"splash/img/dark-4x.png": "85242f3af47b6a363adb2fff2e177861",
"splash/img/light-1x.png": "1c81a430b44c22e1198660f41a8886e1",
"splash/img/light-2x.png": "0f8d3f82f659fb952cff38cabb7623e0",
"splash/img/light-3x.png": "af2cbea6c1073b6abcdc4d27d5bbefa8",
"splash/img/light-4x.png": "85242f3af47b6a363adb2fff2e177861",
"version.json": "e6b2c86b7b884409eb00025412e001ef"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"flutter_bootstrap.js",
"assets/AssetManifest.bin.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
