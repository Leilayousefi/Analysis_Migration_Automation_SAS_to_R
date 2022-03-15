# Analysis_Migration_Automation_SAS_to_R
Data Analysis for Complex data & Migration & Automation SAS to R


# Migrating SAS to R

# *SAS to R cheatsheet* 

This list was created to quickly translate a SAS code to its equivalent in R.

## Importing / Reading Data 

### create tables in R:

#### Method 1: Create a table from existing data.

```R
tab <- table(df$row_variable, df$column_variable)
```

#### Method 2: Create a table from scratch.

```R
tab <- matrix(c(7, 5, 14, 19, 3, 2, 17, 6, 12), ncol=3, byrow=TRUE)
colnames(tab) <- c('colName1','colName2','colName3')
rownames(tab) <- c('rowName1','rowName2','rowName3')
tab <- as.table(tab)
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
