// MIT License
//
// Copyright (c) 2017 Niraj Desai
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

#include <QApplication>
#include <QQmlContext>
#include <QtQml>
#include <QQmlApplicationEngine>
#include <QClipboard>
#include "sqlite.h"
#include <QQuickStyle>

class Utility : public QObject {
    Q_OBJECT
public:
    explicit Utility(QObject* parent = 0) {
        Q_UNUSED(parent)
    }

    Q_INVOKABLE void saveTextToClipboard(QString text) {
        QClipboard *clipboard = QApplication::clipboard();
        clipboard->setText(text);
    }
};

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    QQuickStyle::setStyle("Material");

    qmlRegisterType<SQLite>("st.app", 1, 0, "SQLite");
    qmlRegisterType<SqlTableModel>("st.app", 1, 0, "SqlTableModel");

    Utility utility;
    engine.rootContext()->setContextProperty("$", &utility);
    engine.load(QUrl(QStringLiteral("qrc:/qml/main.qml")));

    return app.exec();
}

#include "main.moc"
