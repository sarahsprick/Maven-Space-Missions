# Maven-Space-Missions

This project explores the Space Missions dataset from Maven Analytic’s [Data Playground](https://www.mavenanalytics.io/data-playground). This specific dataset was used in the company’s  [Maven Space Challenge](https://www.mavenanalytics.io/blog/maven-space-challenge) (September 2022). I did not participate in this challenge, but did utilize their analysis questions and created a visualization as though I was participating. I thought this dataset looked interesting and wanted to explore it!

The dataset consists of 4,630 rows of records each representing a space mission from 1957 to August of 2022 and containing information about the name, location, company, rocket, etc. I used simple SQL queries (space_missions_queries.sql)  to explore the data and create additional columns that would be used later on while visualizing. I chose to keep all columns (even though not all were utilized) because the dataset only contained 9 columns to begin with. Moving into Tableau, I created an interactive dashboard where the user can adjust the year, country, and company fields to update the different graphs and charts.

The space_missions.csv file contains the data as provided by Maven Analytics. While the space_missions_for_viz.xlsx file is the same data after cleaning and transforming in preparation for visualizing. Notable differences are:
- Used the `MissionStatus` column to create dummy columns containing binary variables for each status
- Parsed `Location` into individual columns for the country, state, base, and site
- New price column which converts previous string format (ex. "1,160" to represent 1,160,000,000) to numeric

**Some questions I used for my analysis included:**
- How has the number of successful and failed missions changed over time? 
- Which rockets have been used most in missions and what is this rockets success rate (hover field)? 
- Which countries have completed the most space missions?

<div>
<img src="rocket_icon.png" width="100"/>
</div>

[Tableau Viz Link](https://public.tableau.com/views/SpaceMissions_16689698297630/Dashboard12?:language=en-US&:display_count=n&:origin=viz_share_link)

<div>
<img src="space_missions_dashboard.gif" width="800"/>
</div>
