""" XLNet Tokenizer """

"""
The XLNet model uses the sentence-piece model as the sub-word tokenizer.
Sentence-piece is a statistical tokenizer that supports two algorithms: unigram-LM and BPE

Note: These are temporary doc-strings, will be edited.

WIP: Add function to read protocol buffer files from spiece.model 
"""


# Sentence Piece Structure :: SentencePieceModel
struct SentencePieceModel
    vocab_map::Dict{String, Tuple{Float64, Int}}
    unk_id::Int
end

# To initialize the tokenizer from the datadeps (vocab/json) :: load(ty::Type{T}, filenum::Int=1; unk_token="<unk>") where T<:PretrainedTokenizer
function load(ty::Type{T}, filenum::Int=1; unk_token="<unk>") where T<:PretrainedTokenizer
    filepath = @datadep_str tokenizer_files(ty)[filenum]
    name = tokenizer_files(ty)[filenum]
    filepath = "$filepath/$name"
    load_vocab(filepath, unk_token=unk_token)  
end

function load_vocab_from_protobuf(ty::Type{T}, filenum::Int=1; unk_token="<unk>") where T<:PretrainedTokenizer
    filepath = @datadep_str tokenizer_files(ty)[filenum]
    name = tokenizer_files(ty)[filenum]
    """WIP"""
end

# To initialize the SentencePieceModel by providing the `vocab filepath` :: load_vocab(path; unk_token="<unk>")
function load_vocab(path; unk_token="<unk>")
    vocab_path = readlines(path)
    vocabnlogp = split.(vocab_path, "\t")
    vocab_map = Dict(tok=>(parse(Float64, logp), index) for (index, (tok, logp)) in enumerate(vocabnlogp))

    if haskey(vocab_map, unk_token)
        unk_id = vocab_map[unk_token][2]
    else
        throw(DomainError(unk_token, "Unknown token is not in the vocabulary"))
    end 

    spm = SentencePieceModel(vocab_map, unk_id)
    return spm
end

# Utility structure, To hold the results of the `forward pass` (the forward Viterbi lattice) :: Nodes (struct)
"""
holds
    text::String     : token string
    Score::Float32   : score
    index::Int64     : vocabulary index
    start::Int       : start character position
    en::Int          : end character position
"""
struct Nodes 
    text::String
    score::Float32
    index::Int64
    start::Int
    en::Int
end

# Perform a forward pass to get the forward Viterbi lattice : decode_forward(sp::SentencePieceModel, text::String) 
# Ref.[--- BLOG ---]
"""
    decode_forward(sp::SentencePieceModel, text::String) - Takes model structure and String
    returns results : Array{Nodes,1}
"""
function decode_forward(sp::SentencePieceModel, text::String)
    results = Array{Nodes, 1}(undef, lastindex(text)) 
    scores = fill(-Inf, lastindex(text))
    scores[1] = 0

    for char_end in eachindex(text)

        for char_start in eachindex(text)
            char_start > char_end && break
            subtoken = SubString(text, char_start:char_end)
            if haskey(sp.vocab_map, subtoken)
                subtokenid =  sp.vocab_map[subtoken][2]
                local_score = scores[char_start] + sp.vocab_map[subtoken][1]
                if local_score > scores[char_end]   
                    results[char_end] = Nodes(SubString(text, char_start:char_end), local_score, subtokenid, char_start, char_end)
                    scores[char_end] = local_score
                end
            end
        end

        if scores[char_end] == -Inf
            results[char_end] = Nodes(SubString(text, prevind(text, char_end):char_end), -Inf, 1, char_end-1, char_end)
            scores[char_end] = 0
        end

        if scores[char_end] == 0
            results[char_end] = Nodes(SubString(text, char_end:char_end), -Inf, 1, char_end, char_end)
        end

    end

    return results
end

# Perform a backward pass : decode_backward(sp::SentencePieceModel, nodes::Array{Nodes,1}, text::AbstractString) 
# Ref.[--- BLOG ---]
"""
    decode_backward(sp::SentencePieceModel, nodes::Array{Nodes,1}, text::AbstractString) 
    - Takes model strcuture, nodes (i.e. output of `decode_forward`), and String
    returns best_seq : Array{Nodes,1}
"""
function decode_backward(sp::SentencePieceModel, nodes::Array{Nodes,1}, text::AbstractString)
    next_nodes = nodes[end]
    best_seq = Nodes[]
    
    while next_nodes.start > 1
        node_value = next_nodes
        next_nodes = nodes[prevind(text, node_value.start)]
        push!(best_seq, node_value)
    end
    push!(best_seq, next_nodes)
    return best_seq
end


# To perform the preprocessing followed by forward decoding and backward decoding
"""
    tokenizer(sp::SentencePieceModel,text::AbstractString)
    preprocessing --> decode_forward --> decode_backward
    output tokenized tokens as: Array{String,1}
"""
function tokenizer(sp::SentencePieceModel, text::AbstractString)
    text = replace(text, " " => "▁")
    if text[1] != '▁'
        text = "▁" * text
    end
    output = decode_forward(sp, text)
    tokens = decode_backward(sp, output, text)
    tokens = reverse(tokens)
    tks = [node.text for node in tokens]
    return tks
    
end

# To perform the preprocessing followed by forward decoding and backward decoding
"""
    (sp::SentencePieceModel)(text::AbstractString)
    preprocessing --> decode_forward --> decode_backward
"""
function (sp::SentencePieceModel)(text::AbstractString)
    tokenizer(sp, text)
end

# To get the ids from the tokens : ids_from_tokens(spm::SentencePieceModel, tk::Array{String,1}) 
"""
    ids_from_tokens(spm::SentencePieceModel, tk::Array{String,1})
    Given tokens it provide its indices
"""     
function ids_from_tokens(spm::SentencePieceModel, tk::Array{String,1})  
    map(tk) do x
        last(get(spm.vocab_map, x, spm.unk_id))
    end
end

# To get sentence from the tokens
"""
    sentence_from_tokens(tk::Array{String,1})
    Given tokens it provide its sentences
"""
function sentence_from_tokens(tk::Array{String,1})
    sen = join(tk)
    sen = replace(sen, "▁" => " ")
    sen = strip(sen)
    return sen     
end