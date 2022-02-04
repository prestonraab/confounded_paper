# Adversarial deep neural networks remove nonlinear batch effects from gene-expression data

This will run the entire analysis: downloading and tidying the data, batch adjusting the data, calculating metrics, and making charts and tables. It takes around 4 hours to run to completion.

After running, the output figures and tabless will be in `code/data/output/`.

Dependencies:

- R
- Python >=3.6
- Pandas
- Scikit-Learn
- Numpy
- wget

```bash
cd code/
bash run_all.sh
```
