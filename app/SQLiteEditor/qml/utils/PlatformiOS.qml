import QtQuick 
import st.app.platform 
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
