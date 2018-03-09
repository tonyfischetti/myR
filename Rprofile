
##############################################
###                                        ###
###   Tony Fischetti's default R profile   ###
###                                        ###
###             tony.fischetti@gmail.com   ###
###                                        ###
##############################################      

# set default CRAN mirror
local({r <- getOption("repos")
      r["CRAN"] <- "https://cran.revolutionanalytics.com/"
      options(repos=r)})


#############
## OPTIONS ##
#############

options(stringsAsFactors=FALSE)    # stringsAsFactors=HELLNO
options(max.print=100)          
options(scipen=10)                 # no scientific notation
options(editor="vim")              # the best there is
options(warn = 2)                  # warnings as errors
options(useFancyQuotes = FALSE)    # just no
options(menu.graphics=FALSE)       # no time for Tk to load
options(width = 80)
options(prompt="> ")
options(continue="... ")           # helps me realize when I forget to close (

utils::rc.settings(ipck=TRUE)      # tab complete package names

# pretty colors
library("colorout")

# I never want to save, fam
q <- function (save="no", ...) {
  quit(save=save, ...)
}


# set up .Rhistory dump
.First <- function(){
  if(interactive()){
    library(utils)
    timestamp(,prefix=paste("##------ [",getwd(),"] ",sep=""))

  }
}

.Last <- function(){
  if(interactive()){
    hist_file <- Sys.getenv("R_HISTFILE")
    if(hist_file=="") hist_file <- "~/.Rhistory"
    savehistory(hist_file)
  }
}



######################
## CUSTOM FUNCTIONS ##
######################

.env <- new.env()

# provides a way to open a data frame in a spreadsheet application (Unix only!)
.env$look <- function(df, n=99, sleep=5, short.sleep=1){
  thename <- deparse(substitute(df))
  if(n > 0 && n < nrow(df)){
    df <- df[1:n,]
  }
  fname <- paste0("/tmp/", thename, ".csv")
  write.csv(df, fname)
  # give R time to finish writing file before trying to open it
  Sys.sleep(short.sleep)
  system(paste0("open ", fname))
  # give the application time to open it before destroying file
  Sys.sleep(sleep)
  system(paste0("rm ", fname))
}

.env$bici <- function(a.sample, sims=10000, type="bca", cores=0){
  if(is.character(a.sample) || is.factor(a.sample)) return(NA)
  if(cores==0) cores <- parallel::detectCores()
  dasboot <- boot::boot(a.sample, function(x, i){mean(x[i])}, sims,
                             parallel="multicore", ncpus=cores)
  dascis <- boot::boot.ci(dasboot , type="bca")
  retval <- c(dascis[[type]][4], dascis[[type]][5])
  names(retval) <- c("|.95", ".95|")
  return(retval)
  #return(sprintf("%.2f <-> %.2f", dascis[[type]][4], dascis[[type]][5]))
}

attach(.env)

message("\n*** Successfully loaded .Rprofile ***\n")
