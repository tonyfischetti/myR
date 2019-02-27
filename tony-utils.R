
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

.env$delcols <- function(DT, ...){
  cols <- c(...)
  DT[, (cols):=NULL]
}

.env$keepcols <- function(DT, ...){
  cols <- c(...)
  these <- setdiff(names(DT), cols)
  delcols(DT, these)
}

.env$getxtab <- function(DT, theby){
  tmp <- DT[, .N, theby][order(-N)]
  thetotal <- tmp[, sum(N)]
  tmp[, percent:=round(N/thetotal*100, 2)]
  tmp2 <- tmp[1,]
  tmp2[1,1] <- "TOTAL"
  tmp2[1,2] <- thetotal
  tmp2[1,3] <- 100
  rbind(tmp, tmp2)
}

attach(.env)


