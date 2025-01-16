package io.fala.android.client

import android.app.Activity
import android.appwidget.AppWidgetManager
import android.content.Context
import android.content.Intent
import android.os.Bundle
import android.widget.SearchView
import androidx.preference.PreferenceManager
import androidx.recyclerview.widget.LinearLayoutManager
import androidx.recyclerview.widget.RecyclerView
import io.fala.android.client.databinding.SubscriptionWidgetConfigureBinding
import io.flutter.plugins.sharedpreferences.DOUBLE_PREFIX
import io.flutter.plugins.sharedpreferences.LIST_PREFIX
import io.flutter.plugins.sharedpreferences.ListEncoder
import io.flutter.plugins.sharedpreferences.SharedPreferencesListEncoder
import kotlinx.serialization.encodeToString
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.boolean
import kotlinx.serialization.json.jsonArray
import kotlinx.serialization.json.jsonObject
import kotlinx.serialization.json.jsonPrimitive

/**
 * The configuration screen for the [SubscriptionWidget] AppWidget.
 */
class SubscriptionWidgetConfigureActivity : Activity() {
    private var appWidgetId = AppWidgetManager.INVALID_APPWIDGET_ID
    private var subscriptionsList: List<SubscriptionData> = listOf()
    private lateinit var adapter: SubscriptionsAdapter
    private lateinit var recyclerView: RecyclerView
    private lateinit var searchView: SearchView

    private lateinit var binding: SubscriptionWidgetConfigureBinding

    public override fun onCreate(icicle: Bundle?) {
        super.onCreate(icicle)

        val subscriptionsStr = getStringList(applicationContext, "subscriptions") ?: listOf()
        subscriptionsStr.forEach {
            val jsonObj = Json.parseToJsonElement(it).jsonObject
            if (jsonObj.contains("subscriptions")) {
                val subscriptions = jsonObj["subscriptions"]!!.jsonArray
                subscriptions.forEach { subscription ->
                    if (subscription.jsonObject["visible"]?.jsonPrimitive?.boolean == true){
                        val sources: List<SubscriptionSource> = subscription.jsonObject["sources"]?.jsonArray?.map { source ->
                            val dataType: String = source.jsonObject["data_type"]?.jsonPrimitive?.content ?: ""
                            val type: String = source.jsonObject["type"]?.jsonPrimitive?.content ?: ""
                            val url: String = source.jsonObject["url"]?.jsonPrimitive?.content ?: ""
                            val subscriptionSource = SubscriptionSource(dataType, type, url)
                            return@map subscriptionSource
                        }?.toList() ?: listOf()
                        if (sources.isNotEmpty() && sources.any { s -> s.type.contains("widget_") }) {
                            val index: String = subscription.jsonObject["index"]?.jsonPrimitive?.content ?: ""
                            val title: String = subscription.jsonObject["title"]?.jsonPrimitive?.content ?: ""
                            subscriptionsList = subscriptionsList.plus(SubscriptionData(index, title, sources.filter { source -> source.type.contains("widget_") }))
                        }
                    }
                }
            }
        }

        setResult(RESULT_CANCELED)

        binding = SubscriptionWidgetConfigureBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // Initialize views
        recyclerView = binding.subscriptionsView
        searchView = binding.searchView

        // Set up RecyclerView
        adapter = SubscriptionsAdapter(subscriptionsList) {
            val context = this@SubscriptionWidgetConfigureActivity

            setString(context, "widget_subscription_$appWidgetId", Json.encodeToString(it))

            // It is the responsibility of the configuration activity to update the app widget
            val appWidgetManager = AppWidgetManager.getInstance(context)
            updateAppWidget(context, appWidgetManager, appWidgetId)

            // Make sure we pass back the original appWidgetId
            val resultValue = Intent()
            resultValue.putExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, appWidgetId)
            setResult(RESULT_OK, resultValue)
            finish()
        }
        recyclerView.layoutManager = LinearLayoutManager(this)
        recyclerView.adapter = adapter

        searchView.setOnQueryTextListener(object : SearchView.OnQueryTextListener {
            override fun onQueryTextSubmit(query: String?): Boolean = false

            override fun onQueryTextChange(newText: String?): Boolean {
                val filteredList = if (!newText.isNullOrEmpty()) {
                    subscriptionsList.filter { it.title.contains(newText, ignoreCase = true) }
                } else {
                    subscriptionsList
                }
                adapter.updateList(filteredList)
                return true
            }
        })

        // Find the widget id from the intent.
        val intent = intent
        val extras = intent.extras
        if (extras != null) {
            appWidgetId = extras.getInt(
                AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID
            )
        }

        // If this activity was started with an intent without an app widget ID, finish with an error.
        if (appWidgetId == AppWidgetManager.INVALID_APPWIDGET_ID) {
            finish()
            return
        }
    }

}

private var listEncoder = ListEncoder()

/** Gets String at [key] from data store. */
internal fun getString(context: Context, key: String): String? {
    return PreferenceManager.getDefaultSharedPreferences(context).getString(key, "")
}

/** Gets StringList at [key] from data store. */
internal fun getStringList(context: Context, key: String): List<String>? {
    val value: List<*>? = transformPref(getString(context, key) as Any?, listEncoder) as List<*>?
    return value?.filterIsInstance<String>()
}

/** Transforms preferences that are stored as Strings back to original type. */
internal fun transformPref(value: Any?, listEncoder: SharedPreferencesListEncoder): Any? {
    if (value is String) {
        if (value.startsWith(LIST_PREFIX)) {
            return listEncoder.decode(value.substring(LIST_PREFIX.length))
        } else if (value.startsWith(DOUBLE_PREFIX)) {
            return value.substring(DOUBLE_PREFIX.length).toDouble()
        }
    }
    return value
}

/** Adds property to data store of type String. */
internal fun setString(context: Context, key: String, value: String) {
    PreferenceManager.getDefaultSharedPreferences(context).edit().putString(key, value).apply()
}

internal fun removeString(context: Context, key: String) {
    PreferenceManager.getDefaultSharedPreferences(context).edit().remove(key).apply()
}