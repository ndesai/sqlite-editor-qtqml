import QtQuick 2.0

QtObject {
    property int windowRadius : 8

    property color red : "#ef4f44"
    property color blue : "#5cacde"
    property color lightblue : "#edf2f7"
    property color asphalt : "#373f52"
    property color white : "#ffffff"
    property color lightgray : "#eeeeee"
    property color dirtywhite : "#edeef1"
    property color gray : "#8d9ca4"
    property color text : "#434b4f"
    property color black : "#111111"
    property color superlightgray : "#F5F5F5"

    property Gradient headerGradient : Gradient {
        GradientStop {
            position: 0.0
            color: "#faf9fa"
        }
        GradientStop {
            position: 1.0
            color: "#f3f2f2"
        }
    }

    property color headerAccent : "#dddddd"

    property QtObject z : QtObject {
        property int header : 10
    }

    property QtObject yosemite : QtObject {
        property color exitColor : "#fc605b"
        property color minimizeColor : "#fdbc40"
        property color expandColor : "#34c849"
    }

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
}
