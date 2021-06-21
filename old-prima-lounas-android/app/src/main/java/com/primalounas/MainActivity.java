package com.primalounas;

import androidx.appcompat.app.AppCompatActivity;
import androidx.recyclerview.widget.LinearLayoutManager;
import androidx.recyclerview.widget.RecyclerView;
import butterknife.BindView;
import butterknife.ButterKnife;
import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.Callback;
import retrofit2.Response;
import retrofit2.Retrofit;

import android.appwidget.AppWidgetManager;
import android.content.ComponentName;
import android.os.Bundle;
import android.os.CountDownTimer;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.ScrollView;
import android.widget.TextView;

import com.mikepenz.fastadapter.FastAdapter;
import com.mikepenz.fastadapter.adapters.ItemAdapter;
import com.primalounas.Networking.GetFoodMenuService;
import com.primalounas.Objects.MenuItem;

import org.apache.poi.hwpf.HWPFDocument;
import org.jetbrains.annotations.NotNull;

import java.io.BufferedInputStream;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class MainActivity extends AppCompatActivity {
    @BindView(R.id.layout_loading) LinearLayout layoutLoading;
    @BindView(R.id.layout_loaded) ScrollView layoutLoaded;
    @BindView(R.id.layout_error) LinearLayout layoutError;

    @BindView(R.id.textview_loadingtext) TextView textLoading;
    @BindView(R.id.textview_errortext) TextView textError;

    @BindView(R.id.textview_saladprice) TextView textSaladPrice;
    @BindView(R.id.textview_foodprice) TextView textFoodPrice;
    @BindView(R.id.textview_soupprice) TextView textSoupPrice;

    @BindView(R.id.recyclerview_foodcourses) RecyclerView recyclerFoodCourses;

    ItemAdapter itemAdapter;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
        ButterKnife.bind(this);

        LinearLayoutManager layoutManager = new LinearLayoutManager(this);
        recyclerFoodCourses.setLayoutManager(layoutManager);

        itemAdapter = new ItemAdapter<MenuItem>();
        FastAdapter fastAdapter = FastAdapter.with(itemAdapter);
        recyclerFoodCourses.setAdapter(fastAdapter);

        fetchMenu();

        int[] ids = AppWidgetManager.getInstance(getApplication()).getAppWidgetIds(new ComponentName(getApplication(), FoodMenuWidgetProvider.class));
        FoodMenuWidgetProvider myWidget = new FoodMenuWidgetProvider();
        myWidget.onUpdate(this, AppWidgetManager.getInstance(this),ids);
    }

    private void fetchMenu(){
        showLoading();

        textLoading.setText("Hold on I'm fetching the menu!");

        new CountDownTimer(5000, 5000) {
            public void onTick(long millisUntilFinished) { }
            public void onFinish() {
                textLoading.setText("This is taking longer than expected...");
            }
        }.start();

        new CountDownTimer(15000, 15000) {
            public void onTick(long millisUntilFinished) { }
            public void onFinish() {
                textLoading.setText("Still trying to load... The problem is probably either your internet connection or google's servers...");
            }
        }.start();

        Retrofit retrofit = new Retrofit.Builder().baseUrl("https://drive.google.com/").build();
        GetFoodMenuService service = retrofit.create(GetFoodMenuService.class);
        service.getFoodMenu("https://drive.google.com/uc?id=0B8nQh-fa3RbLMFN0X1QxaDFhYzQ&export=download").enqueue(new Callback<ResponseBody>() {
            @Override
            public void onResponse(@NotNull Call<ResponseBody> call, @NotNull Response<ResponseBody> response) {
                try {
                    BufferedInputStream in = new BufferedInputStream(response.body().byteStream());
                    HWPFDocument doc = new HWPFDocument(in);
                    fetchedMenuSuccess(doc);
                }
                catch (Exception ex){
                    fetchedMenuFailure(ex.getMessage());
                }
            }

            @Override
            public void onFailure(@NotNull Call<ResponseBody> call, @NotNull Throwable t) {
                fetchedMenuFailure(t.getMessage());
            }
        });
    }

    private void fetchedMenuSuccess(HWPFDocument document){
        processDocumentText(document.getDocumentText());
        showResults();
    }

    private void fetchedMenuFailure(String exception){
        textError.setText(exception);
        showError();
    }

    private void showLoading(){
        layoutLoading.setVisibility(View.VISIBLE);
        layoutLoaded.setVisibility(View.GONE);
        layoutError.setVisibility(View.GONE);
    }

    private void showError(){
        layoutLoading.setVisibility(View.GONE);
        layoutLoaded.setVisibility(View.GONE);
        layoutError.setVisibility(View.VISIBLE);
    }

    private void showResults(){
        layoutLoading.setVisibility(View.GONE);
        layoutLoaded.setVisibility(View.VISIBLE);
        layoutError.setVisibility(View.GONE);
    }

    private void processDocumentText(String text){
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

        textSaladPrice.setText(saladPrice);
        textFoodPrice.setText(foodPrice);
        textSoupPrice.setText(soupPrice);

        List<MenuItem> items = new ArrayList<>();

        for (int i = 0; i < dayMenu.size(); i++) {
            items.add(new MenuItem(dayMenu.get(i).toArray(new String[0])));
        }

        itemAdapter.add(items);

        this.setTitle("Prima lounas, " + title);
    }
}