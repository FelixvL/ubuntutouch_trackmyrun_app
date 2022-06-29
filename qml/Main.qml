/*
 * Copyright (C) 2022  T E Team
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3.
 *
 * trackmyrun is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */

import QtQuick 2.7
import Ubuntu.Components 1.3
//import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import Qt.labs.settings 1.0
import QtWebEngine 1.6
import QtPositioning 5.2
import QtWebChannel  1.0
import Example 1.0


MainView {
    id: root
    objectName: 'mainView'
    applicationName: 'gpstest.sander'
    automaticOrientation: true

    width: units.gu(45)
    height: units.gu(75)

    Page {
        anchors.fill: parent

        header: PageHeader {
            id: header
            title: i18n.tr('GPStest')
            subtitle: "Latitude: " 
        }

        PositionSource {
            id: geoposition
            active: true
            preferredPositioningMethods: PositionSource.SatellitePositioningMethods
            updateInterval:1000
        }
        WebChannel {
            id: myWebChannel


        }
        QtObject{
            id: qtObject

            property double hoogte : geoposition.position.coordinate.longitude
//            property double hoogte : 195   /// doorgegeven waarde naar html
        }
        WebEngineView {
            id: webEngineView
            webChannel: myWebChannel 

            anchors {
                fill: parent
                topMargin: header.height
            }

            url: "index.html?hoogte=99"

            userScripts: [
                WebEngineScript {
                    id: cssinjection
                    injectionPoint: WebEngineScript.DocumentReady
                    sourceUrl: "osm.js"
                    worldId: WebEngineScript.UserWorld
                }
            ]
        }
        Component.onCompleted: {
            myWebChannel.registerObject("qtObject",qtObject);
        }
    }
}