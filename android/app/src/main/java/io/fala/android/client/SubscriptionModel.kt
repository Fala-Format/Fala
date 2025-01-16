package io.fala.android.client

import android.annotation.SuppressLint
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.TextView
import androidx.recyclerview.widget.RecyclerView
import kotlinx.serialization.Serializable

@Serializable
data class SubscriptionSource(
    val dataType: String,
    val type: String,
    val url: String
)

@Serializable
data class SubscriptionData(
    val id: String,
    val title: String,
    val source: List<SubscriptionSource>
)

class SubscriptionsAdapter(private  var items: List<SubscriptionData>, private val onItemClick: (SubscriptionData) -> Unit) : RecyclerView.Adapter<SubscriptionsAdapter.ItemViewHolder>() {
    class ItemViewHolder(view: View) : RecyclerView.ViewHolder(view) {
        val textView: TextView = view.findViewById(android.R.id.text1)
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): ItemViewHolder {
        val view = LayoutInflater.from(parent.context)
            .inflate(android.R.layout.simple_list_item_1, parent, false)
        return ItemViewHolder(view)
    }

    override fun getItemCount(): Int =items.size

    override fun onBindViewHolder(holder: ItemViewHolder, position: Int) {
        holder.textView.text = items[position].title

        holder.itemView.setOnClickListener {
            onItemClick(items[position])
        }
    }

    @SuppressLint("NotifyDataSetChanged")
    fun updateList(newItems: List<SubscriptionData>) {
        items = newItems
        notifyDataSetChanged()
    }

}