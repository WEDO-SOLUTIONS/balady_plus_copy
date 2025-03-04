
package momra.balady.android


import HomeWidgetGlanceState
import HomeWidgetGlanceStateDefinition
import android.content.Context
import android.graphics.BitmapFactory
import android.net.Uri
import androidx.compose.runtime.Composable
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import androidx.glance.GlanceId
import androidx.glance.GlanceModifier
import androidx.glance.Image
import androidx.glance.action.ActionParameters
import androidx.glance.action.clickable
import androidx.glance.appwidget.GlanceAppWidget
import androidx.glance.appwidget.action.ActionCallback
import androidx.glance.appwidget.action.actionRunCallback
import androidx.glance.appwidget.provideContent
import androidx.glance.background
import androidx.glance.currentState
import androidx.glance.layout.Alignment
import androidx.glance.layout.Box
import androidx.glance.layout.Column
import androidx.glance.layout.fillMaxSize
import androidx.glance.layout.padding
import androidx.glance.text.FontWeight
import androidx.glance.text.Text
import androidx.glance.text.TextStyle
import es.antonborri.home_widget.HomeWidgetBackgroundIntent
import es.antonborri.home_widget.actionStartActivity
import momra.balady.android.MainActivity


class HomeWidgetGlanceAppWidget : GlanceAppWidget() {

  /** Needed for Updating */
  override val stateDefinition = HomeWidgetGlanceStateDefinition()

  override suspend fun provideGlance(context: Context, id: GlanceId) {
    provideContent { GlanceContent(context, currentState()) }
  }

  @Composable
  private fun GlanceContent(context: Context, currentState: HomeWidgetGlanceState) {
    val data = currentState.preferences
    val imagePath = data.getString("dashIcon", null)

    val title = data.getString("title", "")!!
    val message = data.getString("message", "")!!

       Column(
    modifier = GlanceModifier.fillMaxSize(),
    verticalAlignment = Alignment.Vertical.Top,
    horizontalAlignment = Alignment.Horizontal.Start,
) {
    // Clickable image from the drawable folder
    val bitmap = BitmapFactory.decodeResource(context.resources, R.drawable.moving_violations)
    Image(
        provider = androidx.glance.ImageProvider(bitmap),
        contentDescription = null, // Add a description for accessibility if needed
        modifier = GlanceModifier.clickable(
            onClick = actionStartActivity<MainActivity>(
                context,
                Uri.parse("#homeWidget://message?message=1&homeWidget")
            )
        )
    )
}
        
  }
}

class InteractiveAction : ActionCallback {
  override suspend fun onAction(
      context: Context,
      glanceId: GlanceId,
      parameters: ActionParameters
  ) {
    val backgroundIntent =
        HomeWidgetBackgroundIntent.getBroadcast(
            context, Uri.parse("#homeWidget://message?message=1&homeWidget"))
    backgroundIntent.send()
  }
}