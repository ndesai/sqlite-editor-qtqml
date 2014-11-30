import QtQuick 2.0
import QtQml 2.2

Item {
    id: root
    property string fontFamily : ""

    Instantiator {
        asynchronous: false
        model: [300, 500, 700, 900, 1000]
        delegate: FontLoader {
            id: _FontLoader
            source: "../assets/MuseoSansRounded-" + modelData + ".otf"
        }
        onCountChanged: {
            if(count === 5)
                root.fontFamily = "Museo Sans Rounded"
        }
    }

    property color colorBaseText : "#252528"
    property color colorBaseTextLighter : "#424249"
    property color vgColorDarkGreen : "#6c9d2a"
    property color vgColorGreen : "#8dc73f"
    property color vgColorLightGreen : "#abd03b"
    property color vgColorGray : "#606061"
    property color vgColorDarkRed : "#9b241f"
    property color vgColorLightRed : "#bf3f23"
    property color vgColorBeetPurple : "#9D4A79"

    property color lightGrey : "#f7f7f7"
    property color lightGreyDarker : "#f3f3f3"
    property color lightGreyAccent : "#d1d1d0"
    property color lightGreyAccentSecondary : "#eeeeee"

    property int headerHeight : dp(128)
    property int statusBarHeight : dp(40)

    property int listLeftRightMargins : dp(40)

    function shadeColor(c, percent) {
        var color = c.toString()
        var R = parseInt(color.substring(1,3),16);
        var G = parseInt(color.substring(3,5),16);
        var B = parseInt(color.substring(5,7),16);

        R = parseInt(R * (100 + percent) / 100);
        G = parseInt(G * (100 + percent) / 100);
        B = parseInt(B * (100 + percent) / 100);

        R = (R<255)?R:255;
        G = (G<255)?G:255;
        B = (B<255)?B:255;

        var RR = ((R.toString(16).length==1)?"0"+R.toString(16):R.toString(16));
        var GG = ((G.toString(16).length==1)?"0"+G.toString(16):G.toString(16));
        var BB = ((B.toString(16).length==1)?"0"+B.toString(16):B.toString(16));

        return "#"+RR+GG+BB;
    }

    function dp(px)
    {
        return px
    }
}
