import QtQuick 2.0

Item {
    id: root

    property string packageName : "st.app.vegguide"
    property string identifier : "VegGuide"
    property string version : "0.0.1"
    property string email : "support+vegguide@app.st"

    property url apiTest :  "http://appstreet.local/vg/test.json"
    property url apiTestEngland : "http://www.vegguide.org/search/by-lat-long/51.5033630,-0.1276250"

    property string latitude : _Location.latitude
    property string longitude : _Location.longitude

    property url apiNearby : "http://www.vegguide.org/search/by-lat-long/%lat,%long".replace(/%lat/g, latitude).replace(/%long/g, longitude)


    property variant apiRegion : {
        "url" : "http://localhost/vg/all.json",
        "headers" : {
            "Type" : "application/vnd.vegguide.org-regions+json"
        }
    }

    property url apiRecent : "http://appstreet.local/vg/recent.xml"

    // https://developers.google.com/maps/documentation/ios/urlscheme
    // https://developer.apple.com/library/ios/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
    property variant maps_ios : [
        "comgooglemaps://?q=",
        "http://maps.apple.com/?q="
    ]

    property variant maps_android : [
        "geo:$coordinates$",
    ]

    property variant maps : maps_ios

    function openMaps(address)
    {
        console.log("openMaps")
        console.log("address = " + address)
        /// TODO: Check for reachability
        // If network is available, use the address,
        // if not, use the lat/long coordinates
        for(var i = 0; i < maps.length; i++)
        {
            if(Qt.openUrlExternally(maps[i]+""+address))
                break;
        }
    }

    StateGroup {
        states: [
            State {
                when: Qt.platform.os === "ios"
                PropertyChanges {
                    target: root
                    apiRecent: "http://www.vegguide.org/site/recent.rss"
                    apiTest: apiTestEngland
                    apiRegion: {
                        "url" : "http://www.vegguide.org/",
                        "headers" : {
                            "Type" : "application/vnd.vegguide.org-regions+json"
                        }
                    }
                }
            }
        ]
    }


}
