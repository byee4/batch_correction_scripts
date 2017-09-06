# Title     : TODO
# Objective : TODO
# Created by: brianyee
# Created on: 8/18/17
suppressPackageStartupMessages(library("argparse"))
suppressPackageStartupMessages(library("SCnorm"))

# library(BiocParallel)
# register(MulticoreParam())
# register(SerialParam())

parser <- ArgumentParser()

parser$add_argument("--counts", type="character", nargs='+')
parser$add_argument("--conditions", type="character", nargs='+')
parser$add_argument("--ditherCounts", action="store_true")
parser$add_argument("--outdir", type="character")
args <- parser$parse_args()

datas <- list()
conditions <- list()

batch <- 0
# append each counts table as a separate batch
for (count in 1:length(args$counts)) {
    batch = batch + 1
    cond = args$conditions[count]
    print(paste0("reading in ", args$counts[count]))
    countData <- read.table(args$counts[count],  comment.char="#", header=TRUE, row.names=1, sep='\t')


    colnames(countData) <- paste(colnames(countData), paste(cond, batch, sep='_'), sep = "_")
    print(countData[1:5,1:5])
    print(dim(countData))
    datas[[length(datas)+1]] <- countData
    conditions <- c(conditions, rep(c(cond), each=length(colnames(countData))))
    # pdf(paste0("check_count-depth_evaluation",batch,".pdf"), height=5, width=7)
    # countDeptEst <- plotCountDepth(  # in latest devel version but not stable
    #     Data = countData, Conditions = rep(c(batch), length(colnames(countData))),
    #     FilterCellProportion = .1, NCores=4
    # )
    # dev.off()
}
dat <- Reduce(merge, lapply(datas, function(x) data.frame(x, rn = row.names(x))))
rownames(dat) <- dat$rn
dat$rn <- NULL
conditions <- unlist(conditions, recursive=FALSE)
dim(dat)
# plot the un normalized expression in each batch


pdf(paste(args$outdir,"MyNormalizedData_k_evaluation.pdf",sep="/"))
par(mfrow=c(2,2))
dataNorm <- SCnorm(Data = dat,
    Conditions = unclass(factor(conditions)),
    PrintProgressPlots = TRUE,
    FilterCellNum = 10,
    NCores=8,
    PropToUse=0.1,
    dither=args$ditherCounts
)

dev.off()

### in stable version but not devel ###

# i <- length(dataNorm)

# for (count in args$counts) {
#     write.table(
#         as.data.frame(dataNorm[i]),
#         paste("normalizedData",i,".txt", sep=''),
#         sep="\t",
#         col.names=TRUE,
#         row.names=TRUE
#     )
#     i = i + 1
# }

### in latest devel version but not stable: ###

normalizedData <- results(dataNorm)
genesNotNormalized <- results(dataNorm, type="GenesFilteredOut")
scaleFactors <- results(dataNorm, type="ScaleFactors")

write.table(normalizedData, paste(args$outdir,"normalizedData.txt",sep="/"), sep="\t")
write.table(genesNotNormalized, paste(args$outdir,"genesNotNormalized.txt",sep="/"), sep="\t")
write.table(scaleFactors, paste(args$outdir,"scaleFactors.txt",sep="/"), sep="\t")
