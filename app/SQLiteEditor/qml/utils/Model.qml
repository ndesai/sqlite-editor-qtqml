import QtQuick 2.0
import st.app.models 1.0 as Models

Models.SQLiteDatabase {
    id: root
    source: ""

    // API data
    property int apiStatus : Loader.Null

    property variant entries

    function reload()
    {
        apiStatus = Loader.Loading

        if(Qt.platform.os === "ios")
        {
            webRequest(config.apiNearby, function(response, request, requestUrl) {
                if(response)
                {
                    apiStatus = Loader.Ready
                    entries = response.entries
                }
            })
        }
        else
        {
            webRequest(config.apiTest, function(response, request, requestUrl) {
                if(response)
                {
                    apiStatus = Loader.Ready
                    entries = response.entries
                }
            })
        }
    }

    function load(urlObject, callback)
    {
        webRequest(urlObject.url, callback)
    }

    // Temporary model retriever

    function webRequest(requestUrl, callback){
        console.log("url="+requestUrl)
        var request = new XMLHttpRequest();
        request.onreadystatechange = function() {
            var response;
            if(request.readyState === XMLHttpRequest.DONE) {
                if(request.status === 200) {
                    response = JSON.parse(request.responseText);
                } else {
                    console.log("Server: " + request.status + "- " + request.statusText);
                    apiStatus = Loader.Error
                    response = ""
                }
                callback(response, request, requestUrl)
            }
        }
        request.open("GET", requestUrl, true); // only async supported
        request.setRequestHeader("Accept", "application/json")
        request.setRequestHeader("User-Agent", [config.identifier, config.version, config.packageName, config.email].join(" "))
        request.send();
    }

//    Component.onCompleted:
}
