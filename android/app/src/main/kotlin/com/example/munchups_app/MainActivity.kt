package com.example.munchups_app

import android.os.Bundle
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity : FlutterFragmentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        // CRITICAL: Set MaterialComponents theme BEFORE super.onCreate for Stripe
        // This ensures the theme is applied before any Stripe initialization
        // Use the resource directly - Flutter will generate the R class
        setTheme(R.style.NormalTheme)
        super.onCreate(savedInstanceState)
    }
}
