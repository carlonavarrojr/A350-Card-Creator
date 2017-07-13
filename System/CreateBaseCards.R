library(dplyr)
library(stringr)
library(xlsx)

# Initialize Variables
x <- read.csv2("var.txt",sep = ",")
pathtoOutput <- as.character(x[1,"pathtoOutput"])
pathtoAMM <- as.character(x[1,"pathtoAMM"])
pathtoMS <- as.character(x[1,"pathtoMS"])
#Create Cards 
# Variable Task Card creates the card itself
# Mutate MS to include:

print("Reading MS Excel File...")
MS <- read.xlsx(pathtoMS, sheetIndex = 1, startRow = 5, header = TRUE, colIndex = 1:16)

MS <- mutate(MS, 
             CardNo = paste("A320-",MS[,"TASK.NUMBER"],"-01",sep = ""),
             Key = "SYS", 
             CardRevDate = strftime(Sys.Date(),format = "%d %b %Y"), 
             RevNum = "01", 
             Status = "DRAFT")

MS <- mutate(MS,
             TCZone = paste("<ZONE>", gsub("\n","</ZONE><ZONE>",str_trim(MS[,"ZONE"])), "</ZONE>", sep = ""),
             TCApplic = paste("<APPLIC>", gsub("\n","</APPLIC><APPLIC>",str_trim(MS[,"APPLICABILITY"])), "</APPLIC>", sep = ""),
# Access is a little different, spaces and \ns
             TCAcPan = paste("<ACPAN>", gsub(" ","</ACPAN><ACPAN>",str_trim(gsub("\n","",MS[,"ACCESS"]))), "</ACPAN>", sep = ""),
             TCReference = paste("<REFERENCE>", gsub("\n","</REFERENCE><REFERENCE>",str_trim(MS[,"REFERENCE"])), "</REFERENCE>", sep = ""),
             TCEngApplic = "<ENGAPPL>ALL</ENGAPPL>",
             TCRef = gsub("-","",str_sub(REFERENCE,1,14)),
             TCSource = paste("<SOURCE>", gsub("\n","</SOURCE><SOURCE>",str_trim(MS[,"SOURCE"])), "</SOURCE>", sep = ""),
#Work on Intervals
             TCST = gsub("\n"," ",ST), 
             TCSI = gsub("\n"," ",SI),
             TCThres = gsub("\n"," ",T),        
             TCInt = gsub("\n"," ",I)
             )

# Remove all the NA variables
        MS[grep("<ZONE>NA</ZONE>",MS[,"TCZone"]),"TCZone"] = ""
        MS[grep("<APPLIC>NA</APPLIC>",MS[,"TCApplic"]),"TCApplic"] = ""
        MS[grep("<ACPAN>NA</ACPAN>",MS[,"TCAcPan"]),"TCAcPan"] = ""
        MS[grep("<REFERENCE>NA</REFERENCE>",MS[,"TCReference"]),"TCReference"] = ""
        MS[grep("<SOURCE>NA</SOURCE>",MS[,"TCSource"]),"TCSource"] = ""
        MS[which(is.na(MS[,"TCRef"])),"TCRef"] = ""
        MS[grep("[A-Za-z]",MS[,"TCRef"]),"TCRef"] = ""
        
################################################
## Testing Script on a sample matrix R of 15 entries
################################################
#x <- sample_n(MS,15)
MS <- mutate(MS,TC = paste("<!DOCTYPE taskcard PUBLIC \"-//PAL-AED//DTD TASKCARD//EN\"[",'\n',
                "<!ENTITY % graphics SYSTEM \"AMM.SGE\">",'\n',
                "<!ENTITY amp \"&\">",'\n',
                "%graphics;",'\n',"]>",'\n',
                "<TASKCARD CARDNBR=\"",CardNo,"\" MPROG=\"sys\" CHG=\"U\" KEY=\"PAL",gsub("-","",CardNo),"\" WODATE=\"\" TAIL=\"\" STATION=\"\" WO=\"\" CARDREVDATE=\"",CardRevDate,"\" REVNUM=\"01\" STATUS=\"DRAFT\">",'\n',
                "<EFFECT></EFFECT>",'\n',
                "<MAINHEAD>",'\n',
                ifelse(TCSource == "","",paste(TCSource,'\n',sep = "")),
                "<REFDATA>",'\n',
                ifelse(TCReference =="","",paste(TCReference,'\n',sep ="")),
                "</REFDATA>",'\n',
                "<SKILL></SKILL>",'\n',
                "<WORKAREA></WORKAREA>",'\n',
                "<INTDATA>",'\n',
			"<SAMPLEINTERVAL>",'\n',
				"<SAMPLETHRSHOLD>",paste(TCST,sep = ""),"</SAMPLETHRSHOLD>",'\n',
				"<SAMPLEREPEAT>",paste(TCSI,sep = ""),"</SAMPLEREPEAT>",'\n',
			"</SAMPLEINTERVAL>",'\n',
			"<INTERVAL>",'\n',
				"<THRSHOLD>",paste(TCThres,sep = ""),"</THRSHOLD>",'\n',
				"<REPEAT>",paste(TCInt,sep = ""),"</REPEAT>",'\n',
			"</INTERVAL>",'\n',
                "</INTDATA>",'\n',
                "<TASKTYPE>",ifelse(TASK.CODE == "","",TASK.CODE),"</TASKTYPE>",'\n',
                "<TITLE>",DESCRIPTION,"</TITLE>",'\n',
                "<APAPDATA>",'\n',
                ifelse(TCApplic== "","",paste(TCApplic,'\n',sep = "")),
                "</APAPDATA>",'\n',
                "<ENAPDATA>",'\n',
                ifelse(TCEngApplic == "","",paste(TCEngApplic,'\n',sep = "")),
                "</ENAPDATA>",'\n',
                "<ZDATA>",'\n',
                ifelse(TCZone == "","",paste(TCZone,'\n',sep ="")),
                "</ZDATA>",'\n',
                "<ACDATA>",'\n',
                ifelse(TCAcPan == "","",paste(TCAcPan,'\n',sep ="")),
                "</ACDATA>",'\n',
                "</MAINHEAD>",'\n',
                "<TCBODY>",
                sep = ""))
# write all cards
#write.table(x[1,27],"x.sgm",col.names = FALSE, row.names = FALSE,quote = FALSE)

for (a in 1:dim(MS)[[1]])
        write.table(MS[a,"TC"],paste(pathtoOutput,MS[a,"CardNo"],".sgm",sep = ""),col.names = FALSE, row.names = FALSE,quote = FALSE)


#write the data for the card
        TCRef <- select(MS,CardNo,TCRef)
        write.table(TCRef,file = "TCRef.csv",sep = ",",col.names = FALSE, row.names = FALSE)
