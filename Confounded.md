# Abstract

Gene-expression profiling enables researchers to quantify transcription levels in cells, thus providing insights into functional mechanisms of diseases and other biological processes. However, due to the high dimensionality of these data and the sensitivity of measuring equipment, expression data often contain unwanted confounding effects that can skew analyses. For example, collecting data in multiple runs can cause nontrivial differences in the data known as batch effects. In addition, covariates that are not of interest to the study may have strong effects on gene expression. Furthermore, 
%and there may be systemic effects when integrating multiple datasets.
These confounding effects may be driven by higher-order interactions that are not removable using existing techniques that identify linear patterns.
We created *Confounded* to remove these effects from expression data.
[@Please modify the following sentence to better reflect the dual-objective aspect and the fact that it uses neural networks.@] % duel objective meaning remove the effects and effectively replicate the origional expression levels/data? 
Confounded is an adversarial variational autoencoder that removes confounding effects while minimizing the amount of change to the input data.
We tested the model on artificially constructed data and three gene-expression datasets and compared against other batch-adjustment algorithms.
Our software is available at \url{https://github.com/jdayton3/Confounded}.

### Keywords

Computational workflows, command-line software, research reproducibility, Common Workflow Language, Web application, learn by example

# Introduction


# Discussion 


# Declarations

*Ethics approval and consent to participate*

Not applicable.

*Consent for publication*

Not applicable.

*Availability of data and material*

The source code and examples are located at ...

*Competing interests*

The authors declare that they have no competing interests.

*Funding*



*Authors' contributions*



%*Acknowledgements*



{{tables}}

{{figures}}

{{data}}
