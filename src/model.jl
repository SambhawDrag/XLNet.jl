# Model configuration and hyperparameters
using Flux

const config_large = Dict(                      # Description                 | Release param
    "model"                 => "xlnet-large",   #
    "ff_activation"         => gelu,            # hidden feed-forward act.    | ff_activation
    "attn_type"             => "bi",            # 
    "d_head"                => 64,              # 
    "d_inner"               => 4096,            # intermediate size           | d_inner
    "d_model"               => 1024,            # hidden size                 | d_model
    "hidden_dropout_prob"   => 0.1,             # 
    "n_head"                => 16,              # number of attention-heads   | d_head
    "n_layer"               => 24,              # number of hidden layers     | n_head
    "summary_activation"    => "tanh",          # 
    "summary_attn_dropout"  => 0.1,             # 
    "summary_type"          => "last",          # 
    "vocab_size"            => 32000,           # vocab_size                  | n_token
    "untie_r"               => true             # untie_r
)

const config_base = Dict(                       # Description                 | Release param
    "model"                 => "xlnet-base",    # 
    "ff_activation"         => gelu,            # hidden feed-forward act.    | ff_activation
    "attn_type"             => "bi",            # 
    "d_head"                => 64,              # 
    "d_inner"               => 3072,            # intermediate size           | d_inner
    "d_model"               => 768,             # hidden size                 | d_model
    "hidden_dropout_prob"   => 0.1,             # 
    "n_head"                => 12,              # number of attention-heads   | d_head
    "n_layer"               => 12,              # number of hidden layers     | n_head
    "summary_activation"    => "tanh",          # 
    "summary_attn_dropout"  => 0.1,             # 
    "summary_type"          => "last",          # 
    "vocab_size"            => 32000,           # vocabulary_size             | n_token
    "untie_r"               => true             # untie_r
)

# WIP