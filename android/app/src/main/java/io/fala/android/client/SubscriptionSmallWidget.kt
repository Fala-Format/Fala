package io.fala.android.client

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.content.res.Configuration
import android.graphics.BitmapFactory
import android.widget.RemoteViews
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import java.net.HttpURLConnection
import java.net.URL

/**
 * Implementation of App Widget functionality.
 * App Widget Configuration implemented in [SubscriptionWidgetConfigureActivity]
 */
class SubscriptionSmallWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            updateAppWidget(context, appWidgetManager, appWidgetId)
        }
    }

    override fun onDeleted(context: Context, appWidgetIds: IntArray) {
        for (appWidgetId in appWidgetIds) {
            removeString(context, "widget_subscription_$appWidgetId")
        }
    }
}

internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetText = getString(context, "widget_subscription_$appWidgetId")
    if (!widgetText.isNullOrEmpty()) {
        val subscription: SubscriptionData? = Json.decodeFromString(widgetText)
        if (subscription != null && subscription.source.isNotEmpty()) {
            var source = subscription.source.first()
            val appWidgetInfo = appWidgetManager.getAppWidgetInfo(appWidgetId)
            val type = when (appWidgetInfo.provider.shortClassName) {
                ".SubscriptionLargeWidget" -> {
                    "widget_large"
                }

                ".SubscriptionMiddleWidget" -> {
                    "widget_middle"
                }

                else -> {
                    "widget_small"
                }
            }
            if (subscription.source.any { it.type == type }) {
                source = subscription.source.first { it.type == type }
            }

            CoroutineScope(Dispatchers.IO).launch {
                val bytes = getNetWorkData(source.url)
                if (bytes != null) {
                    withContext(Dispatchers.Main) {
                        val views = RemoteViews(context.packageName, R.layout.subscription_widget)
                        views.setTextViewText(R.id.appwidget_text, "")
                        views.setImageViewBitmap(
                            R.id.appwidget_image,
                            BitmapFactory.decodeByteArray(bytes, 0, 0)
                        )
                        when (source.dataType) {
                            "text" -> {
                                views.setTextViewText(R.id.appwidget_text, String(bytes))
                            }
                            "image" -> {
                                views.setImageViewBitmap(
                                    R.id.appwidget_image,
                                    BitmapFactory.decodeByteArray(bytes, 0, bytes.size)
                                )
                            }
                            "custom" -> {
                                views.setImageViewBitmap(R.id.appwidget_image, CustomDataToImage(type, bytes, isDarkTheme(context)).draw())
                            }
                        }
                        appWidgetManager.updateAppWidget(appWidgetId, views)
                    }
                }
            }
        }
    }
}

internal fun isDarkTheme(context: Context): Boolean {
    val currentNightMode = context.resources.configuration.uiMode and Configuration.UI_MODE_NIGHT_MASK
    return currentNightMode == Configuration.UI_MODE_NIGHT_YES
}

internal suspend fun getNetWorkData(url: String): ByteArray? {
    return withContext(Dispatchers.IO) {
        try {
            val urlObject = URL(url)
            val connection = urlObject.openConnection() as HttpURLConnection
            connection.requestMethod = "GET"
            connection.connect()

            val inputStream = connection.inputStream
            inputStream.readBytes()
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }
}