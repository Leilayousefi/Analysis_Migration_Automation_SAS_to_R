# Analysis_Migration_Automation_SAS_to_R
Data Analysis for Complex data & Migration & Automation SAS to R

# To Do List
## Working with data
repeating three main processes:
### 1. Reading the data.
### 2. Data Analysis and Transformation.
### 3. Data Visualization and Reporting.

# Data objects
http://r-pkgs.had.co.nz/data.html

# RAP package
https://github.com/DCMSstats/eesectors

# roxygen2 documentation
https://cran.r-project.org/web/packages/roxygen2/vignettes/roxygen2.html

# S3 classes
http://adv-r.had.co.nz/OO-essentials.html#s3

# eesectors convert to class with checks
# convert all that expert domain knowledge into quality assurance
# good example of using a custom class
https://github.com/DCMSstats/eesectors/blob/master/R/year_sector_data.R

# error logging
advanced toolkit
this allows personalised condition handling messages based on the user
for example a package user might jsut want to know whether the data passed the checks or not, whereas the creator might want to know more detailed diagnostics of the checks run
https://github.com/zatonovo/futile.logger

#Testing the input data summary
https://ukgovdatascience.github.io/rap_companion/qa-data.html
##
## -------------------------------------------------------------------------------------------------------------------
##
# Migrating SAS to R

# *SAS to R cheatsheet* 

This list was created to quickly translate a SAS code to its equivalent in R.

## Importing / Reading Data 

### create tables in R:

#### SAS:
```SAS
PROC SQL;
CREATE TABLE WORK.maindatabase AS 
SELECT t1.
FROM TTHTTS.allapplfinal_final t1;
QUIT;
```

##### R:
###### Method 1: Create a table from existing data.

```R
tab <- table(df$row_variable, df$column_variable)
```

###### Method 2: Create a table from scratch.

```R
tab <- matrix(c(7, 5, 14, 19, 3, 2, 17, 6, 12), ncol=3, byrow=TRUE)
colnames(tab) <- c('colName1','colName2','colName3')
rownames(tab) <- c('rowName1','rowName2','rowName3')
tab <- as.table(tab)
```

### convert to data table:
#### SAS:
```SAS
data work.maindatabase;
          set TTHTTS.allapplfinal_final_mar21v1;*/
run;
```

##### R:
```R
data.table::fread(work.maindatabase)
```

### Loading data from a data file

In this example, the file in CSV format.


#### SAS:

```SAS
PROC IMPORT DATAFILE="example.csv";
     OUT=d;
     DBMS=CSV;
```

##### R:
 
```R
## if csv file was saved locally
#csv_file<-read.csv(path, stringsAsFactors = FALSE)
d = read.csv('example.csv')
```

### Loading data from a file in S3 bucket AWS

In this example, the file in CSV format.


#### SAS:

```SAS
PROC IMPORT DATAFILE="example.csv";
     OUT=d;
     DBMS=CSV;
```

##### R:
 
```R
d = read.csv('example.csv')
```

Caveat: depending on your platform, you might need to enter ```FILENAME CSV "example.csv" TERMSTR=CRLF;``` (windows carriage returns) or ```FILENAME CSV "example.csv" TERMSTR=LF;``` (linux) prior to importing.


### Loading inline data

Typically copy-and-paste a few lines of data in CSV format.

##### R:
 
```R
d = read.table(sep=',', text='AMC   ,  22 ,3 ,2930 ,0
AMC   ,  17 ,3 ,3350 ,0
AMC   ,  22 , ,2640 ,0
Audi  ,  17 ,5 ,2830 ,1
Audi  ,  23 ,3 ,2070 ,1
BMW   ,  25 ,4 ,2650 ,1
Buick ,  20 ,3 ,3250 ,0
Buick ,  15 ,4 ,4080 ,0
Buick ,  18 ,3 ,3670 ,0
Buick ,  26 , ,2230, 0
Buick ,  20 ,3 ,3280 ,0
Buick ,  16 ,3 ,3880 ,0
Buick ,  19 ,3 ,3400 ,0')
colnames(d) = c('make', 'mpg', 'rep78', 'weight', 'foreign')
```

##### SAS:

```SAS
DATA d;
INFILE CARDS DELIMITER=',';
  INPUT make $  mpg rep78 weight foreign;
  CARDS;
  AMC   ,  22 ,3 ,2930 ,0
  AMC   ,  17 ,3 ,3350 ,0
  AMC   ,  22 , ,2640 ,0
  Audi  ,  17 ,5 ,2830 ,1
  Audi  ,  23 ,3 ,2070 ,1
  BMW   ,  25 ,4 ,2650 ,1
  Buick ,  20 ,3 ,3250 ,0
  Buick ,  15 ,4 ,4080 ,0
  Buick ,  18 ,3 ,3670 ,0
  Buick ,  26 , ,2230, 0
  Buick ,  20 ,3 ,3280 ,0
  Buick ,  16 ,3 ,3880 ,0
  Buick ,  19 ,3 ,3400 ,0
  ;
```

Caveat: use `$` to indicate a String field.


## Common data manipulation

### sorting one dataset

In this example, `dataset` is a `data.frame`/`DATA` with one column named `thekey` and some other columns containing different values.

##### R:

```R
sorted_dataset = dataset[order(dataset$thekey),]
```

#### SAS:

```SAS
PROC SORT DATA=sorted_dataset;
BY thekey;
```

### Merging two datasets

##### R:

```R
merged_dataset = merge(first_dataset, second_dataset, by='the_key')
```

#### SAS:

```SAS
PROC SORT DATA=first_dataset;
BY the_key;

PROC SORT DATA=second_dataset;
BY the_key;

DATA merged_dataset;
MERGE first_dataset second_dataset;
BY the_key;
```

Huge caveat: `MERGE` requires the data to be sorted. To avoid sorting beforehand, it is possible to make the merge with `PROC SQL`:
```SAS
PROC SQL;
  CREATE TABLE merged_dataset AS
  SELECT * 
  FROM first_dataset
  FULL JOIN second_dataset
  ON first_dataset.the_key = second_dataset.the_key;
```

### Concatenating two datasets

##### R:

```R
both = rbind(first_dataset, second_dataset)
```

Note: if the columns do not match, invoke `rbind.fill` instead of `rbind` (from package `plyr`).

#### SAS:

```SAS
DATA both;
SET first_dataset second_dataset;
RUN;
```

## Data statistics

### Showing summary statistics

##### R:

```R
summary(d)
```

#### SAS:

```SAS
PROC MEANS DATA=d;
```
