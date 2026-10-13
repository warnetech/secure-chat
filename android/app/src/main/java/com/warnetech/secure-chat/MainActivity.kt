package com.warnetech.securechat

import android.app.Activity
import android.os.Bundle
import android.widget.TextView

class MainActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val view = TextView(this).apply {
            text = "secure-chat\nPhase 1 skeleton"
            textSize = 20f
            setPadding(48, 48, 48, 48)
        }
        setContentView(view)
    }
}
