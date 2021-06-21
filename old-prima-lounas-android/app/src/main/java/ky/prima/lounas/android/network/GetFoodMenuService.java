package ky.prima.lounas.android.network;

import okhttp3.ResponseBody;
import retrofit2.Call;
import retrofit2.http.GET;
import retrofit2.http.Url;

public interface GetFoodMenuService {
    @GET
    Call<ResponseBody> getFoodMenu(@Url String fileUrl);
}
