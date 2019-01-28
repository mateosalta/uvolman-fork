TEMPLATE = aux
TARGET = uVolMan

QML_FILES += $$files(*.qml,true) \
             $$files(*.js,true)

CONF_FILES +=  uVolMan.apparmor \
               uVolMan.png \
               uVolManBack.png \

OTHER_FILES += $${CONF_FILES} \
               $${QML_FILES} \
               uVolMan.desktop 

#specify where the qml/js files are installed to
qml_files.path = /uVolMan
qml_files.files += $${QML_FILES}

#specify where the config files are installed to
config_files.path = /uVolMan
config_files.files += $${CONF_FILES}

#install the desktop file, a translated version is automatically created in 
#the build directory
desktop_file.path = /uVolMan
desktop_file.files = $$OUT_PWD/uVolMan.desktop 
desktop_file.CONFIG += no_check_exist 

INSTALLS+=config_files qml_files desktop_file

