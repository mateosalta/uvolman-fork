/*
 * This file is part of uvolman.dfiloni
 *
 * Copyright (C) 2016-2017 Devid Antonio Filoni https://launchpad.net/~d.filoni
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.9
import Lomiri.Components 1.3
import UVolMan 1.0
import Lomiri.Components.ListItems 1.3 as ListItems
import GSettings 1.0
/*!
    \brief MainView with a Label and Button elements.
*/

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    id: uVolMan
    objectName: "mainView"
       // theme.name: "Ubuntu.Components.Themes.SuruDark"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "uvolman.mateosalta"
    property string applicationVersion: "0.4.0"

    width: units.gu(100)
    height: units.gu(75)

    PageStack {
        id: mainStack
        Component.onCompleted: push(mainPage)

        Page {
            id: mainPage
            visible: false

            header: PageHeader {
                anchors.top: mainPage.top
                id: pageHeader
                title: i18n.tr("uVolMan")
                StyleHints {
                    foregroundColor: "white"
                    backgroundColor: "#aa0044"
                    dividerColor: UbuntuColors.silk
                }
                trailingActionBar {
                    actions: [
                        Action {
                            iconName: "info"
                            text: i18n.tr("About")
                            onTriggered: mainStack.push(Qt.resolvedUrl("AboutPage.qml"))

                        }
                   ]
                   numberOfSlots: 1
                }
            }

            IndicatorSoundService {
                id: indicatorSoundService
                property real cachedVolume: indicatorSoundService.getVolume();
                property real cachedMicVolume: indicatorSoundService.getMicVolume();
                onVolumeChanged: {
                    if (cachedVolume !== newValue)
                    {
                        cachedVolume = newValue;
                        if (volumeSlider.slider.value !== cachedVolume)
                            volumeSlider.slider.value = cachedVolume;
                    }
                }
                onMicVolumeChanged: {
                    if (cachedMicVolume !== newValue)
                    {
                        cachedMicVolume = newValue;
                        if (micVolumeSlider.slider.value !== cachedMicVolume)
                            micVolumeSlider.slider.value = cachedMicVolume;
                    }
                }
            }

            PulseStreamRestore {
                id: pulseStreamRestore
            }

            Flickable {
                anchors.top: pageHeader.bottom
                anchors.left: parent.left
                anchors.right: parent.right
                height: parent.height-pageHeader.height
                contentHeight: mainColumn.height
                flickableDirection: Flickable.VerticalFlick

                Column {
                    id: mainColumn
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top

                    ListItem {
                        id: indicatorSoundLabel
                        Label {
                            anchors {
                                fill: parent
                                leftMargin: units.gu(2)
                                topMargin: units.gu(3);
                                bottomMargin: units.gu(2);
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Main")
                            font.pixelSize: units.gu(2);
                        }
                        divider.visible: false
                    }

                    VolSlider {
                        id: volumeSlider
                        property bool firstValueChange: false
                        labelText: i18n.tr("Speakers")
                        slider.value: indicatorSoundService.cachedVolume
                         icon.color: Theme.palette.normal.foregroundText
                        icon1.color: Theme.palette.normal.foregroundText
                        slider.onValueChanged: {
                            if (indicatorSoundService.cachedVolume !== slider.value)
                                indicatorSoundService.setVolume(slider.value);
                        }
                        enabled: (indicatorSoundService.cachedVolume != -1)
                        divider.visible: (indicatorSoundService.cachedVolume != -1)
                    }
                    ListItem {
                        id: volumeSliderError
                        visible: (indicatorSoundService.cachedVolume == -1)
                        height: visible ? units.gu(3) : 0
                        Text {
                            anchors {
                                top: parent.top
                                left: parent.left
                                leftMargin: units.gu(2)
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Speakers configuration not available!")
                        }
                    }

                    VolSlider {
                        id: micVolumeSlider
                        property bool firstValueChange: false
                        labelText: i18n.tr("Microphone")
                        slider.value: indicatorSoundService.cachedMicVolume
                        icon.color: Theme.palette.normal.foregroundText
                        icon1.color: Theme.palette.normal.foregroundText
                        slider.onValueChanged: {
                            if (indicatorSoundService.cachedMicVolume !== slider.value)
                                indicatorSoundService.setMicVolume(slider.value);
                        }
                        enabled: (indicatorSoundService.cachedMicVolume != -1)
                        divider.visible: (indicatorSoundService.cachedMicVolume != -1)
                    }
                    ListItem {
                        id: micVolumeSliderError
                        visible: (indicatorSoundService.cachedMicVolume == -1)
                        height: visible ? units.gu(3) : 0
                        Text {
                            anchors {
                                top: parent.top
                                left: parent.left
                                leftMargin: units.gu(2)
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Microphone configuration not available!")
                        }
                    }



                    ListItem {
                        id: streamRestoreEntriesLabel
                        anchors.left: parent.left
                        anchors.right: parent.right

                        Label {
                            anchors {
                                fill: parent
                                leftMargin: units.gu(2)
                                topMargin: units.gu(3);
                                bottomMargin: units.gu(2);
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Audio")
                            font.pixelSize: units.gu(2);
                        }

                        Button {
                            id: streamRestoreEntriesCheckbox
                            property bool checked: false
                            onClicked: checked = !checked;

                            Icon {
                                anchors.fill: parent
                                anchors.margins: units.gu(0.1);
                                name: "compose"
                                color:  streamRestoreEntriesCheckbox.checked ? "white" : "#808080"
                            }

                            anchors {
                                right: parent.right
                                top: parent.top
                                rightMargin: units.gu(2);
                                topMargin: units.gu(2.75);
                            }
                            width: height
                            height: units.gu(3)
                            StyleHints {
                                defaultColor: streamRestoreEntriesCheckbox.checked ? "#808080" : "white"
                            }
                            visible: (pulseStreamRestore.isConnected())
                        }
                        /* Switch {
                            id: streamRestoreEntriesCheckbox
                            checked: false
                            anchors {
                                right: parent.right
                                top: parent.top
                                rightMargin: units.gu(2);
                                topMargin: units.gu(3);
                            }
                            visible: (pulseStreamRestore.isConnected())
                        } */

                        divider.visible: false
                    }

                    Column {
                        id: streamRestoreEntriesList
                        anchors.left: parent.left
                        anchors.right: parent.right

                        function extractEntriesKeys()
                        {
                            var keys = [];
                            for (var entry in pulseStreamRestore.getEntries())
                                keys.push(entry);
                            return keys;
                        }

                        Repeater {
                            model: streamRestoreEntriesList.extractEntriesKeys()
                            VolSlider {
                                property variant entryObj: false
                                                                icon.color:  streamRestoreEntriesCheckbox.checked ? Theme.palette.normal.foregroundText : Theme.palette.disabled.foregroundText
                                                                icon1.color:  streamRestoreEntriesCheckbox.checked ? Theme.palette.normal.foregroundText : Theme.palette.disabled.foregroundText
                                slider.onValueChanged: {
                                    entryObj.setVolume(slider.value);
                                }
                                visible: {
                                   if (labelText == 'sink-input-by-media-role:phone' ||
                                       labelText == 'sink-input-by-media-role:alert' ||
                                       labelText == 'sink-input-by-media-role:multimedia' ||
                                       labelText == 'sink-input-by-media-role:alarm')
                                       return true;
                                   else
                                       return false;
                                }

                                Connections {
                                    target: entryObj
                                    ignoreUnknownSignals: true
                                    onVolumeChanged: {
                                        slider.value = newValue;
                                    }
                                }
                            }
                            onItemAdded: {
                                var entries = pulseStreamRestore.getEntries();
                                var entries_keys = streamRestoreEntriesList.extractEntriesKeys();
                                item.entryObj = entries[entries_keys[index]];
                                item.labelText = item.entryObj.getName();
                                item.slider.value = item.entryObj.getVolume();
                            }
                        }
                        enabled: (pulseStreamRestore.isConnected() && streamRestoreEntriesCheckbox.checked)
                        visible: pulseStreamRestore.isConnected()
                    }
                    ListItem {
                        id: streamRestoreEntriesListError
                        height: units.gu(4)
                        Text {
                            anchors {
                                top: parent.top
                                left: parent.left
                                topMargin: units.gu(1)
                                leftMargin: units.gu(2)
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("StreamRestore1 configuration not available!")
                            visible: (!pulseStreamRestore.isConnected())
                        }
                        divider.visible: (!pulseStreamRestore.isConnected())
                    }
                    
                        ListItem {
                        //id: indicatorSoundLabel
                        Label {
                            anchors {
                                fill: parent
                                leftMargin: units.gu(2)
                                topMargin: units.gu(3);
                                bottomMargin: units.gu(2);
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("High Volume Notification")
                            font.pixelSize: units.gu(2);
                        }
                        divider.visible: false
                    }
                     GSettings {
    id: settings
    schema.id: "org.ayatana.indicator.sound"
  }
  GSettings {
    id: ubuntu
    schema.id: "com.lomiri.sound"
  }
                    
    ListItems.Standard {
      text: i18n.tr('warning-volume-enabled')
      control: Switch {
        checked: settings.warningVolumeEnabled
        onClicked: {
            settings.warningVolumeEnabled = checked ? 'true' : 'false'

        }
      }
    }
        ListItem {

                        Label {
                            anchors {
                                fill: parent
                                leftMargin: units.gu(2)
                                topMargin: units.gu(3);
                                bottomMargin: units.gu(2);
                            }
                            horizontalAlignment: Text.AlignLeft
                            text: i18n.tr("Amplification")
                            font.pixelSize: units.gu(2);
                        }
                        divider.visible: false
                    }
      ListItems.Standard {
      id: allowAmp
      text: i18n.tr('allow-amplified-volume')
      control: Switch {
      id: allowSwitch
        checked: ubuntu.allowAmplifiedVolume
        onClicked: {
            ubuntu.allowAmplifiedVolume = checked ? 'true' : 'false'
        }
      }
    }
     VolSlider {
                        id: ampVolumeSlider
                        property bool firstValueChange: false
                        labelText: i18n.tr("Ampliflication ammount")
                        slider.value: -5.0
                        //slider.function slider.formatValue(v) { return v.toFixed(0) }
                                   icon.color:  allowSwitch.checked ? Theme.palette.normal.foregroundText : Theme.palette.disabled.foregroundText 
                                   icon1.color:  allowSwitch.checked ? Theme.palette.normal.foregroundText : Theme.palette.disabled.foregroundText 
                                
                        
                        slider.onValueChanged: {
                            settings.amplifiedVolumeDecibels = slider.value }
                            enabled: allowSwitch.checked
                            slider.minimumValue: 0
                            slider.maximumValue: 6
                     
                      
                    }
  
                }
            }
        }
    }
}



