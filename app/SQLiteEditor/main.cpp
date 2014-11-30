#include <QApplication>
#include <QQmlContext>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QClipboard>

class Clipboard : public QObject {
    Q_OBJECT
public:
    explicit Clipboard(QObject* parent = 0) {
        Q_UNUSED(parent)
    }

    Q_INVOKABLE void setText(QString text) {
        QClipboard *clipboard = QApplication::clipboard();
        clipboard->setText(text);
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;
    qmlRegisterType<Clipboard>("st.app", 1, 0, "Clipboard");
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    // Step 1: get access to the root object
    QObject *rootObject = engine.rootObjects().first();
    QObject *qmlObject = rootObject->findChild<QObject*>("mainWindow");


    return app.exec();
}

#include "main.moc"
