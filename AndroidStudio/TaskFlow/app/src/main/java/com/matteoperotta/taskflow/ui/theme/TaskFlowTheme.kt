package com.matteoperotta.taskflow.ui.theme

import android.R.attr.content
import android.os.Build
import androidx.compose.foundation.isSystemInDarkTheme
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.darkColorScheme
import androidx.compose.material3.dynamicDarkColorScheme
import androidx.compose.material3.dynamicLightColorScheme
import androidx.compose.material3.lightColorScheme
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext

/** è il tema Material3 dell'app,
 * tutti i componenti Material3 leggono automaticamente
 * questi colori, non serve impostarli manualmente ad ogni componente
 * */

@Composable
fun TaskFlowTheme (content: @Composable ()-> Unit) {
    MaterialTheme(
        colorScheme = lightColorScheme(
            //bottoni, TopAppBar... primary
            primary = Color(0xFF263238L), //Verde scuro, classico top bar google
            secondary = Color(0xFF2E7D32L) //Verde molto opaco

        )
    ) {
        // qua va il content, cioe tutto l-albero dell app che riceve il tema
        content()
    }
}