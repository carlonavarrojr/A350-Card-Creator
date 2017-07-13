# A350-Initial-Card-Creator"
# Description
This Program is an alternative to the JITCG Program which creates a set of baseline taskcards from the current AMM.sgm and the excel MS excel file.
Output Files are individual cover page sgm task cards with
	1. data coming from the MS file
	2. card body coming from a SampleCard.sgm (cover card)
	3. and an added pdfattach line for the ammpdf that will be attached to the card.
This program assumes the individual AMM.pdfs are in the pdfattach folder of the card creator

# Files / Folders:
- CreateBaseCards 	- Bash program which is the main program to call to create the base cards  
		1. Calls on JITCG.R which creates the first half of the cards from the MS Excel <MAINHEAD>
		2. Attaches a common cover page for all cards: Do per AMM XXXX.
		3. Uses TCRef.csv to modify the cover page to indicate the AMM References 
		3. Uses TCRef.csv to attach a <PDFATTACH> for the pdf AMM
- /System 		- Contains the programs needed to run 
- /Output		- Folder where the output files are going to be created
- CreateBaseCards.R 	- Contains the R program which is called from ./CreateBaseCards.
	  		- This program Creates the first half of the cards (header) from the MS Excel
	  		- Inputs are var.txt and output is TCRef.csv
- var.txt 		- txt file which contains variables which will be passed from ./CreateBaseCards to CreateBaseCards.R
- TCRev.csv 		- A file which has the Task Card Number and the AMM Reference. 
			- Used by ./CreateBaseCards to search AMM.SGM to attach to the card
			- Contains two variables: CardNo, and AMMRef (Condensed) 
- SampleCard.sgm	- Sample Body which will be copied into the task card being created. 

# Variables:	- these are asked by CreateBaseCards. assumes you are in the System folder
- pathtoMS	- full path to MS Excel file.
- pathtoOutput 	- output location where Cards will be created

# Required Inputs:
- MS Excel	- Consolidated MS Excel file. Assumes this is at Sheet 1, Row 2 has headers, 15 Columns are taken in
- SampleCard.sgm - the similar cover page card that will be used for all cards. AMM reference will be chanced bassed on the AMM reference read from the MS excel file.

