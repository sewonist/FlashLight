Under Construction
==================

The master branch of FlashLight is under construction. You can download old version below link. Thanks.

https://github.com/sewonist/FlashLight/tree/it.3


FlashLight
==========

FlashLight is ANE about using light or torch for iOS and Android.


Installation
---------


On Android:

* you need to enable the following permissions (otherwise the returned state will always be not connected):

    ```xml
    <android>
        <manifestAdditions><![CDATA[
            <manifest android:installLocation="auto">
                
                ...

                <uses-permission android:name="android.permission.CAMERA" />
				<uses-permission android:name="android.permission.FLASHLIGHT" />
                
                ...

            </manifest>
        ]]></manifestAdditions>
    </android>
    ```


Usage
---------

```as
var _flash:FlashLight = new FlashLight;
_flash.turnLightOn = true; // (true,false)
_flash.brigthness = 1; // (0-1) iOS6 only
```

by it.3

