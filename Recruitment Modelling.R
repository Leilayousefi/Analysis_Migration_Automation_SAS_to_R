library(readr)
library(tidyverse)
library(lubridate)
library(bizdays)


#read input file
TTH_Mock_data_1 <- read_csv("~/TestTTHmock/ApplMar19complete.csv")

#set start and end dates

StartDate <- dmy("01-Oct-2018")
EndDate <- dmy("01-Mar-2019")

#change format of relevant columns to dates
TTH_Mock_data_1 <- TTH_Mock_data_1 %>% 
  mutate(SubmissionDate2=dmy(str_sub(SubmissionDate,1,7)))
TTH_Mock_data_1 <- TTH_Mock_data_1 %>% 
  mutate(Interviewinvited2=dmy(str_sub(Interviewinvited,1,7)))
TTH_Mock_data_1 <- TTH_Mock_data_1 %>% 
  mutate(PreemploymentChecksComplete2=dmy(str_sub(PreemploymentChecksComplete,1,7)))
TTH_Mock_data_1 <- TTH_Mock_data_1 %>% 
  mutate(FormalOfferAccepted2=dmy(FormalOfferAccepted))
TTH_Mock_data_1 <- TTH_Mock_data_1 %>% 
  mutate(ProcessFinishMonth2=dmy(ProcessFinishMonth))
TTH_Mock_data_1 <- TTH_Mock_data_1 %>% 
  mutate(TimetoSignMonth2=dmy(TimetoSignMonth))


#filter Time ranges
datafilterdate <- filter(TTH_Mock_data_1, (ProcessFinishMonth2 >= StartDate & 
                                             ProcessFinishMonth2 < EndDate) | 
                                          (TimetoSignMonth2 >= StartDate & 
                                             TimetoSignMonth2 < EndDate) )


datafilterdate <- datafilterdate %>% rename(RollingCampaign = `Rolling Campaign`)


#filter out of scope - needs to be completed
datafilterdate2 <- filter(datafilterdate, !(is.na(BusinessGroupAll)), VacancyEventID != 12108)

datafilterdate2 <- datafilterdate2 %>% 
    mutate(BG_TTH2 = ifelse(BusinessGroupAll %in% c("CFOG", "CICA", "JAOPG", "JPSCG", "Legal Aid Agency", "PCAG", "CPOG", "Office of the Public Guardian", "People Group"), "MoJ HQ, LAA, OPG & CICA", 
                                                       ifelse(BusinessGroupAll == "HMCTS", "HMCTS", "HMPPS")

    ))


# business groups labels for the TTH report
TTHdata <- filter(datafilterdate2, ProcessFinishMonth2 >= StartDate & 
                                   ProcessFinishMonth2 < EndDate &
                                   !is.na(TotalTimetoHire) &
                                   !is.na(BG_TTH2)
                 )

# business groups labels for the TTS report
TTSdata <- filter(datafilterdate2, TimetoSignMonth2 >= StartDate & 
                    TimetoSignMonth2 < EndDate &
                    !is.na(ContractProcedure) &
                    !is.na(BG_TTH2)
)

# create Average Time to Hire input for Power BI

# values for BGs
TTHinputBGs <- TTHdata %>% group_by(BG_TTH2, ProcessFinishMonth2, RollingCampaign)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
            )

#Values for MoJ Overall
TTHinputOverall <- TTHdata %>% group_by(ProcessFinishMonth2, RollingCampaign)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

TTHinputOverall $ BG_TTH2 <- "MoJ Overall"

#---------------------rolling = "Both" ----------------------------------------------------

TTHinputBGsBoth <- TTHdata %>% group_by(BG_TTH2, ProcessFinishMonth2)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

TTHinputBGsBoth $ RollingCampaign <- "Both"

#Values for MoJ Overall
TTHinputOverallBoth <- TTHdata %>% group_by(ProcessFinishMonth2)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

TTHinputOverallBoth $ RollingCampaign <- "Both"
TTHinputOverallBoth $ BG_TTH2 <- "MoJ Overall"


#-----------------------------------------------------------------------------------------

#append BGs and MoJ Overall
TTHinput <- rbind(TTHinputBGs %>% ungroup(), TTHinputBGsBoth %>% ungroup(), 
                  TTHinputOverall  %>% ungroup(), TTHinputOverallBoth %>% ungroup())


# create Average Time to Sign input for Power BI

# values for BGs
# values for BGs
TTSinputBGs <- TTSdata %>% group_by(BG_TTH2, TimetoSignMonth2, RollingCampaign)%>% 
  summarise(Mean_CollatingContract =mean(CollatingContract, na.rm=TRUE),
            Mean_SigningContract =mean(SigningContract, na.rm=TRUE),
            Mean_ContractProcedure =mean(ContractProcedure, na.rm=TRUE),
            N_CollatingContract =sum(!is.na(CollatingContract)),
            N_SigningContract =sum(!is.na(SigningContract)),
            N_ContractProcedure =sum(!is.na(ContractProcedure)),
            Min_ContractProcedure =min(ContractProcedure, na.rm=TRUE),
            Max_ContractProcedure =max(ContractProcedure, na.rm=TRUE),
            Median_ContractProcedure =median(ContractProcedure, na.rm=TRUE)
           )

# values for MoJ Overall
TTSinputOverall <- TTSdata %>% group_by(TimetoSignMonth2, RollingCampaign)%>% 
  summarise(Mean_CollatingContract =mean(CollatingContract, na.rm=TRUE),
            Mean_SigningContract =mean(SigningContract, na.rm=TRUE),
            Mean_ContractProcedure =mean(ContractProcedure, na.rm=TRUE),
            N_CollatingContract =sum(!is.na(CollatingContract)),
            N_SigningContract =sum(!is.na(SigningContract)),
            N_ContractProcedure =sum(!is.na(ContractProcedure)),
            Min_ContractProcedure =min(ContractProcedure, na.rm=TRUE),
            Max_ContractProcedure =max(ContractProcedure, na.rm=TRUE),
            Median_ContractProcedure =median(ContractProcedure, na.rm=TRUE)
  )

TTSinputOverall $ BG_TTH2 <- "MoJ Overall"

#---------------------TTS Rolling both------------------------------------

# values for BGs
TTSinputBGsBoth <- TTSdata %>% group_by(BG_TTH2, TimetoSignMonth2)%>% 
  summarise(Mean_CollatingContract =mean(CollatingContract, na.rm=TRUE),
            Mean_SigningContract =mean(SigningContract, na.rm=TRUE),
            Mean_ContractProcedure =mean(ContractProcedure, na.rm=TRUE),
            N_CollatingContract =sum(!is.na(CollatingContract)),
            N_SigningContract =sum(!is.na(SigningContract)),
            N_ContractProcedure =sum(!is.na(ContractProcedure)),
            Min_ContractProcedure =min(ContractProcedure, na.rm=TRUE),
            Max_ContractProcedure =max(ContractProcedure, na.rm=TRUE),
            Median_ContractProcedure =median(ContractProcedure, na.rm=TRUE)
  )

TTSinputBGsBoth $ RollingCampaign <- "Both"

# values for MoJ Overall
TTSinputOverallBoth <- TTSdata %>% group_by(TimetoSignMonth2)%>% 
  summarise(Mean_CollatingContract =mean(CollatingContract, na.rm=TRUE),
            Mean_SigningContract =mean(SigningContract, na.rm=TRUE),
            Mean_ContractProcedure =mean(ContractProcedure, na.rm=TRUE),
            N_CollatingContract =sum(!is.na(CollatingContract)),
            N_SigningContract =sum(!is.na(SigningContract)),
            N_ContractProcedure =sum(!is.na(ContractProcedure)),
            Min_ContractProcedure =min(ContractProcedure, na.rm=TRUE),
            Max_ContractProcedure =max(ContractProcedure, na.rm=TRUE),
            Median_ContractProcedure =median(ContractProcedure, na.rm=TRUE)
  )

TTSinputOverallBoth $ RollingCampaign <- "Both"
TTSinputOverallBoth $ BG_TTH2 <- "MoJ Overall"

#-------------------------------------------------------------------------


#append BGs and MoJ Overall
TTSinput <- rbind(TTSinputBGs %>% ungroup(), TTSinputBGsBoth %>% ungroup(), 
                  TTSinputOverall  %>% ungroup(),  TTSinputOverallBoth  %>% ungroup())

#Rename month column in TTS
TTSinput <- TTSinput %>% rename(ProcessFinishMonth2 = TimetoSignMonth2)

#Merge TTH and TTS
TTHModelInputTotal <- left_join(TTHinput, TTSinput, by=c("BG_TTH2", "ProcessFinishMonth2", "RollingCampaign"))

#*********************************

#---------------------------HMCTS Regions---------------------------------------------

#*********************************

HMCTSdata <- filter(TTHdata, BusinessGroupAll == "HMCTS")

# values for HMCTS Regions
TTHHMCTS <- HMCTSdata %>% group_by(ProcessFinishMonth2, HMCTSregions, RollingCampaign)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )


#---------------------rolling = "Both" ----------------------------------------------------

TTHHMCTSBoth <- TTHdata %>% group_by(ProcessFinishMonth2, HMCTSregions)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

TTHHMCTSBoth $ RollingCampaign <- "Both"


#-----------------------------------------------------------------------------------------

#append BGs and MoJ Overall
TTHHMCTSinput <- rbind(TTHHMCTS %>% ungroup(), TTHHMCTSBoth %>% ungroup())

#read HMCTS centre points
HMCTSRegions <- readxl::read_excel(path = "Regions Centre points.xlsx")

#Rename Regions column
HMCTSRegions <- HMCTSRegions %>% rename(HMCTSregions = Region)

#add regions to HMCTS TTH
TTHHMCTSinput <- left_join(TTHHMCTSinput, HMCTSRegions, by=c("HMCTSregions"))


#****************************************************
#------------------Source of Application--------------------------------
#****************************************************

# values for BGs
SourceofAppinputBGs <- TTHdata %>% group_by(BG_TTH2, ProcessFinishMonth2, RollingCampaign, Currentemploymentstatus)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

#Values for MoJ Overall
SourceofAppinputOverall <- TTHdata %>% group_by(ProcessFinishMonth2, RollingCampaign, Currentemploymentstatus)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

SourceofAppinputOverall $ BG_TTH2 <- "MoJ Overall"

#---------------------rolling = "Both" ----------------------------------------------------

SourceofAppinputBGsBoth <- TTHdata %>% group_by(BG_TTH2, ProcessFinishMonth2, Currentemploymentstatus)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

SourceofAppinputBGsBoth $ RollingCampaign <- "Both"

#Values for MoJ Overall
SourceofAppinputOverallBoth <- TTHdata %>% group_by(ProcessFinishMonth2, Currentemploymentstatus)%>% 
  summarise(Mean_TotalTimetoHire = mean(TotalTimetoHire, na.rm=TRUE), 
            N_TotalTimetoHire = sum(!is.na(TotalTimetoHire)),
            Mean_CandidateSubmit = mean(CandidateSubmit, na.rm=TRUE), 
            Mean_Sifting = mean(Sifting, na.rm=TRUE),
            Mean_RollingSifting = mean(RollingSifting, na.rm=TRUE), 
            Mean_PlanningInter = mean(PlanningInter, na.rm=TRUE),
            Mean_BookingInter = mean(BookingInter, na.rm=TRUE), 
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE),
            Mean_PauseforInter = mean(PauseforInter, na.rm=TRUE), 
            Mean_InterProc = mean(InterProc, na.rm=TRUE),
            Mean_ProcResults = mean(ProcResults, na.rm=TRUE), 
            Mean_PauseWaitPreEmpCh = mean(PauseWaitPreEmpCh, na.rm=TRUE),
            Mean_OnboardFormFilled = mean(OnboardFormFilled, na.rm=TRUE), 
            Mean_PreempCheckStart = mean(PreempCheckStart, na.rm=TRUE),
            Mean_PECsProcess = mean(PECsProcess, na.rm=TRUE), 
            Mean_TotalPreEmpCh = mean(TotalPreEmpCh, na.rm=TRUE), 
            Mean_PreempCheckExtend = mean(PreempCheckExtend, na.rm=TRUE), 
            Mean_PreempCheckFinish = mean(PreempCheckFinish, na.rm=TRUE),
            N_CandidateSubmit = sum(!is.na(CandidateSubmit)),
            N_Sifting = sum(!is.na(Sifting)),
            N_RollingSifting = sum(!is.na(RollingSifting)),
            N_PlanningInter = sum(!is.na(PlanningInter)),
            N_BookingInter = sum(!is.na(BookingInter)),
            N_PauseforInter = sum(!is.na(PauseforInter)),
            N_InterProc = sum(!is.na(InterProc)),
            N_ProcResults = sum(!is.na(ProcResults)),
            N_PauseWaitPreEmpCh = sum(!is.na(PauseWaitPreEmpCh)),
            N_OnboardFormFilled = sum(!is.na(OnboardFormFilled)),
            N_PreempCheckStart = sum(!is.na(PreempCheckStart)),
            N_PECsProcess = sum(!is.na(PECsProcess)),
            N_TotalPreEmpCh = sum(!is.na(TotalPreEmpCh)),
            N_PreempCheckExtend = sum(!is.na(PreempCheckExtend)),
            N_PreempCheckFinish = sum(!is.na(PreempCheckFinish)),
            Min_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE),
            Max_TotalTimetoHire = max(TotalTimetoHire, na.rm=TRUE),
            Median_TotalTimetoHire = min(TotalTimetoHire, na.rm=TRUE)
            
  )

SourceofAppinputOverallBoth $ RollingCampaign <- "Both"
SourceofAppinputOverallBoth $ BG_TTH2 <- "MoJ Overall"


#-----------------------------------------------------------------------------------------

#append BGs and MoJ Overall
SourceofAppinput <- rbind(SourceofAppinputBGs %>% ungroup(), SourceofAppinputBGsBoth %>% 
                          ungroup(), SourceofAppinputOverall  %>% ungroup(), SourceofAppinputOverallBoth %>% 
                          ungroup()
                          )

#***********************************************
#-----------------------MoJ HQ (need to update the input)----------------------
#***********************************************

#************************************************
#-----------------------Histograms------------------------------------
#*************************************************

# define time range
monthearlier <-  EndDate - months(0:3)

#Prepare the data input for the last 4 months
histograminput<- subset(TTHdata, select = c(ApplicationID, BG_TTH2, ProcessFinishMonth2, TotalTimetoHire))

# number of months, needs to match monthearlier size
x <- c(1:4)

# define bin length
binlen <- 20
datalist = list()

for (val in x) {

  histograminput2<- filter(histograminput, ProcessFinishMonth2 == monthearlier[x])
  
  h_current_month <- monthearlier[x]
  #find longest TTH
  maxtth <- max(histograminput2$TotalTimetoHire)

  #find number of breaks in the histogram
  numbreaks <- ceiling(maxtth/binlen)
  
  # find max value inthe histogram range
  binlimit <- ceiling(maxtth)
  
  # create histograms
  h <- hist(histograminput2$TotalTimetoHire, breaks = numbreaks, xlim=c(0,binlimit))
  
  # minimal value in a given bin
  h_bin_min <- h$breaks
  h_bin_min <- h_bin_min[-length(h2)]
  
  # number of cases in a given bin
  h_count <- h$counts
  
  #create a dataframe - Power BI input
  h_input <- data.frame(h_bin_min,h_count)
  add_column(h_input, BG = "MoJ Overall", month = "h_current_month")
  
  datalist[[x]] <-  h_input

}  

big_data = do.call(rbind, datalist)
