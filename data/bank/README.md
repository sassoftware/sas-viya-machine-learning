# Bank Data
<html>

<head>
<meta http-equiv=Content-Type content="text/html; charset=windows-1252">
<meta name=Generator content="Microsoft Word 15 (filtered)">


</head>

<body lang=EN-US>

<div class=WordSection1>

<p class=MsoNormal>The bank data set contain more than 1
million rows (or observations) and 24 columns (or variables). Three target
variables are provided, but the primary focus is on the binary target (<b>B_TGT</b>,
see below).</p>

<p class=MsoNormal>The <b>bank </b> data set consists of observations
taken on a large financial services firm's accounts. Accounts in the data
represent consumers of home equity lines of credit, automobile loans, and other
types of short- to medium-term credit instruments.</p>

<p class=MsoNormal>The data have been anonymized and transformed to conform to
the following description: <br>
A campaign interval for the bank runs for half of a year. A campaign is used
here to denote all marketing efforts that provide information about and
motivate the contracting (purchase) of the bank's financial services products.
Campaign promotions are categorized into <i>direct </i>and <i>indirect</i>.
Direct promotions consist of sales offers to a particular account that involve
an incentive. Indirect promotions are marketing efforts that do not involve an
incentive.</p>

<p class=MsoNormal>In addition to the account identifier (<b>Account ID</b>),
the following variables are in the data set:</p>

<p class=MsoNormal style='page-break-after:avoid'><b><i>Target variables</i> </b>quantify
account responses over the current campaign season. </p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='background:black;border-collapse:collapse;border:none'>
 <tr>
  <td width=84 valign=top style='width:62.8pt;border:solid white 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:white'>Name</span></b></p>
  </td>
  <td width=102 valign=top style='width:76.2pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:white'>Label</span></b></p>
  </td>
  <td width=437 valign=top style='width:328.0pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:white'>Description
  </span></b></p>
  </td>
 </tr>
 <tr>
  <td width=84 valign=top style='width:62.8pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='font-size:
  10.5pt;color:black'>B_TGT</span></b></p>
  </td>
  <td width=102 valign=top style='width:76.2pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><span style='font-size:
  10.5pt;color:black'>Tgt Binary New Product</span></p>
  </td>
  <td width=437 valign=top style='width:328.0pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><span style='font-size:
  10.5pt;color:black'>A binary target variable. Accounts coded with a 1
  contracted for at least one product in the previous campaign season. Accounts
  coded with a zero did not contract for a product in the previous campaign season.</span></p>
  </td>
 </tr>
 <tr>
  <td width=84 valign=top style='width:62.8pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='font-size:10.5pt;color:black'>INT_TGT</span></b></p>
  </td>
  <td width=102 valign=top style='width:76.2pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='font-size:10.5pt;color:black'>Tgt Interval
  New Sales</span></p>
  </td>
  <td width=437 valign=top style='width:328.0pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='font-size:10.5pt;color:black'>The amount of
  financial services product (sum of sales) per account in the previous
  campaign season, denominated in US dollars.</span></p>
  </td>
 </tr>
 <tr>
  <td width=84 valign=top style='width:62.8pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='font-size:10.5pt;color:black'>CNT_TGT</span></b></p>
  </td>
  <td width=102 valign=top style='width:76.2pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='font-size:10.5pt;color:black'>Tgt Count
  Number New Products</span></p>
  </td>
  <td width=437 valign=top style='width:328.0pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='font-size:10.5pt;color:black'>The number of
  financial services products (count) per account in the previous campaign
  season.</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal style='page-break-after:avoid'><b><i>&nbsp;</i></b></p>

<p class=MsoNormal style='page-break-after:avoid'><b><i>Categorical-valued inputs</i></b>
summarize account-level attributes related to the propensity to buy products
and other characteristics related to profitability and creditworthiness. These
variables have been transformed to anonymize account-level information and to
mitigate quality issues related to excessive cardinality.</p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='background:black;border-collapse:collapse;border:none'>
 <tr>
  <td width=105 valign=top style='width:78.45pt;border:solid white 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:white'>Name</span></b></p>
  </td>
  <td width=117 valign=top style='width:87.55pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:white'>Label</span></b></p>
  </td>
  <td width=401 valign=top style='width:301.0pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:white'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=105 valign=top style='width:78.45pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='font-size:
  10.5pt;color:black'>CAT_INPUT1</span></b></p>
  </td>
  <td width=117 valign=top style='width:87.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><span style='font-size:
  10.5pt;color:black'>Category 1 Account Activity Level</span></p>
  </td>
  <td width=401 valign=top style='width:301.0pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><span style='font-size:
  10.5pt;color:black'>A three-level categorical variable that codes the
  activity of each account.</span></p>
  <p class=MsoListParagraphCxSpFirst style='margin-left:10.6pt;text-indent:
  -10.6pt;page-break-after:avoid'><span style='font-size:10.5pt;font-family:
  Symbol;color:black'><span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;
  </span></span><span style='font-size:10.5pt;color:black'>X </span><span
  style='font-size:10.5pt;font-family:Wingdings;color:black'></span><span
  style='font-size:10.5pt;color:black'> high activity. The account enters the
  current campaign period with a lot of products.</span></p>
  <p class=MsoListParagraphCxSpMiddle style='margin-left:10.6pt;text-indent:
  -10.6pt;page-break-after:avoid'><span style='font-size:10.5pt;font-family:
  Symbol;color:black'><span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp;
  </span></span><span style='font-size:10.5pt;color:black'>Y </span><span
  style='font-size:10.5pt;font-family:Wingdings;color:black'></span><span
  style='font-size:10.5pt;color:black'> average activity.</span></p>
  <p class=MsoListParagraphCxSpLast style='margin-left:10.6pt;text-indent:-10.6pt;
  page-break-after:avoid'><span style='font-size:10.5pt;font-family:Symbol;
  color:black'><span style='font:7.0pt "Times New Roman"'>&nbsp;&nbsp;&nbsp; </span></span><span
  style='font-size:10.5pt;color:black'>Z </span><span style='font-size:10.5pt;
  font-family:Wingdings;color:black'></span><span style='font-size:10.5pt;
  color:black'> low activity.</span></p>
  </td>
 </tr>
 <tr>
  <td width=105 valign=top style='width:78.45pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='font-size:10.5pt;color:black'>CAT_INPUT2</span></b></p>
  </td>
  <td width=117 valign=top style='width:87.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='font-size:10.5pt;color:black'>Category 2
  Customer Value Level</span></p>
  </td>
  <td width=401 valign=top style='width:301.0pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='font-size:10.5pt;color:black'>A five-level
  (A-E) categorical variable that codes customer value. For example, the most
  profitable and creditworthy customers are coded with an A.</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><b><i>&nbsp;</i></b></p>

<p class=MsoNormal><b><i>Interval-valued inputs</i> </b>provide continuous
measures on account-level attributes related to the recency, frequency, and
sales amounts (<b>RFM</b>). These variables have been transformed to anonymize
account-level information.<b> </b>All measures below correspond to activity
prior to the current campaign season. </p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='background:black;border-collapse:collapse;border:none'>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:white'>Name</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:white'>Label </span></b></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:white'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM1</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM1 Average Sales Past 3 Years</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Average sales amount attributed
  to each account over the past three years</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM2</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM2 Average Sales Lifetime</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Average sales amount attributed
  to each account over the account's tenure</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM3</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM3 Avg Sales Past 3 Years Dir
  Promo Resp</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Average sales amount attributed
  to each account in the past three years in response to a direct promotion</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><b><span style='color:black'>RFM4</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal style='page-break-after:avoid'><span style='color:black'>RFM4
  Last Product Purchase Amount</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Amount of the last product
  purchased</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM5</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM5 Count Purchased Past 3
  Years</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Number of products purchased in
  the past three years</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM6</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM6 Count Purchased Lifetime</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Total number of products
  purchased in each account's tenure.</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM7</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM7 Count Prchsd Past 3 Years
  Dir Promo Resp</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Number of products purchased in
  the previous three years in response to a direct promotion</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM8</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM8 Count Prchsd Lifetime Dir
  Promo Resp</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Total number of products
  purchased in the account's tenure in response to a direct promotion</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM9</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM9 Months Since Last Purchase</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Months since the last product
  purchase</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM10</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM10 Count Total Promos Past
  Year</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Number of total promotions
  received by each account in the past year</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM11</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM11 Count Direct Promos Past
  Year</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Number of direct promotions
  received by each account in the past year</span></p>
  </td>
 </tr>
 <tr>
  <td width=90 valign=top style='width:67.25pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>RFM12</span></b></p>
  </td>
  <td width=170 valign=top style='width:127.15pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>RFM12 Customer Tenure</span></p>
  </td>
  <td width=364 valign=top style='width:273.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Customer tenure in months.</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal><b><i>&nbsp;</i></b></p>

<p class=MsoNormal><b><i>Demographic variables</i> </b>describe the profile of
each account in terms of income, homeownership, and other characteristics.<b> </b></p>

<table class=MsoNormalTable border=1 cellspacing=0 cellpadding=0
 style='background:black;border-collapse:collapse;border:none'>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:white'>Name</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:white'>Label</span></b></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border:solid white 1.0pt;
  border-left:none;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:white'>Description</span></b></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_AGE</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Customer Age</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Average age in each account's
  demographic region</span></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_GENF</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Female Binary</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>A categorical variable that is 1
  if the primary holder of the account if female and 0 otherwise.</span></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_GENM</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Male Binary</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>A categorical variable that is 1
  if the primary holder of the account is male and 0 otherwise</span></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_HO</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Homeowner Binary</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>A categorical variable that is 1
  if the primary holder of the account is a homeowner and 0 otherwise.</span></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_HOMEVAL</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Home Value</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Average home value in each
  account's demographic region</span></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_INC</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Income</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#CCCCCC;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Average income in each account's
  demographic region</span></p>
  </td>
 </tr>
 <tr>
  <td width=154 valign=top style='width:115.75pt;border:solid white 1.0pt;
  border-top:none;background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><b><span style='color:black'>DEMOG_PR</span></b></p>
  </td>
  <td width=148 valign=top style='width:111.1pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>Demog Percentage Retired</span></p>
  </td>
  <td width=317 valign=top style='width:237.55pt;border-top:none;border-left:
  none;border-bottom:solid white 1.0pt;border-right:solid white 1.0pt;
  background:#F3F3F3;padding:0in 5.4pt 0in 5.4pt'>
  <p class=MsoNormal><span style='color:black'>The percentage of retired people
  in each account's demographic region</span></p>
  </td>
 </tr>
</table>

<p class=MsoNormal>&nbsp;</p>

</div>

</body>

</html>
