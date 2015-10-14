#include <QApplication>
#include <QQmlContext>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QClipboard>
#include "sqlite.h"

class Utility : public QObject {
    Q_OBJECT
public:
    explicit Utility(QObject* parent = 0)
    {
        Q_UNUSED(parent)
    }

    Q_INVOKABLE void saveTextToClipboard(QString text)
    {
        QClipboard *clipboard = QApplication::clipboard();
        clipboard->setText(text);
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    qmlRegisterType<SQLite>("st.app", 1, 0, "SQLite");

    Utility utility;
    engine.rootContext()->setContextProperty("$", &utility);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

#include "main.moc"
