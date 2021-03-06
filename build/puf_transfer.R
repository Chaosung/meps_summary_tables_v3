
### NOTE! If you update the meps_file_names.csv, run puf_update.R first to create puf_names.csv ###

print("transferring new PUF files from meps.ahrq.gov to C:/MEPS")
Sys.sleep(1)

suppressMessages(library(dplyr))

rm_empty <- function(vec) vec[vec!=""]

downloadSSP <- function(filename){
  file.ssp = paste0(filename,".ssp")
  file.alt = file.ssp %>% sub("h","hc",.)
  if(filename == "h06r") file.alt = "hc006r.ssp"
  all_files = tolower(list.files())
  if(any(c(file.ssp,file.alt) %in% all_files)) return(sprintf("File %s already loaded",filename))
  
  url = sprintf('https://meps.ahrq.gov/mepsweb/data_files/pufs/%sssp.zip',filename)
  download.file(url, temp <- tempfile())
  unzipped_file = unzip(temp)
  unlink(temp)
}

################################################

# setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

# Load MEPS names from csv
meps_names <- read.csv("../mepstrends/hc_tables/shared/puf_names.csv",stringsAsFactors = F)

meps_names_fyc <- meps_names %>% select(FYC) %>% rm_empty
meps_names_RX   <- meps_names %>% select(RX.Events) %>% rm_empty
meps_names_evnt <- meps_names %>% select(Events) %>% rm_empty
meps_names_cond <- meps_names %>% select(Conditions) %>% rm_empty
meps_names_CLNK <- meps_names %>% select(CLNK) %>% rm_empty
meps_names_RXLK <- meps_names %>% select(RXLK) %>% rm_empty


setwd("C:/MEPS/") # target directory

lapply(meps_names_fyc,downloadSSP)
lapply(meps_names_RX,downloadSSP)
lapply(meps_names_cond,downloadSSP)
lapply(meps_names_CLNK,downloadSSP)
lapply(meps_names_RXLK,downloadSSP)

for(letter in letters[2:8]){
  event_files <- gsub("\\*",letter,meps_names_evnt)
  lapply(event_files,downloadSSP)
}

print("...PUF transfer completed")
Sys.sleep(1)