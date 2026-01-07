TEMPLATE = app

QT += qml quick sql core widgets quickcontrols2

CONFIG += c++11

HEADERS += dbthread.h \
    sqlite.h \
    SqlTableModel.h

SOURCES += main.cpp \
dbthread.cpp \
    sqlite.cpp \
    SqlTableModel.cpp

RESOURCES += qml.qrc

# Additional import path used to resolve QML modules in Qt Creator's code model
QML_IMPORT_PATH =

# Default rules for deployment.
include(deployment.pri)
