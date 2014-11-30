import QtQuick 2.0

Loader {
    signal callSuccess(string fn)
    signal callFailed(string fn)
    property bool isReady : status === Loader.Ready && item
    function call(fn)
    {
        console.log("call - " + fn)
        if(status === Loader.Ready
                && item
                && typeof item[fn] !== "undefined")
        {
            item[fn]()
            callSuccess(fn)
        } else
        {
            callFailed(fn)
        }
    }
}
