package com.primalounas.Objects;

import android.view.View;
import android.widget.TextView;

import com.mikepenz.fastadapter.FastAdapter;
import com.mikepenz.fastadapter.items.AbstractItem;
import com.primalounas.R;

import org.jetbrains.annotations.NotNull;

import java.util.List;

import butterknife.BindView;
import butterknife.ButterKnife;

public class MenuItem extends AbstractItem<MenuItem.ViewHolder> {

    private String menuItemDay;
    private String menuItemFirst = "";
    private String menuItemSecond = "";
    private String menuItemThird = "";
    private String menuItemFourth = "";

    public MenuItem(String[] items) {
        this.menuItemDay = items[0];

        for (int i = 1; i < items.length; i++) {
            switch (i) {
                case 1:
                    this.menuItemFirst = items[1];
                    break;
                case 2:
                    this.menuItemSecond = items[2];
                    break;
                case 3:
                    this.menuItemThird= items[3];
                    break;
                case 4:
                    this.menuItemFourth= items[4];
                    break;
            }
        }
    }

    @Override
    public int getLayoutRes() {
        return R.layout.card_menuitem;
    }

    @Override
    public int getType() {
        return R.id.fa_card_menu_item;
    }

    @NotNull
    @Override
    public MenuItem.ViewHolder getViewHolder(@NotNull View view) {
        return new ViewHolder(view);
    }

    class ViewHolder extends FastAdapter.ViewHolder<MenuItem> {

        @BindView(R.id.textview_dayname) TextView menuItemDay;
        @BindView(R.id.textview_firstFood) TextView menuItemFirst;
        @BindView(R.id.textview_secondFood) TextView menuItemSecond;
        @BindView(R.id.textview_thirdFood) TextView menuItemThird;
        @BindView(R.id.textview_fourthFood) TextView menuItemFourth;

        private ViewHolder(View view) {
            super(view);
            ButterKnife.bind(this, view);
        }

        @Override
        public void bindView(@NotNull MenuItem item, @NotNull List<Object> list) {
            menuItemDay.setText(item.menuItemDay);
            menuItemFirst.setText(item.menuItemFirst);
            menuItemSecond.setText(item.menuItemSecond);
            menuItemThird.setText(item.menuItemThird);
            menuItemFourth.setText(item.menuItemFourth);

            menuItemFirst.setVisibility(item.menuItemFirst == "" ? View.GONE : View.VISIBLE);
            menuItemSecond.setVisibility(item.menuItemSecond == "" ? View.GONE : View.VISIBLE);
            menuItemThird.setVisibility(item.menuItemThird == "" ? View.GONE : View.VISIBLE);
            menuItemFourth.setVisibility(item.menuItemFourth == "" ? View.GONE : View.VISIBLE);
        }

        @Override
        public void unbindView(@NotNull MenuItem item) {
            menuItemDay.setText(null);
            menuItemFirst.setText(null);
            menuItemSecond.setText(null);
            menuItemThird.setText(null);
            menuItemFourth.setText(null);
        }
    }
}