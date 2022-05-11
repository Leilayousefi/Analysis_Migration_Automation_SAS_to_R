# Analysis_Migration_Automation_SAS_to_R
Data Analysis for Complex data & Migration & Automation SAS to R

Software Development and Quality Assurance
Author: Leila Yousefi


## USER-CENTRED DESIGN ---------------------------------------
Developing digital prototypes to replace aspects of business 
that are entirely paper-based or ambiguous

# WRITING USER STORIES
The most common template for writing a User Story:

As a <user type>, I want <some goal> so that <some reason>.

In other words, we are answering the following questions:

Who: For whose benefit are we doing this?

What: What are we doing?

Why: Why are we doing this?

# Defining Conditions of Satisfaction

# Creating workflow diagrams

# The use of wireframes and visual designs

# Defining non-functional requirements

# CREATING TEST TABLES AND TEST SCENARIOS

Basing service design on user needs is essential to ensure quality and
reduce the cost of failure waste/

## USER REQUIREMENTS SPECIFICATIONS 
User Requirements Specifications are a valuable tool for ensuring the system will do what users need it to do. In Retrospective Validation, where an existing system is being validated, user requirements are equivalent to the Functional Requirements.
However, User Requirements describe the end-user requirements for a system. Functional Requirements describe what the system must do.

## FUNCTIONAL REQUIREMENTS SHOULD INCLUDE:

# Descriptions of data to be entered into the system
# Descriptions of operations performed by each screen
# Descriptions of workflows performed by the system
# Descriptions of system reports or other outputs
# Who can enter the data into the system
# How the system meets applicable regulatory requirements

The Functional Requirements Specification is designed to be read by a general audience. Readers should understand the system, but no particular technical knowledge should be required to understand the document.

# INTERFACE REQUIREMENTS

Field 1 accepts numeric data entry.
Field 2 only accepts dates before the current date.
Screen 1 can print on-screen data to the printer.
BUSINESS REQUIREMENTS

Data must be entered before a request can be approved.
Clicking the Approve button moves the request to the Approval Workflow.
All personnel using the system will be trained according to internal SOP AA-101.
REGULATORY/COMPLIANCE REQUIREMENTS

The database will have a functional audit trail.
The system will limit access to authorized users.
The spreadsheet can secure data with electronic signatures.
SECURITY REQUIREMENTS

Members of the Data Entry group can enter requests but cannot approve or delete requests.
Members of the Managers group can enter or approve a request but cannot delete requests.
Members of the Administrators group cannot enter or approve requests but can delete requests.
Depending on the system being described, different categories of requirements are appropriate. System Owners, Key End-Users, Developers, Engineers, and Quality Assurance should all participate in the requirement gathering process, as appropriate to the system.
# 1. There is a need for a well-documented and understood development process
   
   So that we can ensure a high level of quality
   And so, we can maximise the integrity of the source code
   
   So that the service can be changed on a very frequent basis
   And so that changes do not cause problems for users
   
# 2. There is a need for a clear policy around the sensitivity of source code   

   So that I understand the controls that need to be in place
   And so that I know who and how I may share it
   
# 3. There is a need for a documented process for evaluating and deciding on a change to the production service
   So that I can release changes to production quickly
   And so that we can meet our obligation to the Digital by Default Service Standard
   
# 4. There is a need to switch to a suitable database server
   As a web operations engineer working on the service
   So that data can be stored in a manner befitting its structure
   And so the stored data can be queried as quickly as required

# 5. It is required that database migrations to be deployed through the same sequence of environments as code changes
   So that I can have confidence that database migration scripts will work when applied to production
   
# 6. There is need to use automatic unit testing as well as logging
   So that I can easily see everything that is happening in specific applications
   

QA:

 FUNCTIONAL SUITABILITY
DEGREE TO WHICH A PRODUCT OR SYSTEM PROVIDES
FUNCTIONS THAT MEET STATED AND IMPLIED NEEDS
WHEN USED UNDER SPECIFIED CONDITIONS.
FUNCTIONAL COMPLETENESS
DEGREE TO WHICH THE SET OF FUNCTIONS COVERS ALL THE
SPECIFIED TASKS AND USER OBJECTIVES.
Functional correctness
DEGREE TO WHICH A PRODUCT OR SYSTEM PROVIDES THE
CORRECT RESULTS WITH THE NEEDED DEGREE OF
PRECISION.
FUNCTIONAL APPROPRIATENESS
DEGREE TO WHICH THE FUNCTIONS FACILITATE THE
ACCOMPLISHMENT OF SPECIFIED TASKS AND OBJECTIVES.
Performance efficiency
PERFORMANCE RELATIVE TO THE AMOUNT OF RESOURCES
USED UNDER STATED CONDITIONS.
TIME BEHAVIOUR
DEGREE TO WHICH THE RESPONSE AND PROCESSING
TIMES AND THROUGHPUT RATES OF A PRODUCT OR SYSTEM,
WHEN PERFORMING ITS FUNCTIONS, MEET REQUIREMENTS.
Resource utilization
DEGREE TO WHICH THE AMOUNTS AND TYPES OF
RESOURCES USED BY A PRODUCT OR SYSTEM, WHEN
PERFORMING ITS FUNCTIONS, MEET REQUIREMENTS.
CAPACITY
DEGREE TO WHICH THE MAXIMUM LIMITS OF A PRODUCT
OR SYSTEM PARAMETER MEET REQUIREMENTS.
Compatibility
DEGREE TO WHICH A PRODUCT, SYSTEM OR COMPONENT
CAN EXCHANGE INFORMATION WITH OTHER PRODUCTS,
SYSTEMS OR COMPONENTS, AND/OR PERFORM ITS
REQUIRED FUNCTIONS, WHILE SHARING THE SAME
HARDWARE OR SOFTWARE ENVIRONMENT.
CO-EXISTENCE
DEGREE TO WHICH A PRODUCT CAN PERFORM ITS
REQUIRED FUNCTIONS EFFICIENTLY WHILE SHARING A
COMMON ENVIRONMENT AND RESOURCES WITH OTHER
PRODUCTS, WITHOUT DETRIMENTAL IMPACT ON ANY OTHER
PRODUCT.
Interoperability
DEGREE TO WHICH TWO OR MORE SYSTEMS, PRODUCTS OR
COMPONENTS CAN EXCHANGE INFORMATION AND USE THE
INFORMATION THAT HAS BEEN EXCHANGED.
USABILITY
DEGREE TO WHICH A PRODUCT OR SYSTEM CAN BE USED
BY SPECIFIED USERS TO ACHIEVE SPECIFIED GOALS WITH
EFFECTIVENESS, EFFICIENCY AND SATISFACTION IN A
SPECIFIED CONTEXT OF USE.
Appropriateness recognizability
DEGREE TO WHICH USERS CAN RECOGNIZE WHETHER A
PRODUCT OR SYSTEM IS APPROPRIATE FOR THEIR NEEDS.
LEARNABILITY
DEGREE TO WHICH A PRODUCT OR SYSTEM CAN BE USED
BY SPECIFIED USERS TO ACHIEVE SPECIFIED GOALS OF
LEARNING TO USE THE PRODUCT OR SYSTEM WITH
EFFECTIVENESS, EFFICIENCY, FREEDOM FROM RISK AND
SATISFACTION IN A SPECIFIED CONTEXT OF USE.
Operability
DEGREE TO WHICH A PRODUCT OR SYSTEM HAS ATTRIBUTES
THAT MAKE IT EASY TO OPERATE AND CONTROL.
USER ERROR PROTECTION
DEGREE TO WHICH A SYSTEM PROTECTS USERS AGAINST
MAKING ERRORS.
User interface aesthetics
DEGREE TO WHICH A USER INTERFACE ENABLES PLEASING
AND SATISFYING INTERACTION FOR THE USER.
ACCESSIBILITY
DEGREE TO WHICH A PRODUCT OR SYSTEM CAN BE USED
BY PEOPLE WITH THE WIDEST RANGE OF CHARACTERISTICS
AND CAPABILITIES TO ACHIEVE A SPECIFIED GOAL IN A
SPECIFIED CONTEXT OF USE.
Reliability
DEGREE TO WHICH A SYSTEM, PRODUCT OR COMPONENT
PERFORMS SPECIFIED FUNCTIONS UNDER SPECIFIED
CONDITIONS FOR A SPECIFIED PERIOD OF TIME.
MATURITY
DEGREE TO WHICH A SYSTEM, PRODUCT OR COMPONENT
MEETS NEEDS FOR RELIABILITY UNDER NORMAL OPERATION.
Availability
DEGREE TO WHICH A SYSTEM, PRODUCT OR COMPONENT
IS OPERATIONAL AND ACCESSIBLE WHEN REQUIRED FOR
USE.
FAULT TOLERANCE
DEGREE TO WHICH A SYSTEM, PRODUCT OR COMPONENT
OPERATES AS INTENDED DESPITE THE PRESENCE OF
HARDWARE OR SOFTWARE FAULTS.
Recoverability
DEGREE TO WHICH, IN THE EVENT OF AN INTERRUPTION OR
A FAILURE, A PRODUCT OR SYSTEM CAN RECOVER THE DATA
DIRECTLY AFFECTED AND RE-ESTABLISH THE DESIRED STATE
OF THE SYSTEM.
SECURITY
DEGREE TO WHICH A PRODUCT OR SYSTEM PROTECTS
INFORMATION AND DATA SO THAT PERSONS OR OTHER
PRODUCTS OR SYSTEMS HAVE THE DEGREE OF DATA
ACCESS APPROPRIATE TO THEIR TYPES AND LEVELS OF
AUTHORIZATION.
Confidentiality
DEGREE TO WHICH A PRODUCT OR SYSTEM ENSURES THAT
DATA ARE ACCESSIBLE ONLY TO THOSE AUTHORIZED TO
HAVE ACCESS.
INTEGRITY
DEGREE TO WHICH A SYSTEM, PRODUCT OR COMPONENT
PREVENTS UNAUTHORIZED ACCESS TO, OR MODIFICATION
OF, COMPUTER PROGRAMS OR DATA.
Non-repudiation
DEGREE TO WHICH ACTIONS OR EVENTS CAN BE PROVEN
TO HAVE TAKEN PLACE, SO THAT THE EVENTS OR ACTIONS
CANNOT BE REPUDIATED LATER.
ACCOUNTABILITY
DEGREE TO WHICH THE ACTIONS OF AN ENTITY CAN BE
TRACED UNIQUELY TO THE ENTITY.
Authenticity
DEGREE TO WHICH THE IDENTITY OF A SUBJECT OR
RESOURCE CAN BE PROVED TO BE THE ONE CLAIMED.
MAINTAINABILITY
DEGREE OF EFFECTIVENESS AND EFFICIENCY WITH WHICH A
PRODUCT OR SYSTEM CAN BE MODIFIED TO IMPROVE IT,
CORRECT IT OR ADAPT IT TO CHANGES IN ENVIRONMENT,
AND IN REQUIREMENTS.
Modularity
DEGREE TO WHICH A SYSTEM OR COMPUTER PROGRAM IS
COMPOSED OF DISCRETE COMPONENTS SUCH THAT A
CHANGE TO ONE COMPONENT HAS MINIMAL IMPACT ON
OTHER COMPONENTS.
REUSABILITY
DEGREE TO WHICH AN ASSET CAN BE USED IN MORE THAN
ONE SYSTEM, OR IN BUILDING OTHER ASSETS.
Analysability
DEGREE OF EFFECTIVENESS AND EFFICIENCY WITH WHICH
IT IS POSSIBLE TO ASSESS THE IMPACT ON A PRODUCT OR
SYSTEM OF AN INTENDED CHANGE TO ONE OR MORE OF ITS
PARTS, OR TO DIAGNOSE A PRODUCT FOR DEFICIENCIES OR
CAUSES OF FAILURES, OR TO IDENTIFY PARTS TO BE
MODIFIED.
MODIFIABILITY
DEGREE TO WHICH A PRODUCT OR SYSTEM CAN BE
EFFECTIVELY AND EFFICIENTLY MODIFIED WITHOUT
INTRODUCING DEFECTS OR DEGRADING EXISTING PRODUCT
QUALITY.
Testability
DEGREE OF EFFECTIVENESS AND EFFICIENCY WITH WHICH
TEST CRITERIA CAN BE ESTABLISHED FOR A SYSTEM,
PRODUCT OR COMPONENT AND TESTS CAN BE PERFORMED
TO DETERMINE WHETHER THOSE CRITERIA HAVE BEEN
MET.
Portability
DEGREE OF EFFECTIVENESS AND EFFICIENCY WITH WHICH A
SYSTEM, PRODUCT OR COMPONENT CAN BE TRANSFERRED
FROM ONE HARDWARE, SOFTWARE OR OTHER OPERATIONAL
OR USAGE ENVIRONMENT TO ANOTHER.
ADAPTABILITY
DEGREE TO WHICH A PRODUCT OR SYSTEM CAN
EFFECTIVELY AND EFFICIENTLY BE ADAPTED FOR DIFFERENT
OR EVOLVING HARDWARE, SOFTWARE OR OTHER
OPERATIONAL OR USAGE ENVIRONMENTS.
Installability
DEGREE OF EFFECTIVENESS AND EFFICIENCY WITH WHICH A
PRODUCT OR SYSTEM CAN BE SUCCESSFULLY INSTALLED
AND/OR UNINSTALLED IN A SPECIFIED ENVIRONMENT.
REPLACEABILITY
DEGREE TO WHICH A PRODUCT CAN REPLACE ANOTHER
SPECIFIED SOFTWARE PRODUCT FOR THE SAME PURPOSE IN
THE SAME ENVIRONMENT.
Service Quality
(PARTIALLY BASED ON SERVQUAL)
HOW OUR WORK IS PERCEIVED BY OUR CUSTOMERS.
EXPECTATION
DEGREE TO WHICH ACTUAL OUTCOMES MATCH (OR EVEN
EXCEED) THE EXPECTATIONS OF THE STAKEHOLDERS.
Effectiveness
DEGREE TO WHICH ACTUAL OUTCOMES SOLVE THE NEEDS
OF THE STAKEHOLDERS.
EFFICIENCY
DEGREE TO WHICH THE RESOURCES OF THE STAKEHOLDERS
(TIME, MONEY) ARE NOT WASTED.
Predictability
DEGREE TO WHICH ACTUAL OUTCOMES CAN BE
PREDICTED.
RELIABILITY
DEGREE TO WHICH THE STAKEHOLDERS CAN RELY ON THE
PROVIDER'S CONTINUOUS QUALITY OF OUTCOMES.
Responsiveness
DEGREE TO WHICH THE SERVICE PROVIDER IS WILLING AND
ABLE TO RESPOND PROMPTLY AND HELPFULLY.
ASSURANCE
DEGREE TO WHICH THE SERVICE PROVIDER IS ABLE TO
CONVEY TRUST AND CONFIDENCE.
Empathy
DEGREE TO WHICH THE SERVICE PROVIDER IS ABLE TO BE
APPROACHABLE, CARING, UNDERSTANDING AND TO RELATE
TO CUSTOMER NEEDS.
TANGIBLES
DEGREE TO WHICH PHYSICAL FACILITIES, EQUIPMENT,
PERSONNEL AND COMMUNICATION MATERIALS ARE
PERCEIVABLE.


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
