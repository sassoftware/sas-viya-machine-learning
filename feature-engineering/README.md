# Code Examples for Feature Engineering

## one-hot expansion
Provided by: Biruk Gebremariam

This code example does one-hot expansion for nominal features. 
You can do one-hot encoding using transform/cattrans action. However, the outputs from these actions is in SPARSE format. The attached code snippet shows how you can generate the traditional one-hot encoding (dense/expanded format) using this sparse format + simple data step code.
