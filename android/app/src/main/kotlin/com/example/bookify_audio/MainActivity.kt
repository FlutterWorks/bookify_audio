package com.bookify.audio

import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import com.startapp.sdk.adsbase.StartAppSDK
import com.startapp.sdk.adsbase.StartAppAd

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        
        // Initialize Start.io SDK
        StartAppSDK.init(this, "208101839", false)  // Replace with your actual Start.io App ID
        StartAppAd.disableSplash()  // Optional if using splash ads
        
        // Disable test ads
        StartAppSDK.setTestAdsEnabled(false)
    }
}
