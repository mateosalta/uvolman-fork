TEMPLATE = lib
TARGET = UVolManbackend
QT += qml quick dbus
CONFIG += qt plugin

load(ubuntu-click)

TARGET = $$qtLibraryTarget($$TARGET)

# Input
SOURCES += \
    backend.cpp \
    DBus/DBusGtkAction.cpp \
    DBus/GtkActionsInterface.cpp \
    DBus/DBusRestoreEntryVolume.cpp \
    DBus/PulseRestoreEntry.cpp \
    DBus/PulseStreamRestore.cpp \
    IndicatorSoundService.cpp

HEADERS += \
    backend.h \
    DBus/DBusGtkAction.h \
    DBus/GtkActionsInterface.h \
    DBus/DBusRestoreEntryVolume.h \
    DBus/PulseRestoreEntry.h \
    DBus/PulseStreamRestore.h \
    IndicatorSoundService.h

OTHER_FILES = qmldir

!equals(_PRO_FILE_PWD_, $$OUT_PWD) {
    copy_qmldir.target = $$OUT_PWD/qmldir
    copy_qmldir.depends = $$_PRO_FILE_PWD_/qmldir
    copy_qmldir.commands = $(COPY_FILE) \"$$replace(copy_qmldir.depends, /, $$QMAKE_DIR_SEP)\" \"$$replace(copy_qmldir.target, /, $$QMAKE_DIR_SEP)\"
    QMAKE_EXTRA_TARGETS += copy_qmldir
    PRE_TARGETDEPS += $$copy_qmldir.target
}

qmldir.files = qmldir
installPath = $${UBUNTU_CLICK_PLUGIN_PATH}/UVolMan
qmldir.path = $$installPath
target.path = $$installPath
INSTALLS += target qmldir


