import QtQuick 2.0

MouseArea {
    id: root
    property int acceptableSwipeDistance : 25;

    signal swipeLeft;
    signal swipeRight;
    signal swipeUp;
    signal swipeDown;
    signal tap;

    signal press;
    signal release;


    // private
    property int pressPosX;
    property int pressPosY;
    property int releasePosX;
    property int releasePosY;

    onPressed: {
        root.press();
        pressPosX = mouse.x;
        pressPosY = mouse.y;
    }
    onReleased: {
        root.release();
        releasePosX = mouse.x
        releasePosY = mouse.y
        var deltaX = releasePosX - pressPosX;
        var deltaY = releasePosY - pressPosY;
        if(deltaX < -1*acceptableSwipeDistance)
        {
            root.swipeLeft();
        }
        else if(deltaX > acceptableSwipeDistance)
        {
            root.swipeRight();
        } else if(deltaY < -1*acceptableSwipeDistance)
        {
            root.swipeUp();
        } else if(deltaY > acceptableSwipeDistance)
        {
            root.swipeDown();
        }
        else
        {
            root.tap();
        }
    }
}
