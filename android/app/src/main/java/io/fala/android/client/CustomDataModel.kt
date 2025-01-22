package io.fala.android.client

import kotlinx.serialization.SerialName
import kotlinx.serialization.Serializable

@Serializable
data class CustomDataModel(
    val title: String,
    val data: List<CustomDataData>,
    val chart: List<CustomDataChart>?,
    val tag: String?,
    @SerialName("chart_hint") val chartHint: Float?
)

@Serializable
data class CustomDataData(
    val title: String,
    val value: String,
    @SerialName("title_sub") val titleSub: String?
)

@Serializable
data class CustomDataChart(val title: String?, val value: Float)