# CSAG common scripts
# FILE NAME findANDcopy.r

##### FOR OS COMPATIBILITY
if(Sys.info()["sysname"]=="Linux"){
	osSep<-"/"
	print(paste('Linux OS detected','please use the following Path Separator',osSep,sep=" > "),quote=FALSE)
}
if(Sys.info()["sysname"]=="Windows"){
	osSep<-"\\"
	print(paste('!! UNVERIFIED !!','Windows OS detected','please use the following Path Separator',osSep,sep=" > "),quote=FALSE)
}
if(Sys.info()["sysname"]=="Mac"){
	osSep<-"?"
	print(paste('!! NOT ACTIVATED !!','Mac OS detected','please use the following Path Separator',osSep,sep=" > "),quote=FALSE)
}

#####
# FUNCTION findANDcopy
# AUTHOR olivier crespo
# DATE 2015-09-15
#####
# sometimes I want a specific station from a specific GCM,
# sometime I want a specific station from a run
# so that there is not always the same number of levels down to the station
# here is a script that doesn't care
##### testing default
# souFolder <- '/terra/data/downscaled/lcoop/1950-2100/dscl-pca.v2.5.3/sa_stations_2012_era_int_1950-2100/run_0'#/bcc-csm1-1-rcp45/ppt/'
# desFolder <- '/home/olivier/Desktop/Optimisation/CSAGcode/extract-data-files/TMP'
# staList <- c('0766715_5.txt','0766898_.txt')
#####
# typical call
# findANDcopy('Path/To/Source/Folder','Path/To/Destination/Folder',c('staName1.txt','staName2.txt',ect))
# readIn : path to source folder, sequentially dug in from there : char.string
# writeIn : path to destination folder : char.string
# staNames  : list of stations full names to extract : c(char.string,char.string,...)
# found : forget about it unless you change the code
#####
findANDcopy <- function(readIn=souFolder,writeIn=desFolder,staNames=staList,found=FALSE)
{
print("-->",quote=FALSE)
	
	# is there more folder to explore?
	dirs <- list.dirs(readIn,full.names=FALSE,recursive=FALSE)
	
	# are the stations here?
	filesNdirs <- list.files(readIn,recursive=FALSE,all.files=FALSE,include.dirs=FALSE) # despite the argument include.dirs above, directory is a file for R :(
	for (s in staNames){
		if(any(filesNdirs==s)){
			found <- TRUE
			print(paste('hit',s,sep=" "))
			if(!file.exists(writeIn)){
				dir.create(writeIn,recursive=TRUE)
			}			
			file.copy(from=paste(readIn,s,sep=osSep),to=paste(writeIn,s,sep=osSep))
		}
	}
	
	# if no files and more directories
	if (length(dirs)>0 & !found){
		for (d in dirs){
			# call itself :) recursive
			findANDcopy(paste(readIn,d,sep=osSep),paste(writeIn,d,sep=osSep),staNames,found)
		}
	}

print("<--",quote=FALSE)
}
