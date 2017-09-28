# Title     : Tutorial script for running COMBAT (SVA).
# Vignette  : http://bioconductor.org/packages/release/bioc/vignettes/sva/inst/doc/sva.pdf
#             last compiled: June 19, 2017
# Objective : Use this as reference for building lego brick.
# Created by: brianyee
# Created on: 9/27/17

library(sva)
library(bladderbatch)
data(bladderdata)

pheno = pData(bladderEset)
# The expression data can be obtained from the expression slot of the expression set.
edata = exprs(bladderEset)

batch = pheno$batch
# Just as with sva, we then need to create a model matrix for the adjustment variables, including the
# variable of interest. Note that you do not include batch in creating this model matrix - it will be included
# later in the ComBat function. In this case there are no other adjustment variables so we simply fit an
# intercept term.
modcombat = model.matrix(~1, data=pheno)
# Note that adjustment variables will be treated as given to the ComBat function. This means if you
# are trying to adjust for a categorical variable with p different levels, you will need to give ComBat p-1
# indicator variables for this covariate. We recommend using the model.matrix function to set these
# up. For continuous adjustment variables, just give a vector in the containing the covariate values in a
# single column of the model matrix.
# We now apply the ComBat function to the data, using parametric empirical Bayesian adjustments.
pdf("data/reference/plot.prior.pdf")
combat_edata = ComBat(dat=edata, batch=batch, mod=modcombat, par.prior=TRUE, prior.plot=TRUE)
dev.off()
write.table(combat_edata, "data/reference/normalized.tsv", sep="\t", quote=FALSE)