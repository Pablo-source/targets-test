A&E Attendances
================
PLR
2024-04-22

## 1. Load required data

We start by loading required A&E Attendances Type I, Type II and Type
III data from NHS England website. Link to the data:. Downloaded file
“Monthly A&E Time Series March 2024
(XLS,403K)”<https://www.england.nhs.uk/statistics/wp-content/uploads/sites/2/2024/04/Monthly-AE-Time-Series-March-2024.xls>

And this time for this Markdown report we have processed first using
Targets. The first Target object we have created in this pipeline is
called `clean_ATT_data` after cleansing and importing the original .xsl
file we had in our imput folder.

Use **echo=TRUE** to display both the *code* and *output* of the R code
chunk, as in the example below:

``` r
# Read csv file
tar_read(clean_ATT_data)
```

    ## # A tibble: 164 × 4
    ##    date       AE_att_TypeI AE_att_TypeII AE_att_TypeIII
    ##    <date>            <int>         <int>          <int>
    ##  1 2010-08-01      1138652         54371         559358
    ##  2 2010-09-01      1150728         55181         550359
    ##  3 2010-10-01      1163143         54961         583244
    ##  4 2010-11-01      1111294         53727         486005
    ##  5 2010-12-01      1159203         45536         533000
    ##  6 2011-01-01      1133880         51584         542331
    ##  7 2011-02-01      1053707         51249         494407
    ##  8 2011-03-01      1225221         57900         580318
    ##  9 2011-04-01      1197212         54042         593119
    ## 10 2011-05-01      1221687         57066         594940
    ## # ℹ 154 more rows

To populate the inline text, we can load this Target object
**clean_ATT_data** into our R Environment using `tar_load()` function,
`tar_load(clean_ATT_data)`

``` r
tar_load(clean_ATT_data)
# Assign data frame from Targets to new object called AE_data
AE_data <- clean_ATT_data
AE_data
```

    ## # A tibble: 164 × 4
    ##    date       AE_att_TypeI AE_att_TypeII AE_att_TypeIII
    ##    <date>            <int>         <int>          <int>
    ##  1 2010-08-01      1138652         54371         559358
    ##  2 2010-09-01      1150728         55181         550359
    ##  3 2010-10-01      1163143         54961         583244
    ##  4 2010-11-01      1111294         53727         486005
    ##  5 2010-12-01      1159203         45536         533000
    ##  6 2011-01-01      1133880         51584         542331
    ##  7 2011-02-01      1053707         51249         494407
    ##  8 2011-03-01      1225221         57900         580318
    ##  9 2011-04-01      1197212         54042         593119
    ## 10 2011-05-01      1221687         57066         594940
    ## # ℹ 154 more rows

Meaning we can start populating any `inline` text from this markdown
document directly from the Targets pipeline output. These are the
variables from the above Target object, `names(AE_data)`: \[1\] “date”
“AE_att_TypeI” “AE_att_TypeII” “AE_att_TypeIII”

## 2. Reference period

Today’s date is:**22 April**. This report was published on the week
starting on **20 April 2024**. It covers A&E Attendances data from **01
August 2010** as first month in the existing input file to **01 March
2024** as the latest available data point.

## 3. Summary Type I, TypeII and TypeIII Attendances

This is a summary of Type I, Type II and Type III attendances figures
for the **01 August 2010** to **01 March 2024** period:

- For the **01 April 2020** to **01 March 2024** period, the *lowest*
  value of AE Type I attendances was **689,720**. The *highest* value
  was **1,462,477** and the average value for Type I Attendances was
  **1,462,477**

- The *lowest* value of AE Type II attendances was \*\*\*\*. The
  *highest* value was \*\*\*\* and the **average** value for Type II
  Attendances was \*\*\*\*

Formatted number \*\*\*\*

## 4. Year 2023/24 Type I, TypeII, Type III table details

The table below displays the latest attendances figures by month.

``` r
names(AE_data)
```

    ## [1] "date"           "AE_att_TypeI"   "AE_att_TypeII"  "AE_att_TypeIII"

``` r
AE_data_2013_gt <- AE_data %>% select(Date = date, 
                                 TypeI = AE_att_TypeI, 
                                 Type2 = AE_att_TypeII,
                                 Type3 = AE_att_TypeIII) %>% 
                          filter(Date >= '2023-01-01')
# Build a gt table from the previous AE data 
# Formatting numbers with thousands separator, adding title and subtitle
library(gt)
AE_table <-gt(AE_data_2013_gt) 

# Att title to table
AE_table_thousands <- AE_table %>% 
  tab_header(
    title = md("**A&E Attendances in England. 2023 period**") ,
    subtitle = md("By type(*Type I*,*Type II*,*Type III*)")
  ) %>% 
  tab_source_note(
    source_note = "Source: NHE England A&E Attendances and Emergency Admissions data"
  ) %>% 
  tab_source_note(
    source_note = md("*England Time Series monthly data*")
  ) %>% 
  fmt_number( columns = c(TypeI, Type2, Type3), sep_mark = ",", decimals = 0)

AE_table_thousands
```

<div id="wubrehkzwl" style="padding-left:0px;padding-right:0px;padding-top:10px;padding-bottom:10px;overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>#wubrehkzwl table {
  font-family: system-ui, 'Segoe UI', Roboto, Helvetica, Arial, sans-serif, 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol', 'Noto Color Emoji';
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
}
&#10;#wubrehkzwl thead, #wubrehkzwl tbody, #wubrehkzwl tfoot, #wubrehkzwl tr, #wubrehkzwl td, #wubrehkzwl th {
  border-style: none;
}
&#10;#wubrehkzwl p {
  margin: 0;
  padding: 0;
}
&#10;#wubrehkzwl .gt_table {
  display: table;
  border-collapse: collapse;
  line-height: normal;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_caption {
  padding-top: 4px;
  padding-bottom: 4px;
}
&#10;#wubrehkzwl .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}
&#10;#wubrehkzwl .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 3px;
  padding-bottom: 5px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}
&#10;#wubrehkzwl .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}
&#10;#wubrehkzwl .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}
&#10;#wubrehkzwl .gt_column_spanner_outer:first-child {
  padding-left: 0;
}
&#10;#wubrehkzwl .gt_column_spanner_outer:last-child {
  padding-right: 0;
}
&#10;#wubrehkzwl .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}
&#10;#wubrehkzwl .gt_spanner_row {
  border-bottom-style: hidden;
}
&#10;#wubrehkzwl .gt_group_heading {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  text-align: left;
}
&#10;#wubrehkzwl .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}
&#10;#wubrehkzwl .gt_from_md > :first-child {
  margin-top: 0;
}
&#10;#wubrehkzwl .gt_from_md > :last-child {
  margin-bottom: 0;
}
&#10;#wubrehkzwl .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}
&#10;#wubrehkzwl .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wubrehkzwl .gt_stub_row_group {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 5px;
  padding-right: 5px;
  vertical-align: top;
}
&#10;#wubrehkzwl .gt_row_group_first td {
  border-top-width: 2px;
}
&#10;#wubrehkzwl .gt_row_group_first th {
  border-top-width: 2px;
}
&#10;#wubrehkzwl .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wubrehkzwl .gt_first_summary_row {
  border-top-style: solid;
  border-top-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_first_summary_row.thick {
  border-top-width: 2px;
}
&#10;#wubrehkzwl .gt_last_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wubrehkzwl .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_last_grand_summary_row_top {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-bottom-style: double;
  border-bottom-width: 6px;
  border-bottom-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}
&#10;#wubrehkzwl .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wubrehkzwl .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}
&#10;#wubrehkzwl .gt_sourcenote {
  font-size: 90%;
  padding-top: 4px;
  padding-bottom: 4px;
  padding-left: 5px;
  padding-right: 5px;
}
&#10;#wubrehkzwl .gt_left {
  text-align: left;
}
&#10;#wubrehkzwl .gt_center {
  text-align: center;
}
&#10;#wubrehkzwl .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}
&#10;#wubrehkzwl .gt_font_normal {
  font-weight: normal;
}
&#10;#wubrehkzwl .gt_font_bold {
  font-weight: bold;
}
&#10;#wubrehkzwl .gt_font_italic {
  font-style: italic;
}
&#10;#wubrehkzwl .gt_super {
  font-size: 65%;
}
&#10;#wubrehkzwl .gt_footnote_marks {
  font-size: 75%;
  vertical-align: 0.4em;
  position: initial;
}
&#10;#wubrehkzwl .gt_asterisk {
  font-size: 100%;
  vertical-align: 0;
}
&#10;#wubrehkzwl .gt_indent_1 {
  text-indent: 5px;
}
&#10;#wubrehkzwl .gt_indent_2 {
  text-indent: 10px;
}
&#10;#wubrehkzwl .gt_indent_3 {
  text-indent: 15px;
}
&#10;#wubrehkzwl .gt_indent_4 {
  text-indent: 20px;
}
&#10;#wubrehkzwl .gt_indent_5 {
  text-indent: 25px;
}
</style>
<table class="gt_table" data-quarto-disable-processing="false" data-quarto-bootstrap="false">
  <thead>
    <tr class="gt_heading">
      <td colspan="4" class="gt_heading gt_title gt_font_normal" style><strong>A&amp;E Attendances in England. 2023 period</strong></td>
    </tr>
    <tr class="gt_heading">
      <td colspan="4" class="gt_heading gt_subtitle gt_font_normal gt_bottom_border" style>By type(<em>Type I</em>,<em>Type II</em>,<em>Type III</em>)</td>
    </tr>
    <tr class="gt_col_headings">
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Date">Date</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="TypeI">TypeI</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Type2">Type2</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1" scope="col" id="Type3">Type3</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td headers="Date" class="gt_row gt_right">2023-01-01</td>
<td headers="TypeI" class="gt_row gt_right">1,243,898</td>
<td headers="Type2" class="gt_row gt_right">42,076</td>
<td headers="Type3" class="gt_row gt_right">682,364</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-02-01</td>
<td headers="TypeI" class="gt_row gt_right">1,206,386</td>
<td headers="Type2" class="gt_row gt_right">41,717</td>
<td headers="Type3" class="gt_row gt_right">666,176</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-03-01</td>
<td headers="TypeI" class="gt_row gt_right">1,372,403</td>
<td headers="Type2" class="gt_row gt_right">46,803</td>
<td headers="Type3" class="gt_row gt_right">746,745</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-04-01</td>
<td headers="TypeI" class="gt_row gt_right">1,271,145</td>
<td headers="Type2" class="gt_row gt_right">42,632</td>
<td headers="Type3" class="gt_row gt_right">716,211</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-05-01</td>
<td headers="TypeI" class="gt_row gt_right">1,400,815</td>
<td headers="Type2" class="gt_row gt_right">45,826</td>
<td headers="Type3" class="gt_row gt_right">794,708</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-06-01</td>
<td headers="TypeI" class="gt_row gt_right">1,389,009</td>
<td headers="Type2" class="gt_row gt_right">46,196</td>
<td headers="Type3" class="gt_row gt_right">785,749</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-07-01</td>
<td headers="TypeI" class="gt_row gt_right">1,379,854</td>
<td headers="Type2" class="gt_row gt_right">45,513</td>
<td headers="Type3" class="gt_row gt_right">769,533</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-08-01</td>
<td headers="TypeI" class="gt_row gt_right">1,323,647</td>
<td headers="Type2" class="gt_row gt_right">43,923</td>
<td headers="Type3" class="gt_row gt_right">738,580</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-09-01</td>
<td headers="TypeI" class="gt_row gt_right">1,369,045</td>
<td headers="Type2" class="gt_row gt_right">42,631</td>
<td headers="Type3" class="gt_row gt_right">754,065</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-10-01</td>
<td headers="TypeI" class="gt_row gt_right">1,413,560</td>
<td headers="Type2" class="gt_row gt_right">44,769</td>
<td headers="Type3" class="gt_row gt_right">761,289</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-11-01</td>
<td headers="TypeI" class="gt_row gt_right">1,385,701</td>
<td headers="Type2" class="gt_row gt_right">42,365</td>
<td headers="Type3" class="gt_row gt_right">734,056</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2023-12-01</td>
<td headers="TypeI" class="gt_row gt_right">1,383,876</td>
<td headers="Type2" class="gt_row gt_right">39,282</td>
<td headers="Type3" class="gt_row gt_right">756,074</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2024-01-01</td>
<td headers="TypeI" class="gt_row gt_right">1,397,645</td>
<td headers="Type2" class="gt_row gt_right">42,835</td>
<td headers="Type3" class="gt_row gt_right">784,555</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2024-02-01</td>
<td headers="TypeI" class="gt_row gt_right">1,347,297</td>
<td headers="Type2" class="gt_row gt_right">43,868</td>
<td headers="Type3" class="gt_row gt_right">761,196</td></tr>
    <tr><td headers="Date" class="gt_row gt_right">2024-03-01</td>
<td headers="TypeI" class="gt_row gt_right">1,462,477</td>
<td headers="Type2" class="gt_row gt_right">48,922</td>
<td headers="Type3" class="gt_row gt_right">840,714</td></tr>
  </tbody>
  <tfoot class="gt_sourcenotes">
    <tr>
      <td class="gt_sourcenote" colspan="4">Source: NHE England A&amp;E Attendances and Emergency Admissions data</td>
    </tr>
    <tr>
      <td class="gt_sourcenote" colspan="4"><em>England Time Series monthly data</em></td>
    </tr>
  </tfoot>
  &#10;</table>
</div>

## 5.Area chart displaying Type I, TypeII, Type III Attendances by Type

This final section describe A&E Attendances by type as an area chart, to
visualize the contribution of each A&E Attendances type to the overal
total number of Attendances

I will mimic the chart displaying different categories by colours
displayed in this website:
<https://epirhandbook.com/en/reports-with-r-markdown.html>

``` r
# First I need to re-shape this data set from wide to long format 
head(AE_data)
```

    ## # A tibble: 6 × 4
    ##   date       AE_att_TypeI AE_att_TypeII AE_att_TypeIII
    ##   <date>            <int>         <int>          <int>
    ## 1 2010-08-01      1138652         54371         559358
    ## 2 2010-09-01      1150728         55181         550359
    ## 3 2010-10-01      1163143         54961         583244
    ## 4 2010-11-01      1111294         53727         486005
    ## 5 2010-12-01      1159203         45536         533000
    ## 6 2011-01-01      1133880         51584         542331

``` r
names(AE_data)
```

    ## [1] "date"           "AE_att_TypeI"   "AE_att_TypeII"  "AE_att_TypeIII"

``` r
AE_data
```

    ## # A tibble: 164 × 4
    ##    date       AE_att_TypeI AE_att_TypeII AE_att_TypeIII
    ##    <date>            <int>         <int>          <int>
    ##  1 2010-08-01      1138652         54371         559358
    ##  2 2010-09-01      1150728         55181         550359
    ##  3 2010-10-01      1163143         54961         583244
    ##  4 2010-11-01      1111294         53727         486005
    ##  5 2010-12-01      1159203         45536         533000
    ##  6 2011-01-01      1133880         51584         542331
    ##  7 2011-02-01      1053707         51249         494407
    ##  8 2011-03-01      1225221         57900         580318
    ##  9 2011-04-01      1197212         54042         593119
    ## 10 2011-05-01      1221687         57066         594940
    ## # ℹ 154 more rows

``` r
#   Pivot longer
# AE_data_long <- AE_data %>% 
#                    select(period, type1_att, type2_att, type3_att) %>% 
#                    pivot_longer(names_to = "Type",
#                                 cols = 2:ncol(AE_data))
# AE_data_long
```

``` r
## [1] "date"           "AE_att_TypeI"   "AE_att_TypeII"  "AE_att_TypeIII"
#   Pivot longer
AE_data_pivot <- AE_data

AE_data_pivot
```

    ## # A tibble: 164 × 4
    ##    date       AE_att_TypeI AE_att_TypeII AE_att_TypeIII
    ##    <date>            <int>         <int>          <int>
    ##  1 2010-08-01      1138652         54371         559358
    ##  2 2010-09-01      1150728         55181         550359
    ##  3 2010-10-01      1163143         54961         583244
    ##  4 2010-11-01      1111294         53727         486005
    ##  5 2010-12-01      1159203         45536         533000
    ##  6 2011-01-01      1133880         51584         542331
    ##  7 2011-02-01      1053707         51249         494407
    ##  8 2011-03-01      1225221         57900         580318
    ##  9 2011-04-01      1197212         54042         593119
    ## 10 2011-05-01      1221687         57066         594940
    ## # ℹ 154 more rows

``` r
AE_data_long <- AE_data_pivot %>% 
                pivot_longer(names_to = "Type",
                                  cols = 2:ncol(AE_data_pivot))
AE_data_long
```

    ## # A tibble: 492 × 3
    ##    date       Type             value
    ##    <date>     <chr>            <int>
    ##  1 2010-08-01 AE_att_TypeI   1138652
    ##  2 2010-08-01 AE_att_TypeII    54371
    ##  3 2010-08-01 AE_att_TypeIII  559358
    ##  4 2010-09-01 AE_att_TypeI   1150728
    ##  5 2010-09-01 AE_att_TypeII    55181
    ##  6 2010-09-01 AE_att_TypeIII  550359
    ##  7 2010-10-01 AE_att_TypeI   1163143
    ##  8 2010-10-01 AE_att_TypeII    54961
    ##  9 2010-10-01 AE_att_TypeIII  583244
    ## 10 2010-11-01 AE_att_TypeI   1111294
    ## # ℹ 482 more rows

Then we can plot the data by Attendances type.

- How to control the amount of break and minor breaks to display with
  *date_breaks* and *date_minor_breaks*:
  <https://r-graph-gallery.com/279-plotting-time-series-with-ggplot2.html>
- Also this is an example of a Stacked area chart:
  <https://r-graph-gallery.com/136-stacked-area-chart.html>

``` r
data_area_chart <- AE_data_long %>% 
                   select(date,Type,value) 
data_area_chart
```

    ## # A tibble: 492 × 3
    ##    date       Type             value
    ##    <date>     <chr>            <int>
    ##  1 2010-08-01 AE_att_TypeI   1138652
    ##  2 2010-08-01 AE_att_TypeII    54371
    ##  3 2010-08-01 AE_att_TypeIII  559358
    ##  4 2010-09-01 AE_att_TypeI   1150728
    ##  5 2010-09-01 AE_att_TypeII    55181
    ##  6 2010-09-01 AE_att_TypeIII  550359
    ##  7 2010-10-01 AE_att_TypeI   1163143
    ##  8 2010-10-01 AE_att_TypeII    54961
    ##  9 2010-10-01 AE_att_TypeIII  583244
    ## 10 2010-11-01 AE_att_TypeI   1111294
    ## # ℹ 482 more rows

## 6.Area chart displaying Type I, TypeII, Type III Attendances by Type

### 6.1 Building plot in Markdown report

This final section describe A&E Attendances by type as an area chart, to
visualize the contribution of each A&E Attendances type to the overall
total number of Attendances

I will mimic the chart displaying different categories by colours
displayed in this website:
<https://epirhandbook.com/en/reports-with-r-markdown.html>

``` r
library(viridis)
library(hrbrthemes)

area_chart <- ggplot(data_area_chart, aes(x = date, y = value, fill = Type)) +
      labs(title = "A&E Attendances by type. 2010-2024 period",
         subtitle = "TypeI, TypeII, TypeIII A&E Attendances by month",
         x = "Period", y = "Value" ) +
  geom_area(alpha = 0.6, size = .5, colour = "white") 
area_chart
```

<img src="AE_Attendances_report_rendered_in_pipeline_github_files/figure-gfm/Time_chart_by_Type-1.png" width="110%" height="100%" />

### 6.2 Using targets object

``` r
tar_read(area_chart)
```

![](AE_Attendances_report_rendered_in_pipeline_github_files/figure-gfm/plot_using_targets-1.png)<!-- -->
