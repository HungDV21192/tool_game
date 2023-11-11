# tool_eat_all_game

tool_eat_all_game

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

flutter build apk --flavor store --release --target-platform android-arm --analyze-size
flutter build apk --flavor store --release --target-platform android-arm64 --analyze-size
flutter build apk --flavor store --release  --target-platform android-x64 --analyze-size


Để upload web lên firebase hosting (sau khi cập nhật code)
---------***********--------
b0. web/index.html -> scriptTag.version = 3 (nang version de refresh ban build web);
ex:
    var serviceWorkerVersion = null;
    var scriptLoaded = false;
    function loadMainDartJs() {
    if (scriptLoaded) {
    return;
    }
    scriptLoaded = true;
    var scriptTag = document.createElement('script');
    scriptTag.src = 'main.dart.js';
    scriptTag.version = 3;
    scriptTag.type = 'application/javascript';
    document.body.append(scriptTag);
}
---------***********--------
download Firebase CLI cho windows (file: firebase-tools-instant-win) https://firebase.google.com/docs/cli#install-cli-windows.
b1.Download firebase CLI (firebase-tools-instant-win file)
b2. Run file firebase-tools-instant-win.
b3. cd D:\sample\tool_eat_all_Game (trở vào thư mục chứa project).
b4. NHập lệnh firebase init hosting, chọn Y
b5. gõ build/web khi được hỏi (what do you want to use as your public directory?).
6.Configure as a single-page app (review all urls to/index.html? y/N chọn Y.
b7. chọn Y khi được hỏi có overwite file public/404.html.
b8. tương tự với file index.html chọn Y
b9. gõ flutter build web
b10. Gõ firebase deploy --only hosting