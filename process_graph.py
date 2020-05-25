#!/usr/bin/env python3
import pandas as pd
import matplotlib.pyplot as plt


def main():
    # The csvs are a mess after converting from xlsx
    # first delete the first column,
    # then transpose
    # then delete the first row
    # then plot column 1 to column 3
    colours = ["DarkBlue", "DarkGreen", "DarkOrange", "Indigo", "Violet"]
    for year in ["2016", "2017", "2018", "2019", "2020"]:
        df = pd.read_csv(f"csv/{year}.csv")
        del df["Week number"]
        transposed = df.T
        transposed = pd.DataFrame.tail(transposed, -1)
        transposed[3] = transposed[3].dropna().astype(int)
        transposed = transposed.rename(columns={3: f"{year}"})
        transposed = transposed.rename(columns={0: "Week"})
        transposed = transposed.set_index("Week")
        colour = colours.pop()
        try:
            transposed.plot(y=f"{year}", ax=ax, color=colour, kind="line")
        except UnboundLocalError:
            ax = transposed.plot(y=f"{year}", color=colour, kind="line")
            ax.set_ylabel("Total Deaths")
            ax.set_xlabel("Week")
    plt.axvline(x=12, color="r", linestyle="dashdot")
    plt.text(10, 19500, "March 23rd", rotation=90)
    plt.savefig("total_deaths_2016_2020.png", dpi=400, edgecolor="black")


if __name__ == "__main__":
    main()
