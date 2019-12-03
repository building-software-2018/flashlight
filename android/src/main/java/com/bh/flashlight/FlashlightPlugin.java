package com.bh.flashlight;

import android.content.Context;
import android.content.pm.PackageManager;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraManager;
import android.os.Build;

import io.flutter.plugin.common.MethodCall;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.MethodChannel.MethodCallHandler;
import io.flutter.plugin.common.MethodChannel.Result;
import io.flutter.plugin.common.PluginRegistry.Registrar;

/** FlashlightPlugin */
public class FlashlightPlugin implements MethodCallHandler {
    private Registrar _registrar;
    private static CameraManager _cameraManager;

    private FlashlightPlugin(Registrar registrar) {
        this._registrar = registrar;
        _cameraManager = (CameraManager)  this._registrar.activity().getSystemService(Context.CAMERA_SERVICE);
    }

    /** Plugin registration. */
    public static void registerWith(Registrar registrar) {
        final MethodChannel channel = new MethodChannel(registrar.messenger(), "com.bh.flutterplugins/flashlight");
        channel.setMethodCallHandler(new FlashlightPlugin(registrar));
    }

    @Override
    public void onMethodCall(MethodCall call, Result result) {
        switch(call.method) {
            case "turnOn":
                this.turn(true);
                result.success(null);
                break;
            case "turnOff":
                this.turn(false);
                result.success(null);
                break;
            case "hasTorch":
                result.success(this.hasTorch());
                break;
            default:
                result.notImplemented();
        }
    }

    public void turn(Boolean on){
        try {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
                for (String id : _cameraManager.getCameraIdList()) {
                    // Turn on the flash if camera has one
                    if (_cameraManager.getCameraCharacteristics(id).get(CameraCharacteristics.FLASH_INFO_AVAILABLE)) {
                        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                            _cameraManager.setTorchMode(id, on);
                        }
                    }
                }
            }
        } catch (Exception e2) {
            System.out.println("Torch Failed : " + e2.getMessage());
        }
    }

    private boolean hasTorch() {
        return _registrar.context().getApplicationContext().getPackageManager().hasSystemFeature(PackageManager.FEATURE_CAMERA_FLASH);
    }
}
