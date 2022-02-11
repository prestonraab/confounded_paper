# Abstract

Gene-expression profiling enables researchers to quantify transcription levels in cells, thus providing insights into functional mechanisms of diseases and other biological processes. However, due to the high dimensionality of these data and the sensitivity of measuring equipment, expression data often contain unwanted confounding effects that can skew analyses. For example, collecting data in multiple runs can cause nontrivial differences in the data known as batch effects. In addition, covariates that are not of interest to the study may have strong effects on gene expression. These confounding effects may be influenced by higher-order interactions that are nonlinear, whereas the most commonly used batch-correction methods use linear models. We created *Confounded*, which uses an adversarial variational autoencoder to learn latent representations of the data in an unsupervised manner while simultaneously optimizing against a loss function that penalizes its ability to discriminate batch labels. We tested the model on simulated data and [TODO]three gene-expression datasets and compared against other batch-adjustment algorithms.[TODO:Results,Discussion] Our software is licensed under the Apache 2.0 license and is freely available at https://github.com/jdayton3/Confounded[TODO].

%Furthermore, when researchers integrate datasets from diverse sources...

### Keywords

Gene-expression analysis, batch effects, deep learning, variational autoencoder, open-source software

# Background

Gene-expression data can advance our understanding of medicine and biology. For example, gene-expression data have helped to discover conserved genetic modules[@stuart_gene-coexpression_2003], to explain mechanisms of cardiovascular disease[@henriksen_application_2002], to more accurately predict clinical outcomes for cancer patients[@veer_gene_2002], and to discover effective drugs for treating specific diseases[@sirota_discovery_2011]. Gene-expression profiling technologies typically generate tens of thousands of measurements per sample, representing most genes in the human transcriptome. When researchers generate these data, biases can arise to complicate downstream analyses. Seemingly minor differences in processes or environmental conditions may cause batch effects[@leek_tackling_2010]. In one study, researchers found that, contrary to prior knowledge, expression values from mice and humans clustered more closely by species than by tissue type[@yue_comparative_2014]; however, a later rebuttal showed that when accounting for batch effects, the biological samples clustered more closely by tissue type than by species, as initially expected[@gilad_reanalysis_2015]. Covariates such as sex, race, age, or tissue type are another source of bias in gene-expression studies. Although these sources of variation may reflect true biological differences, they often confound the primary question being investigated. Some quantitative methods provide a way for covariates to be modeled explicitly; however, many methods are not suited to accounting for covariates directly. For example, Dayton and Piccolo performed a pan-cancer analysis, using machine-learning algorithms to infer somatic-mutation status from gene-expression patterns and to cluster genes[@dayton_classifying_2017-1]. The tumors' tissue of origin was highly correlated with gene-expression levels. This signal was so strong that each tumor's tissue of origin could be predicted with near-perfect accuracy using a machine-learning classifier. The primary goal of this study was to identify patterns that spanned multiple cancer types, so tissue specificity was a confounding effect. A third source of bias occurs when researchers combine data across studies.

TODO:
  lazar_batch_2013 discusses using batch correction to combine datasets
  This one does too (I think): https://academic.oup.com/bioinformatics/article/36/8/2486/5697085?login=true
  Cite one or more of these studies to describe the problem of data integration:
    https://www.ncbi.nlm.nih.gov/pmc/articles/PMC2950414/
    https://academic.oup.com/bib/article/22/3/bbaa169/5892357?login=true
    Perhaps this one though maybe focused on multimodal: https://www.frontiersin.org/articles/10.3389/fgene.2017.00084/full

Methods exist to address each of these problems; however,...



%TODO: Move this to Discussion as a future issue to tackle?
%Finally, data integration is a key goal for gene-expression analyses \citep{lazar_batch_2013}.
%As sample sizes increase, so can statistical significance.
%Although batch effects within a single dataset may be somewhat decreased by careful replication of experimental conditions, this is not possible when integrating different datasets. Methods used for batch correction may be used to correct for dataset-integration effects; however, this problem is
%however, , .

These biases represent cases where data measurements are affected by hidden variables and must be removed for effective analyses (see \figurename{} \ref{fig:workflow}).



Several methods exist for characterizing or removing batch effects from gene-expression data.
SVA uses singular value decomposition to model batch effects, which can then be accounted for in statistical analyses\citep{leek_capturing_2007}.
ComBat uses an empirical Bayes approach to estimate batch effect parameters and then uses linear regression to model and remove the effects\citep{johnson_adjusting_2007}.
Both of these techniques use linear methods to model confounding effects and thus may not account for nonlinear effects, such as multi-gene, cascading interactions within signaling pathways.
As machine learning becomes more common in biological research, these nonlinear confounding effects become more troublesome because many machine-learning algorithms can successfully identify such patterns, which may bias the algorithms' outputs.
%For example, advances in neural networks have introduced new ways to account for higher-order, nonlinear relationships in data.
%These networks have proven effective in removing irrelevant, domain-specific signal in credit-rating, online-review, and image-recognition tasks \citep{louizos_variational_2015}.

Artificial neural networks, a category of machine-learning algorithms, are inspired by the way human brains function; input values pass through layers of linear and nonlinear functions; the final output values are measured against specific objectives, and the function layers are adjusted to bring the outputs closer to the objectives; this process is repeated until the outputs are sufficiently close to their targets \citep{schmidhuber_deep_2015}.%There are a lot of semi colons here. Should we break up the sentence a little bit or reword?
Neural networks have been applied broadly to gene-expression data. For example, they have been used to detect cancer and identify critical cancer genes \citep{danaee_deep_2016}, to impute gene-expression levels from the values of a few ``landmark genes'' \citep{chen_gene_2016}, to extract biologically relevant latent spaces in RNA-Seq data \citep{way_extracting_2017}, to reduce the dimensions of single-cell RNA-Seq data \citep{lin_using_2017}, to identify drug-repurposing targets \citep{aliper_deep_2016}, and to generate synthetic biomedical data as a way to preserve patient privacy \citep{beaulieu-jones_privacy-preserving_2017}.

Progress has been made in using artificial neural networks to correct batch effects in expression data \cite{shaham_removal_2017,shaham_batch_2018,upadhyay_removal_2019}. % Was: Recent progress has been made ....
However, these methods are designed for a limited range of scenarios:
1) when the input data contain only two batches,
2) the batches are sufficiently large (batch sizes smaller than 100 failed in our testing), and
3) the batches are balanced.
These requirements rarely hold in applied research; for example, the \textit{bladderbatch} dataset---which is used to test batch-adjustment techniques\cite{leek_bladderbatch_2017,leek_sva_2017}---has 5 batches, 57 samples, and 4 to 19 samples per batch.
Additionally, papers that have described these methods have not evaluated whether nonlinear patterns remain in expression data after batch correction.
To address these limitations, we implemented a deep neural-network architecture that 1) has a batch output layer that expands to fit
the number of batches, 2) works on relatively small batch sizes by sampling with replacement from the training data, and 3) has
no formulas that require batches to be equal sizes.
Furthermore, we tested our method using machine-learning classification algorithms to quantify the extent to which nonlinear batch effects remain after adjustment.
% What is the difference between the first list and the second? Should we be consistant? 

Autoencoders are a type of neural network that encodes input data in a smaller number of dimensions than the original data and then reconstructs the data in the original dimensions\citep{hinton_reducing_2006}.
This technique can be used to reduce noise and thus refine the data representation.[@Make sure this wording is legit. - Are you referencing denoising autoencoders, or are you saying that vanilla autoencoders reduce noise? Either way, we might need a reference. -You would know better than me. Please clarify this based on what is relevant to the paper and add a relevant reference.@]
Typically, autoencoders are trained using an objective function that seeks to ensure that the output is as similar as possible to the input \citep{hinton_reducing_2006}.
However, neural networks are adept at finding subtle patterns in data;
thus the objective function may prioritize replication of confounding patterns, such as batch effects, rather than the signals of interest \citep{ganin_domain-adversarial_2015,louizos_causal_2017-2}.
Researchers have experimented with discouraging neural networks from learning such patterns by giving them two competing objective functions: % was: Recently, researchers ....
1) to maximize similarity between in the input and output data and
2) to ignore any patterns associated with known confounding variables \citep{ganin_domain-adversarial_2015,tzeng_deep_2014-2}.
For example, Louizos, et al. used this type of dual-objective function in combination with a variational autoencoder and successfully removed domain-based variability in credit scores, financial savings, and hospital admittance datasets \citet{louizos_variational_2015}.

In this study, we present \textit{Confounded}, an adversarial autoencoder that identifies and removes confounding effects from gene-expression data.
We test the hypothesis that using an adversarial neural network can correct for confounding effects more effectively than alternative tools.
We present a classification-based framework to assess the extent to which confounding effects remain after adjustment, and we apply these techniques to four datasets.


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
