title: "migration_SAS_to_R_QA_RAP"
output: Specification github document
---

Author: Leila Yousefi

# 1. There is a need for a well documented and understood development process
   
   So that we can ensure a high level of quality
   And so we can maximise the integrity of the source code
   
   So that the service can be changed on a very frequent basis
   And so that changes do not cause problems for users
   
   
# PROJECT NAME AND DESCRIPTION
 
 


# PURPOSE / GOALS
   
   

# ASSUMPTIONS
   
   

# MEASUREMENTS OF SUCCESS
   
   

# RISK FACTORS
   
   

# APPROACH
   






# SCOPE OF WORK
## FUNCTIONS / PROCESSES IMPACTED BY PROJECT

### IN SCOPE	 
	 
	 
	 
### OUT OF SCOPE	 
	 
	 
	 
### UNCERTAIN	 
	 
	 
	 
## INTERDEPENDENCIES / REPLACEMENT / CONSOLIDATION WITH OTHER SERVICES, PROJECTS, AND SYSTEMS


### IN SCOPE	 
	 
	 
	 
### OUT OF SCOPE	 
	 
	 
	 
### UNCERTAIN	 
	 
	 

# TIMELINE / MILESTONES

   
## OVERVIEW	 

   
   
### MILESTONE	

   
   
### DEADLINE


   
## -----------------------------------------------------------
If you would find it easier then you could just write your description and details of each code in a word document and share it in here then I will add it to the corresponding file in the git repository. e.g., r7_TTHsummary.R  : provides breakdowns for different parts of MoJ by producing summary stats for TTH. Iner process includes ... Inputs ... . Outputs ....
   
## -----------------------------------------------------------

# 2. There is a need for a clear policy around the sensitivity of source code   

   So that I understand the controls that need to be in place
   And so that I know who and how I may share it
   
# 3. There is a need for a documented process for evaluating and deciding on a change to the production service
   So that I can release changes to production quickly
   And so that we can meet our obligation to the Digital by Default Service Standard
   
   Use declarative formats for setup automation, to minimize time and cost for new developers joining the project;
# 4. There is a need to switch to a suitable database 
   (using S3 buckets and queies in Athena)
   So that data can be stored in a manner befitting its structure
   And so the stored data can be queried as quickly as required
   
Are suitable for deployment on modern cloud platforms, obviating the need for servers and systems administration;
Minimize divergence between development and production, enabling continuous deployment for maximum agility;
And can scale up without significant changes to tooling, architecture, or development practices.


# 5. It is required that database migrations to be deployed through the same sequence of environments as code changes
   So that I can have confidence that database migration scripts will work when applied to production
   
# 6. There is need to use automatic unit testing as well as logging
   So that I can easily see everything that is happening in specific applications
e.g., 
Automate testing

exploratory testing
user testing
performance testing

   If your software needs a database to be present to operate effectively, your smoke test should exercise an application code path that will fail if the database is not present or returns an error.

## See more information and examples:
https://mojdigital.blog.gov.uk/2015/07/29/helping-people-with-court-fees/

# Providing user-centred design for the whole project as user requirements:

## user-centred design ---------------------------------------
Developing digital prototypes to replace aspects of business 
that are entirely paper-based or ambiguous

# Writing User Stories
The most common template for writing a User Story:

As a <user type>, I want <some goal> so that <some reason>.

In other words, we are answering the following questions:

Who: For whose benefit are we doing this?

What: What are we doing?

Why: Why are we doing this?

# Defining Conditions of Satisfaction

# Creating workflow diagrams

# The use of wireframes and visual designs

# Defining nonfunctional requirements

# Creating test tables and test scenarios

Basing service design on user needs is essential to ensure quality and
reduce the cost of failure waste/

## User Requirements Specifications 
User Requirements Specifications are a valuable tool for ensuring the system will do what users need it to do. In Retrospective Validation, where an existing system is being validated, user requirements are equivalent to the Functional Requirements.
However, User Requirements describe the end-user requirements for a system. Functional Requirements describe what the system must do.

## Functional Requirements should include:

# Descriptions of data to be entered into the system

# Descriptions of operations performed by each code

# Descriptions of work-flows performed by the system

# Descriptions of system reports or other outputs

# Who can enter the data into the system

# How the system meets applicable regulatory requirements

The Functional Requirements Specification is designed to be read by a general audience. 
   Readers should understand the system, but no particular technical knowledge should be required to understand the document.

# Interactive / dynamic programming requirements: to reduce manual steps

   e.g.:
The response by user 1 only accepts numeric data entry.
The response by user 2 only accepts dates before the current date.
Output format must be csv

# Business Requirements

Data must be entered before a request can be approved.
by Approving ..., the request  moves to the Approval Workflow.
   
# Regulatory/Compliance Requirements

The database will have a functional audit trail.
The system will limit access to authorized users.
The spreadsheet can secure data with electronic signatures.

# Security Requirements


Depending on the system being described, different categories of requirements are appropriate. System Owners, Key End-Users, Developers, Engineers, and Quality Assurance should all participate in the requirement gathering process, as appropriate to the system.


## Questions ------------------------------------------------------

1. Please describe the following variables and the need for using them as a key feature:
## Variables
SubmissionDate
ApplicationID
VacancyEventID
VacancyEventTitleText
CandidateID
BuildingSite
BusinessAreaMerged
Vacancy.Status..List.
Last.Status.Change
MeritListContract
MeritListPeriod
GeographicalArea
ReserveListInitial
MeritListInitial
TimestampVacancyLive
TimestampClosedforApplications
CostCentreClean
Cost.centre.description
Group.Area
Division
MatchCostCentre
BusinessGroupAll
AgencyAll
DataCleanseFlag
HMPPSRoleTypes
AllocFinal
HMPPSAgency
HMPPSPrisonType
ProcessFinish
PreemploymentChecksComplete
ProcessFinishMonth
TimetoSignDate
TimetoSignMonth
PriorityRecruit
Rolling.Campaign
PriorityorRoll
FamilVisit
ProvisionalOffer
FormalOfferMade
FormalOfferAccepted
ResorMeritList
CandidateSubmit
SubmissionDateD
Sifting
SelectedforInterview1D
GamificationTestInProgress
AssessmentDaySelected
AssessmentDayInvited
AssessmentDayBooked
RollingSifting
PlanningInter
InterviewinvitedD
BookingInter
InterviewscheduledD
PauseforInter
Lastbookedinterviewdate
InterProc
ProcResults
PauseWaitPreEmpCh
OnboardingFormD
TotalPreEmpCh
OnboardFormFilled
OnboardingFormSubmittedD
PreempCheckStart
PreEmploymentChecksinProgD
PECsProcess
PreempCheckExtend
PreEmploymentChecksContinuedD
PreempCheckFinish
TotalTimetoHire
CollatingContract
SigningContract
ContractProcedure
GradeMoJ
Grade
promotion
ApplicationStatusText
nonOleeoRecruitmentStage
nonOleeoRecruitment
HMCTSregions
Currentemploymentstatus
Region
TidyNINumber




## -----------------------------------------------------------
2. Regarding the above variables, could you identify the key variables / nullable? 

## -----------------------------------------------------------

3. Could you please determine whether missing values and the imputation strategy based upon the above variables


## -----------------------------------------------------------
4. Regarding the dates variables? which ones are the key features and should not be NULL 
(if they are NULL, the corresponding rows should be deleted.)

## -----------------------------------------------------------
## Data Description 

Instruction:

In TTH_maindatabase_description.md add to our knowledge about the main TTH table. 
Click the edit links below to contribute via GitHub and follow these instructions:

Open feature/Data-Description branch off the main branch (add your content and commit as Added column name)


Make a pull request into the main branch and in the description state that you are providing explanation regarding the corresponding content in the design file.

# Table: maindatabase

| Feature | Details |
|---|---|
| **Description** | |
| **Format** | parquet|
| **Database** | xhibit_v1 |
| **Column Partitions** | None |
| **Location** | s3://alpha-hr-arm-main/data/oleeo_data/processed_data/recruitment_main_data/Jan-22/ |

## Description


There's nothing here yet.
## Table Columns

Details about the columns in the table.

<br>

<hr style='height:1px;border:none;color:black;background-color:black'>

### Column: SubmissionDate


| Feature | Details |
|---|---|
| **type** | date|
| **description** |  |
| **nullable** | False |

Timestamp of application submission.
<br><br>

<hr style='height:1px;border:none;color:black;background-color:black'>

### Column: applicationid


| Feature | Details |
|---|---|
| **type** | character|
| **description** |  |
| **nullable** | True |

Unique identifier for each application. Each row of our data is a different application.
<br><br>

   
## -----------------------------------------------------------   
## please continue by adding next columns ...

<hr style='height:1px;border:none;color:black;background-color:black'>



 	 
 	 
 	 
 	 
 	 
 	 
 	 
 	 
