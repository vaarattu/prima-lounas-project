package com.divit.springboot.application.util;

import java.io.BufferedInputStream;
import java.io.DataOutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import com.divit.springboot.application.model.RestaurantCourse;
import com.divit.springboot.application.model.RestaurantDay;
import org.apache.poi.hwpf.HWPFDocument;

public final class RestaurantUtil {

    public static List<RestaurantDay> getWeekMenu(){
        List<RestaurantDay> items = new ArrayList<>();

        try {
            String stringUrl = "https://drive.google.com/uc?id=0B8nQh-fa3RbLMFN0X1QxaDFhYzQ&export=download";
            URL url = new URL(stringUrl);
            HttpURLConnection con = (HttpURLConnection) url.openConnection();
            con.setRequestMethod("GET");
            con.setConnectTimeout(5000);
            con.setReadTimeout(5000);
            BufferedInputStream in = new BufferedInputStream(con.getInputStream());
            HWPFDocument document = new HWPFDocument(in);
            String text = document.getDocumentText();

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

            for (int i = 0; i < dayMenu.size(); i++) {
                String[] array = dayMenu.get(i).toArray(new String[0]);
                List<RestaurantCourse> courses = new ArrayList<>();
                String day = array[0];

                for (int j = 1; j < array.length; j++) {
                    courses.add(new RestaurantCourse(array[j], "", List.of()));
                }
                items.add(new RestaurantDay(day, courses));
            }
con.disconnect();
        } catch (Exception e){

        }
        return items;
    }

    public static List<RestaurantDay> getWeekMenuMock() {
        List<RestaurantDay> items = new ArrayList<>();

        List<RestaurantCourse> courses = List.of(
                new RestaurantCourse("Salaattipöytä", "4,70 €", new ArrayList<>()),
                new RestaurantCourse("Uunimakkaraa, perunamuusia", "7,00 €", List.of("L", "G")),
                new RestaurantCourse("Juustoista kukkakaalikeittoa", "6,00 €", List.of("L", "G")));
        items.add(new RestaurantDay("Ma 21.6", courses));

        courses = List.of(
                new RestaurantCourse("Salaattipöytä", "4,70€", new ArrayList<>()),
                new RestaurantCourse("Parmesan broilerpihviä, riisiä", "7,00 €", List.of("L", "G")),
                new RestaurantCourse("Jauhelihakeittoa", "6,00 €", List.of("L", "G"))
        );
        items.add(new RestaurantDay("Ti 22.6", courses));

        courses = List.of(
                new RestaurantCourse("Antipastopöytä", "4,70€", new ArrayList<>()),
                new RestaurantCourse("Janssoninkiusausta", "7,00 €", List.of("L", "G")),
                new RestaurantCourse("Herkkusienikeittoa", "6,00 €", List.of("L", "G"))
        );
        items.add(new RestaurantDay("Ke 23.6", courses));

        courses = List.of(
                new RestaurantCourse("Salaattipöytä", "4,70€", new ArrayList<>()),
                new RestaurantCourse("Uunipossua, paistinkastiketta", "7,00 €", new ArrayList<>()),
                new RestaurantCourse("Hernekeittoa", "6,00 €", new ArrayList<>())
        );
        items.add(new RestaurantDay("To 24.6", courses));

        courses = List.of(new RestaurantCourse("Hyvää Juhannusta !", "", new ArrayList<>()));
        items.add(new RestaurantDay("Pe 25.6", courses));

        return items;
    }

    public static List<RestaurantDay> getDayMenu() {
        return new ArrayList<>();
    }

    public static List<RestaurantDay> getDayMenuMock() {
        List<RestaurantDay> items = new ArrayList<>();

        List<RestaurantCourse> courses = List.of(
                new RestaurantCourse("Salaattipöytä", "4,70 €", new ArrayList<>()),
                new RestaurantCourse("Uunimakkaraa, perunamuusia", "7,00 €", List.of("L", "G")),
                new RestaurantCourse("Juustoista kukkakaalikeittoa", "6,00 €", List.of("L", "G")));
        items.add(new RestaurantDay("Ma 21.6", courses));

        return items;
    }
}
