#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QFileInfo>
#include <QDebug>
#include <LayerShellQt/window.h>
#include "lockmanager.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QString qmlFile = "qrc:/qml/main.qml";  // Default QML path
    QString customPath;

    // Parse -c or --config argument
    for (int i = 1; i < argc - 1; ++i) {
        if ((QString(argv[i]) == "-c" || QString(argv[i]) == "--config")) {
            QFileInfo fileInfo(argv[i + 1]);
            if (fileInfo.exists() && fileInfo.isFile()) {
                customPath = QUrl::fromLocalFile(fileInfo.absoluteFilePath()).toString();
            } else {
                qWarning() << "Custom QML file not found:" << argv[i + 1];
            }
            break;
        }
    }

    QQmlApplicationEngine engine;

    // ✅ Instantiate and expose LockManager
    LockManager lockManager;
    engine.rootContext()->setContextProperty("lockManager", &lockManager);

    // ✅ Expose system username
    engine.rootContext()->setContextProperty("systemUsername", qgetenv("USER"));

    // Load either custom or default QML
    QUrl qmlUrl = customPath.isEmpty() ? QUrl(qmlFile) : QUrl(customPath);
    engine.load(qmlUrl);

    // Fallback to default if custom load failed
    if (engine.rootObjects().isEmpty() && !customPath.isEmpty()) {
        qWarning() << "Failed to load custom QML, falling back to default.";
        engine.load(QUrl(qmlFile));
    }

    if (engine.rootObjects().isEmpty())
        return -1;

    // Configure LayerShell
    QQuickWindow *window = qobject_cast<QQuickWindow *>(engine.rootObjects().first());
    auto layerWindow = LayerShellQt::Window::get(window);
    layerWindow->setLayer(LayerShellQt::Window::LayerOverlay);
    layerWindow->setKeyboardInteractivity(LayerShellQt::Window::KeyboardInteractivityExclusive);
    layerWindow->setAnchors({
        LayerShellQt::Window::AnchorTop,
        LayerShellQt::Window::AnchorBottom,
        LayerShellQt::Window::AnchorLeft,
        LayerShellQt::Window::AnchorRight
    });
    layerWindow->setExclusiveZone(-1);

    window->show();
    return app.exec();
}
