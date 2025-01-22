package io.fala.android.client

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.DashPathEffect
import android.graphics.LinearGradient
import android.graphics.Paint
import android.graphics.Path
import android.graphics.Shader
import android.util.SizeF
import androidx.core.graphics.ColorUtils
import kotlinx.serialization.json.Json
import kotlin.math.cbrt
import kotlin.math.pow

class CustomDataToImage(private val type: String, private val data: ByteArray, private val isDark: Boolean) {
    // 设置渐变填充
    private val gradient = LinearGradient(
        0f, 0f, 0f, widgetSize.height,
        Color.parseColor("#99DC7938"), // 起始颜色
        Color.parseColor("#00DC7938"), // 结束颜色
        Shader.TileMode.CLAMP
    )
    private val areaPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        style = Paint.Style.FILL
        shader = gradient
    }

    private val linePaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = Color.parseColor("#FFDC7938")
        strokeWidth = 5f
        style = Paint.Style.STROKE
    }

    private val dashedPaint = Paint(Paint.ANTI_ALIAS_FLAG).apply {
        color = ColorUtils.setAlphaComponent(Color.GRAY, 80)
        style = Paint.Style.STROKE
        strokeWidth = 3f
        pathEffect = DashPathEffect(floatArrayOf(20f, 10f), 0f)
    }
    private val path = Path()
    private val linePath = Path()

    private val widgetSize: SizeF
        get() {
            val width: Float
            val height: Float
            when (type) {
                "widget_large" -> {
                    width = 1000.0f
                    height = 1400.0f
                }
                "widget_middle" -> {
                    width = 1000.0f
                    height = 600.0f
                }
                else -> {
                    width = 400.0f
                    height = 600.0f
                }
            }
            return SizeF(width, height)
        }

    fun draw() : Bitmap {
        val bitmap = Bitmap.createBitmap(widgetSize.width.toInt(), widgetSize.height.toInt(), Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        try {
            val model: CustomDataModel? = Json.decodeFromString(String(data))
            if (model == null || model.data.isEmpty()) {
                throw Exception("")
            }
            model.tag?.let {
                canvas.drawText(it, 0f, 40f, Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    color = ColorUtils.setAlphaComponent(Color.GRAY, 80)
                    textSize = 30f
                    textAlign = Paint.Align.LEFT
                    isFakeBoldText = true
                })
            }
            canvas.drawText(model.title, widgetSize.width, 40f, Paint(Paint.ANTI_ALIAS_FLAG).apply {
                color = ColorUtils.setAlphaComponent(Color.GRAY, 80)
                textSize = 30f
                textAlign = Paint.Align.RIGHT
                isFakeBoldText = true
            })
            val width = when(type) {
                "widget_small" -> widgetSize.width
                else -> widgetSize.width / 2
            }
            for (index in 0 until model.data.subList(0,2).size) {
                canvas.drawText(model.data[index].title, 0f, 120f + (250f * index), Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    color = Color.parseColor("#FFDC7938")
                    textSize = 35f
                    textAlign = Paint.Align.LEFT
                    isFakeBoldText = true
                })
                model.data[index].titleSub?.let {
                    canvas.drawText(it, width, 120f + (250f * index), Paint(Paint.ANTI_ALIAS_FLAG).apply {
                        color = ColorUtils.setAlphaComponent(Color.GRAY, 80)
                        textSize = 25f
                        textAlign = Paint.Align.RIGHT
                        isFakeBoldText = true
                    })
                }
                canvas.drawText(model.data[index].value, width / 2, 220f + (250f * index), Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    color = if (isDark) Color.WHITE else Color.BLACK
                    textSize = 60f
                    textAlign = Paint.Align.CENTER
                    isFakeBoldText = true
                })
            }
            if (!model.chart.isNullOrEmpty() && type != "widget_small" && model.data.size > 2) {
                for (index in 2 until model.data.size) {
                    canvas.drawText(model.data[index].title, width, 120f + (250f * (index - 2)), Paint(Paint.ANTI_ALIAS_FLAG).apply {
                        color = Color.parseColor("#FFDC7938")
                        textSize = 35f
                        textAlign = Paint.Align.LEFT
                        isFakeBoldText = true
                    })
                    model.data[index].titleSub?.let {
                        canvas.drawText(it, widgetSize.width, 120f + (250f * (index - 2)), Paint(Paint.ANTI_ALIAS_FLAG).apply {
                            color = ColorUtils.setAlphaComponent(Color.GRAY, 80)
                            textSize = 25f
                            textAlign = Paint.Align.RIGHT
                            isFakeBoldText = true
                        })
                    }
                    canvas.drawText(model.data[index].value, widgetSize.width * 0.75f, 220f + (250f * (index - 2)), Paint(Paint.ANTI_ALIAS_FLAG).apply {
                        color = if (isDark) Color.WHITE else Color.BLACK
                        textSize = 60f
                        textAlign = Paint.Align.CENTER
                        isFakeBoldText = true
                    })
                }
            }
            if (!model.chart.isNullOrEmpty()) {
                createChart(canvas, model.chart, model.chartHint)
            }
        }catch (e: Exception) {
            canvas.drawText("数据格式错误！$e", widgetSize.width/2, widgetSize.height/4, Paint(Paint.ANTI_ALIAS_FLAG).apply {
                color = Color.RED
                textSize = 10f
                textAlign = Paint.Align.CENTER
            })
        }
        return bitmap
    }

    private fun createChart(canvas: Canvas, charts: List<CustomDataChart>, chartHint: Float?) {
        val width = if (type == "widget_middle") widgetSize.width / 2 else widgetSize.width
        val height = (if (type == "widget_large") widgetSize.height / 2 else widgetSize.height) - 100
        val startX = if (type == "widget_middle") widgetSize.width / 2 else 0f
        val hint = cbrt(chartHint ?: 0f)
        val values: List<Float> = charts.map { cbrt(it.value) }
        val maxValue = values.max()
        val minValue = values.min()

        // 绘制折线和面积图
        path.reset()
        path.moveTo(startX, widgetSize.height - 80)
        linePath.reset()
        linePath.moveTo(startX, widgetSize.height - ((values[0] - minValue) / (maxValue - minValue) * height) - 80)

        values.forEachIndexed { index, value ->
            val x = startX + ((width / (values.size - 1)) * index)
            val y = widgetSize.height - ((value - minValue) / (maxValue - minValue) * height)
            linePath.lineTo(x, y - 80)
            path.lineTo(x, y - 80)
            charts[index].title?.let {
                canvas.drawText(it, x, widgetSize.height, Paint(Paint.ANTI_ALIAS_FLAG).apply {
                    color = ColorUtils.setAlphaComponent(Color.GRAY, 80)
                    textSize = 25f
                    textAlign = Paint.Align.LEFT
                    isFakeBoldText = true
                })
            }
        }
        path.lineTo(widgetSize.width, widgetSize.height - 80)
        path.close()

        // 绘制虚线
        canvas.drawLine(startX, widgetSize.height - 80 - hint, widgetSize.width, widgetSize.height - 80 - hint, dashedPaint)

        canvas.drawPath(path, areaPaint)
        canvas.drawPath(linePath, linePaint)
    }
}