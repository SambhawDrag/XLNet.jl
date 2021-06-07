# XLNet.jl
A Julia based implementation of XLNet: A Generalized Autoregressive Pretraining for LU. (Flux and JuliaText)

### What is XLNet?
XLNet is an generalized autoregressive pretraining for language understanding. The [XLNet paper](https://arxiv.org/abs/1906.08237) combines recent advances in NLP with innovative choices in how the language modelling problem is approached. When trained on a very large NLP corpus, the model achieves state-of-the-art performance for the standard NLP tasks that comprise the GLUE benchmark.

XLNet is an *auto-regressive* language model which outputs the **joint probability** of a sequence of tokens based on the [**Transformer**](https://arxiv.org/abs/1901.02860) architecture with recurrence. Its training objective calculates the probability of a word token conditioned on **all permutations of word tokens in a sentence, as opposed to just those to the left or just those to the right of the target token**.

## Work Checkpoints 
#### Dated : 04-06-2021
- [ ] Convert pre-train weights to bson
- [ ] Create tokenizer : sentence-piece 
- [ ] Add as xlnet_tokenizer.jl
- [ ] Wrapper for transformer-XL with features essential to XLNet
- [ ] ...

### Status
In progress

## References
1. [**XLNet: Generalized Autoregressive Pretraining for Language Understanding** - _arxiv.org_](https://arxiv.org/abs/1906.08237)
2. [**Understanding XLNet** - _Borealis AI_](https://www.borealisai.com/en/blog/understanding-xlnet/)
3. [**Understanding Language using XLNet with autoregressive pre-training** - _medium.com_](https://medium.com/@zxiao2015/understanding-language-using-xlnet-with-autoregressive-pre-training-9c86e5bea443)
