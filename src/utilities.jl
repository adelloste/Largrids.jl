"""
    binaryRange(n)

Generate the first `n` binary numbers in string padded for max `2^n` length
"""
function binaryRange(n)
    return string.(range(0, length=2^n), base=2, pad=n)
end
