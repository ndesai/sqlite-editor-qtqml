import QtQuick 2.0
import st.app.platform 1.0
PlatformiOS {
    //    signal  applicationDidBecomeActive();
    //    signal  applicationWillResignActive();
    //    signal  applicationDidEnterBackground();
    //    signal  applicationWillEnterForeground();
    //    signal  applicationDidFinishLaunching();
    //    signal  applicationDidReceiveMemoryWarning();
    //    signal  applicationWillTerminate();
    statusBarStyle: PlatformiOS.StatusBarStyleLightContent
    function setStatusBarStyleLight()
    {
        statusBarStyle = PlatformiOS.StatusBarStyleLightContent
    }
    function setStatusBarStyleDefault()
    {
        statusBarStyle = PlatformiOS.StatusBarStyleDefault
    }
    function hideStatusBar()
    {
        setStatusBarVisible(false)
    }
    function showStatusBar()
    {
        setStatusBarVisible(true)
    }
}
