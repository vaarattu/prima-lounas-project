package ky.prima.lounas.android;

import android.app.PendingIntent;
import android.appwidget.AppWidgetManager;
import android.appwidget.AppWidgetProvider;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.widget.RemoteViews;

import ky.prima.lounas.android.network.GetFoodMenuService;

import org.apache.poi.hwpf.HWPFDocument;
import org.jetbrains.annotations.NotNull;

import java.io.BufferedInputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.List;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

public class FoodMenuWidgetProvider extends AppWidgetProvider {

    @Override
    public void onUpdate(Context context, AppWidgetManager appWidgetManager, int[] appWidgetIds) {
        final int count = appWidgetIds.length;

        for (int i = 0; i < count; i++) {
            int widgetId = appWidgetIds[i];

            Intent intent = new Intent(context, MainActivity.class);
            PendingIntent pendingIntent = PendingIntent.getActivity(context, 0, intent, 0);
            RemoteViews remoteViews = new RemoteViews(context.getPackageName(), R.layout.food_menu_widget);
            remoteViews.setOnClickPendingIntent(R.id.linear_layout_food_menu_widget, pendingIntent);

            Callback<ResponseBody> responseBodyCallback = new Callback<ResponseBody>() {
                @Override
                public void onResponse(@NotNull Call<ResponseBody> call, @NotNull Response<ResponseBody> response) {
                    try {
                        BufferedInputStream in = new BufferedInputStream(response.body().byteStream());
                        HWPFDocument doc = new HWPFDocument(in);
                        String[] daysMenu = fetchedMenuSuccess(doc);

                        remoteViews.setTextViewText(R.id.textview_dayname_widget, "Prima Lounas, " + daysMenu[0]);

                        for (int i = 1; i < daysMenu.length; i++) {
                            switch (i) {
                                case 1:
                                    remoteViews.setTextViewText(R.id.textview_firstFood_widget, daysMenu[1]);
                                    remoteViews.setViewVisibility(R.id.textview_firstFood_widget, View.VISIBLE);
                                    break;
                                case 2:
                                    remoteViews.setTextViewText(R.id.textview_secondFood_widget, daysMenu[2]);
                                    remoteViews.setViewVisibility(R.id.textview_secondFood_widget, View.VISIBLE);
                                    break;
                                case 3:
                                    remoteViews.setTextViewText(R.id.textview_thirdFood_widget, daysMenu[3]);
                                    remoteViews.setViewVisibility(R.id.textview_thirdFood_widget, View.VISIBLE);
                                    break;
                                case 4:
                                    remoteViews.setTextViewText(R.id.textview_fourthFood_widget, daysMenu[4]);
                                    remoteViews.setViewVisibility(R.id.textview_fourthFood_widget, View.VISIBLE);
                                    break;
                            }
                        }

                        int missedDays = 5 - daysMenu.length;

                        for (int j = 0; j < missedDays; j++) {
                            switch (j) {
                                case 3:
                                    remoteViews.setTextViewText(R.id.textview_firstFood_widget, "");
                                    break;
                                case 2:
                                    remoteViews.setTextViewText(R.id.textview_secondFood_widget, "");
                                    break;
                                case 1:
                                    remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "");
                                    break;
                                case 0:
                                    remoteViews.setTextViewText(R.id.textview_fourthFood_widget, "");
                                    break;
                            }
                        }

                        appWidgetManager.updateAppWidget(widgetId, remoteViews);

                    }
                    catch (Exception ex){
                        remoteViews.setTextViewText(R.id.textview_dayname_widget, "Prima Lounas");
                        remoteViews.setTextViewText(R.id.textview_firstFood_widget, "Tapahtui virhe");
                        if (ex.getMessage().toLowerCase().contains("unable to resolve host")){
                            remoteViews.setTextViewText(R.id.textview_secondFood_widget, "Yhdistäminen epäonnistui.");
                            remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "Oletko yhteydessä internettiin?");
                        }
                        else if (ex.getMessage().toLowerCase().contains("after 10000ms")){
                            remoteViews.setTextViewText(R.id.textview_secondFood_widget, "Yhteys aikakatkaistiin.");
                            remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "");
                        }
                        else {
                            remoteViews.setTextViewText(R.id.textview_secondFood_widget, ex.getMessage());
                            remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "");
                        }
                        remoteViews.setTextViewText(R.id.textview_fourthFood_widget, "");
                        appWidgetManager.updateAppWidget(widgetId, remoteViews);
                    }
                }

                @Override
                public void onFailure(@NotNull Call<ResponseBody> call, @NotNull Throwable ex) {
                    remoteViews.setTextViewText(R.id.textview_dayname_widget, "Prima Lounas");
                    remoteViews.setTextViewText(R.id.textview_firstFood_widget, "Tapahtui virhe");
                    if (ex.getMessage().toLowerCase().contains("unable to resolve host")){
                        remoteViews.setTextViewText(R.id.textview_secondFood_widget, "Yhdistäminen epäonnistui.");
                        remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "Oletko yhteydessä internettiin?");
                    }
                    else if (ex.getMessage().toLowerCase().contains("after 10000ms")){
                        remoteViews.setTextViewText(R.id.textview_secondFood_widget, "Yhteys aikakatkaistiin.");
                        remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "");
                    }
                    else {
                        remoteViews.setTextViewText(R.id.textview_secondFood_widget, ex.getMessage());
                        remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "");
                    }
                    remoteViews.setTextViewText(R.id.textview_fourthFood_widget, "");
                    appWidgetManager.updateAppWidget(widgetId, remoteViews);
                }
            };

            fetchMenu(responseBodyCallback);

            remoteViews.setTextViewText(R.id.textview_dayname_widget, "Prima Lounas");
            remoteViews.setTextViewText(R.id.textview_firstFood_widget, "Ladataan ruokalistaa! ");
            remoteViews.setTextViewText(R.id.textview_secondFood_widget, "...");
            remoteViews.setTextViewText(R.id.textview_thirdFood_widget, "...");
            remoteViews.setTextViewText(R.id.textview_fourthFood_widget, "Tai ainakin yritetään!");

            appWidgetManager.updateAppWidget(widgetId, remoteViews);
        }
    }


    private void fetchMenu(Callback<ResponseBody> responseBodyCallback){
        Retrofit retrofit = new Retrofit.Builder().baseUrl("https://drive.google.com/").build();
        GetFoodMenuService service = retrofit.create(GetFoodMenuService.class);
        service.getFoodMenu("https://drive.google.com/uc?id=0B8nQh-fa3RbLMFN0X1QxaDFhYzQ&export=download").enqueue(responseBodyCallback);
    }

    private String[] fetchedMenuSuccess(HWPFDocument document){
        return processDocumentText(document.getDocumentText());
    }

    private String[] processDocumentText(String text){
        text = text.trim().replaceAll("\r+", "\t").replaceAll(" +", " ").replaceAll("\t{2,}|\t+ +\t+", "\t");
        String[] splits = text.split("\t");

        for (int i = 0; i < splits.length; i++) {
            splits[i] = splits[i].trim();
        }

        List<String> splitsList = new ArrayList<>(Arrays.asList(splits));
        splitsList.removeAll(Arrays.asList("", null));

        String companyName = splitsList.get(0);
        String saladPrice = splitsList.get(1);
        String restaurantName = splitsList.get(2);
        String foodPrice = splitsList.get(3);
        String phoneNumber = splitsList.get(4);
        String soupPrice = splitsList.get(5);
        String title = splitsList.get(6);

        boolean[] days = {false, false, false, false, false};
        List<List<String>> dayMenu = new ArrayList<>();

        for (int i = 7; i < splitsList.size(); i++) {

            String curr = splitsList.get(i);

            if (curr.toLowerCase().startsWith("ma ")){
                days[0] = true;
                List<String> monday = new ArrayList<>();
                while (true){
                    String next = splitsList.get(i);
                    if (next.toLowerCase().startsWith("ti ")){
                        break;
                    }
                    monday.add(next);
                    i++;
                }
                dayMenu.add(monday);
            }
            curr = splitsList.get(i);
            if (curr.toLowerCase().startsWith("ti ") && days[0]){
                days[1] = true;
                List<String> tuesday = new ArrayList<>();
                while (true){
                    String next = splitsList.get(i);
                    if (next.toLowerCase().startsWith("ke ")){
                        break;
                    }
                    tuesday.add(next);
                    i++;
                }
                dayMenu.add(tuesday);
            }
            curr = splitsList.get(i);
            if (curr.toLowerCase().startsWith("ke ") && days[1]){
                days[2] = true;
                List<String> wednesday = new ArrayList<>();
                while (true){
                    String next = splitsList.get(i);
                    if (next.toLowerCase().startsWith("to ")){
                        break;
                    }
                    wednesday.add(next);
                    i++;
                }
                dayMenu.add(wednesday);
            }
            curr = splitsList.get(i);
            if ((curr.toLowerCase().startsWith("to ") || curr.toLowerCase().startsWith("t0")) && days[2]){
                days[3] = true;
                List<String> thursday = new ArrayList<>();
                while (true){
                    String next = splitsList.get(i);
                    if (next.toLowerCase().startsWith("pe ")){
                        break;
                    }
                    thursday.add(next);
                    i++;
                }
                dayMenu.add(thursday);
            }
            curr = splitsList.get(i);
            if (curr.toLowerCase().startsWith("pe ") && days[3]){
                days[4] = true;
                List<String> friday = new ArrayList<>();
                while (true){
                    String next = splitsList.get(i);
                    if (next.toLowerCase().startsWith("lisä")){
                        break;
                    }
                    friday.add(next);
                    i++;
                }
                dayMenu.add(friday);
            }
        }

        int day = Calendar.getInstance().get(Calendar.DAY_OF_WEEK) - 2;

        return dayMenu.get(day).toArray(new String[0]);
    }
}