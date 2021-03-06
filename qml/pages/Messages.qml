/*
    Copyright (C) 2016 Ales Katona.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0
import Sailfish.Pickers 1.0
import "../components"

Page {
    id: page
    allowedOrientations: Orientation.Portrait
    property bool checkFriendID: true

    onVisibleChanged: {
        if ( appWindow.activeFriendID < 0 ) {
            return; // nothing
        }

        if ( !checkFriendID && !visible ) {
            checkFriendID = true;
            return;
        }

        eventmodel.setFriend(visible ? appWindow.activeFriendID : -1)
        if ( visible ) {
            listView.positionViewAtEnd()
        }
    }

    Component {
        id: filePickerPage
        FilePickerPage {
            nameFilters: [ '*.*' ]
            onSelectedContentPropertiesChanged: {
                eventmodel.sendFile(selectedContentProperties.filePath)
            }
        }
    }

    SilicaListView {
        id: listView

        header: PageHeader {
            id: pageHeader
            title: eventmodel.friendName

            UserStatusIndicator {
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: Theme.paddingLarge
                }

                userStatus: eventmodel.friendStatus
            }
        }

        anchors.fill: parent

        spacing: Theme.paddingSmall
        model: eventmodel
        VerticalScrollDecorator {
            flickable: listView
        }

        PushUpMenu {
            enabled: toxcore.status > 0 && eventmodel.friendStatus > 0
            MenuItem {
                text: qsTr("Send file")
                onClicked: {
                    checkFriendID = false // ensure we don't lose friendID
                    pageStack.push(filePickerPage)
                }
            }
        }

        delegate: MessageItem {}

        footer: InputItem {
            onSendMessage: {
                eventmodel.sendMessage(msg)
                listView.positionViewAtEnd()
            }
        }
    }
}


