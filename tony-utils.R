
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

pivot <- function(DT, theby, theexp, cutoff=0){
  inexp <- substitute(theexp)
  strexp <- as.character(deparse(inexp))
  template <- sprintf("DT[, .(val=%s), theby][order(-val)]", strexp)
  tmp <- eval(parse(text=template))
  thetotal <- tmp[, sum(val)]
  tmp[, percent:=round(val/thetotal*100, 2)]
  tmp[percent<=cutoff, (theby):="OTHER"]
  tmp <- tmp[, .(val=sum(val), percent=sum(percent)), theby]
  tmp2 <- tmp[1,]
  tmp2[1,1] <- "TOTAL"
  tmp2[1,2] <- thetotal
  tmp2[1,3] <- 100
  rbind(tmp, tmp2)
}

cleannames <- function(dat){
  thenames <- names(dat)
  nospace <- stringr::str_replace_all(thenames, "\\s+", "_")
  nobad <- stringr::str_replace_all(nospace, "[^_A-Za-z1-9]", "_")
  return(nobad)
}

setcleannames <- function(dat){
  setnames(dat, cleannames(dat))
}


attach(.env)


