TEMPLATE = aux
TARGET = ubuntu-app-platform

# creating an empty ubuntu-app-platform/ directory, this is
# required by snapcraft
fake_files.path = /ubuntu-app-platform
fake_files.files = fake_files
fake_files.CONFIG += no_check_exist

INSTALLS+=fake_files
